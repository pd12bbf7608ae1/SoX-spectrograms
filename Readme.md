# SoX-spectrograms

使用 SoX(Sound eXchange) 和 curl 进行音频文件频谱生成并上传sm.ms图床的bash脚本工具。

## 依赖安装

脚本依赖 sox curl 命令，在CentOS与Ubuntu的软件仓库中均存在，可以直接安装。

## 使用脚本前的建议

### 修改脚本的参数

在脚本文件前有一系列的参数设置，至少需要修改：

- dirpath (结果保存目录)

这个选项，以便脚本保存相关信息，默认目录为：

`$HOME/Pictures/Spectrograms`

请按照个人的习惯进行修改，并保证脚本使用者对该目录有写入的权限。

### 将脚本保存位置添加到 PATH 变量中并增加执行权限

这有利于从任何文件夹方便调用本脚本。

### 去 sm.ms 图床注册个账号

虽然使用匿名上传也是可行的，但上传后会难以对图片进行管理（需要查看相关日志）。
注册完毕后在 https://sm.ms/home/apitoken 中生成 token 填入 token 变量中以便将文件保存在你的账户下。

## 用法

假定脚本文件放入`$PATH`目录下并命名为`spectrograms.sh`

`spectrograms.sh [filename] [option]`

或者

`spectrograms.sh [filename] [starting time] [duration] [option]`

### 参数列表

|选项|描述|
| ------------ | ------------ |
|`-u`|将截图上传至 sm.ms 图床并显示相关信息|

### 例子

`spectrograms.sh ~/Music/example.flac -u`

使用默认参数生成频谱图并上传图床。

`spectrograms.sh ~/Music/example.flac 1:00 0:02`

使用自定义参数生成放大图像。

## 致谢

1. 感谢[Sound eXchange](http://sox.sourceforge.net/ "Sound eXchange")提供的强大音频处理工具；
1. 感谢[sm.ms图床](https://sm.ms/ "sm.ms图床")提供的免费、可靠服务和易用的[API](https://doc.sm.ms/ "API")；
1. 感谢海豚各位大佬写的详细wiki，以及wiki中频谱制作指南的作者puff@RED与 newstarshipsmell@RED。

## 许可

这个项目是在MIT许可下进行的 - 查看 [LICENSE](https://github.com/pdxgf1208/ffmpeg-videotools/blob/master/LICENSE "LICENSE") 文件获取更多详情。

