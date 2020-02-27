#!/bin/bash
#本脚本需要sox curl，使用apt(Debian)或yum(Centos)安装，建议安装libsox-fmt-all以支持更多格式音频
#生成频谱保存在~/Pictures/Spectrograms/中，并自动上传sm.ms图床


token=
#token留空使用匿名上传，如需加入自己的账号到https://sm.ms/home/apitoken生成token填入

if [ -z "$1" ]; then
	echo "Useage:"
	echo "spectrograms.sh [filename] [option]"
	echo "spectrograms.sh [filename] [starting time] [duration] [option]"
	echo "Option:"
	echo "	-u upload"
	echo "Example:"
	echo "spectrograms.sh ~/Music/example.flac -u"
	echo "	Generate default spectrogram and upload img to sm.ms."
	echo "spectrograms.sh ~/Music/example.flac 1:00 0:02"
	echo "	Generate spectrogram with a zoom from 1:00 to 1:02."
	exit 1
fi


date=$(date +%Y%m%d)
test -e "$HOME/Pictures" || mkdir "$HOME/Pictures"
test -e "$HOME/Pictures/Spectrograms" || mkdir "$HOME/Pictures/Spectrograms"
filename=$(basename "$1")
dirpath="$HOME/Pictures/Spectrograms/${date} $filename"
test -e "$dirpath" || mkdir "$dirpath"



sox "$1" -n remix 1 spectrogram -x 3000 -y 513 -z 120 -w Kaiser -o "$dirpath/$filename-full.png"
if [ -z "$3" ]; then
	sox "$1" -n remix 1 spectrogram -X 500 -y 1025 -z 120 -w Kaiser -S 1:00 -d 0:02 -o "$dirpath/$filename-zoom.png"
else
	sox "$1" -n remix 1 spectrogram -X 500 -y 1025 -z 120 -w Kaiser -S "$2" -d "$3" -o "$dirpath/$filename-zoom.png"
fi



#后面为文件上传

test "${!#}" -eq "-u" || exit 0

if [ -z "$token" ]; then
	xml_full=$(curl -X POST -F 'format=xml' -F "smfile=@$dirpath/$filename-full.png" https://sm.ms/api/v2/upload)
	xml_zoom=$(curl -X POST -F 'format=xml' -F "smfile=@$dirpath/$filename-zoom.png" https://sm.ms/api/v2/upload)
	else
	xml_full=$(curl -H "Authorization: $token" -X POST -F 'format=xml' -F "smfile=@$dirpath/$filename-full.png" https://sm.ms/api/v2/upload)
	xml_zoom=$(curl -H "Authorization: $token" -X POST -F 'format=xml' -F "smfile=@$dirpath/$filename-zoom.png" https://sm.ms/api/v2/upload)
fi
echo $filename-full.png > "$dirpath/xml"
echo $xml_full > "$dirpath/xml"
echo $filename-zoom.png > "$dirpath/xml"
echo $xml_zoom > "$dirpath/xml"


messages_full=${xml_full##*<message>}
messages_full=${messages_full%%</message>*}
echo "$filename-full.png" | tee -a "$dirpath/log.txt"
echo $messages_full | tee -a "$dirpath/log.txt"

if [ "${messages_full}" = "Upload success." ]; then
	page_full=${xml_full##*<page>}
	page_full=${page_full%%</page>*}
	echo "Page:   $page_full" | tee -a "$dirpath/log.txt"
	url_full=${xml_full##*<url>}
	url_full=${url_full%%</url>*}
	echo "Url:    $url_full" | tee -a "$dirpath/log.txt"
	echo "BBCode: [url=$page_full][img]$url_full[/img][/url]" | tee -a "$dirpath/log.txt"
	del_full=${xml_full##*<delete>}
	del_full=${del_full%%</delete>*}
	echo "Del:    $del_full" | tee -a "$dirpath/log.txt"
fi

messages_zoom=${xml_zoom##*<message>}
messages_zoom=${messages_zoom%%</message>*}
echo "$filename-zoom.png" | tee -a "$dirpath/log.txt"
echo $messages_zoom | tee -a "$dirpath/log.txt"

if [ "${messages_zoom}" = "Upload success." ]; then
	page_zoom=${xml_zoom##*<page>}
	page_zoom=${page_zoom%%</page>*}
	echo "Page:   $page_zoom" | tee -a "$dirpath/log.txt"
	url_zoom=${xml_zoom##*<url>}
	url_zoom=${url_zoom%%</url>*}
	echo "Url:    $url_zoom" | tee -a "$dirpath/log.txt"
	echo "BBCode: [url=$page_zoom][img]$url_zoom[/img][/url]" | tee -a "$dirpath/log.txt"
	del_zoom=${xml_zoom##*<delete>}
	del_zoom=${del_zoom%%</delete>*}
	echo "Del:    $del_zoom" | tee -a "$dirpath/log.txt"
fi