P3 Insignt 是鄙人于2009年用Delphi 7游戏大航海家3(Patrician III)中文版的一款内挂，用于网友马虎牛的补丁的游戏版本。不同版本内存地址可不同，故其他版本可能运行不了，或报错、闪退。
游戏内挂程序发布在当时的okkq论坛，是根据多个网友对游戏的内存数据结构分析、存档数据结构分析得出的结果进行开发的。业余作品，没太讲究代码规范，注释较少。
代码也是清理硬盘时找到的，有点年头了，手头上已经没有了XP系统了，也没有Delphi 7，所以暂时也无法验证代码全不全，运行是否还正常，权作自己的一个纪念了。

# 主要功能
1. 以一个直观、集中的方式展示游戏中的数据，如城镇、货物、船只、贸易者、待业船长位置、航线等信息。
2. 修改游戏中的一些数据。

网友TERRY为本程序编写了详细的使用教程，请到百度贴吧上查看这篇教程：https://tieba.baidu.com/p/5162480381

我也是后来在百度上搜索才发现他写的这篇教程，但因无法联系到他本人，也就不将教程的内容收纳到本项目了。


# 程序的基本工作原理
1. 通过 p3insight-launcher.exe 加载 p3.exe，并暂停进程
2. 通过 InjLib.dll (为《Windows核心编程》一书作者开发的程序) 将 p3insight.dll 注入到目录进程
3. p3insight被注入后，挂载热键，通过修改程序的一些函数的入口代码拦截游戏的部分函数，然后恢复p3主线程运行
4. 用户开始游戏，在游戏中通过热键呼叫出主窗口

# 配置
通过修改 p3edit.cfg 文件进行配置，配置项基本都有注释：
```ini
# P3内存修改器配置文件
# By alphax, 2009-03-16
# Contact: alphax@vip.163.com

P3ED_HOTKEY=ctrl+alt+f1
# 呼出修改器的热键
# 热键，可识别的按键
#    ctrl, alt, win, shift, scroll_lock, break,
#    a..z, 0..9, f1..f12, num0..num9

P3ED_SHIP_NAME_PREFIX=alphax
# 搜索时所依据的船名前缀，不应小于5个字节，否则会错误判定的机会会加大，并且搜索时间加长。


P3ED_CAPTAIN=$02
# 船长代码，编辑器的默认值=$02

P3ED_MAX_LOAD=198000000
# 最大载重(桶x200, 包x2000)，编辑器默认值=198000000，即99000包

P3ED_MAX_POINT=100000
# 最大耐久，默认值=100000

P3ED_GOODS_QTY=4500
# 快速设置货物量时使用的数量，单位包，默认=4500

P3ED_ADDR_START=
# 默认的搜索起始地址，注意16进制要用'$'符号开头，如$10000

P3ED_ADDR_END=
# 默认的搜索结束地址，注意16进制要用'$'符号开头，如$7FFEFFFF，当P3ED_ADDR_START或P3ED_ADDR_END设置了后，编辑器的预设地址将变成你指定的值。空着表示使用操作系统的值。
```
