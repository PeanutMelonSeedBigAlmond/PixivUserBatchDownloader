# Pixiv User Batch Download

一个可以批量下载Pixiv指定用户所有作品的工具


# 编译 / Build

需要 flutter/dart Sdk，之后运行

`dart compile exe lib/main.dart`

将会在 `lib`目录下生成可独立运行的`main.exe`

# 运行

1. 将`main.exe`复制到单独的目录

2. 同级目录下创建

    - `uid.txt`  指定要下载哪些用户的作品，每行一个

    - `cookie.txt`  你自己的Pixiv Cookie，用于获取用户作品列表以及获取R-18作品信息

3. 之后可以直接运行exe或者使用计划任务定时运行

# 注意

程序会使用CMD命令查询注册表以获取系统代理，因此如果在Linux下编译运行可能会有意外的错误

目前不支持手动设置代理