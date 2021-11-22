# Pixiv User Batch Download

一个可以批量下载Pixiv指定用户所有作品的工具

直连核心代码来源于 @Notsfsssf

# 编译 / Build

需要 flutter/dart Sdk，之后运行

`dart compile exe lib/main.dart`

将会在 `lib`目录下生成可独立运行的`main.exe`

# 运行

1. 将`main.exe`复制到单独的目录

2. 同级目录下创建

    - `uid.txt`  指定要下载哪些用户的作品，每行一个

    - `cookie.txt`  你自己的Pixiv Cookie，用于获取用户作品列表以及获取R-18作品信息

3. 由于使用了OpenCV的依赖，需要在 [Release页面](https://github.com/PeanutMelonSeedBigAlmond/PixivUserBatchDownloader/releases)下载随附的`library.zip`，解压后将所有的dll放到exe同级目录
   
4. 之后可以直接运行exe或者使用计划任务定时运行
