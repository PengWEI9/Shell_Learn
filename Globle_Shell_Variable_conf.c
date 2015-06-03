/**
 * Globle Variable and 
 * Shell Variable
 ***/


//common env variable
PATH：系统路径.
HOME：当前用户家目录
HISTSIZE：保存历史命令记录的条数。
LOGNAME：当前用户登录名。
HOATNAME：主机名称，若应用程序要用到主机名的话，一般是从这个环境变量中的取得的.
SHELL：当前用户用的是哪种shell.
LANG/LANGUGE:和语言相关的环境变量，使用多种语言的用户可以修改此环境变量.
MAIL：当前用户的邮件存放目录.
//3.设置环境变量的方法。
etho：显示指定环境变量。
export：设置新的环境变量。
env：显示所有环境变量。
set：显示所有本地定义的shell变量。
unset：清除环境变量。
//4.几个实例。
①. 显示环境变量HOME
$ echo $HOME
/home/leon
②设置一个新的环境变量hello
$ export HELLO="Hello!"   
$ echo $HELLO
Hello!
③使用env命令显示所有的环境变量
$ env
HOSTNAME=redbooks.safe.org
PVM_RSH=/usr/bin/rsh
SHELL=/bin/bash
TERM=xterm
HISTSIZE=1000
　...
④ 使用set命令显示所有本地定义的Shell变量
　$ set
　BASH=/bin/bash
　BASH_VERSINFO=([0]="2"[1]="05b"[2]="0"[3]="1"[4]="release"[5]="i386-redhat-linux-gnu")
　BASH_VERSION='2.05b.0(1)-release'
　COLORS=/etc/DIR_COLORS.xterm
　COLUMNS=80
　DIRSTACK=()
	　DISPLAY=:0.0
	　　...
	⑤使用unset命令来清除环境变量
	set可以设置某个环境变量的值。清除环境变量的值用unset命令。如果未指定值，则该变量值将被设为NULL。示例如下：
	$ export TEST="Test..." #增加一个环境变量TEST
	$ env|grep TEST #此命令有输入，证明环境变量TEST已经存在了
	TEST=Test...
	$ unset $TEST #删除环境变量TEST
	$ env|grep TEST #此命令没有输出，证明环境变量TEST已经存在了
	⑥ . 使用readonly命令设置只读变量
	如果使用了readonly命令的话，变量就不可以被修改或清除了。示例如下：
	$ export TEST="Test..." #增加一个环境变量TEST
	$ readonly TEST #将环境变量TEST设为只读
	$ unset TEST #会发现此变量不能被删除
	-bash: unset: TEST: cannot unset: readonly variable
	$ TEST="New" #会发现此也变量不能被修改
	-bash: TEST: readonly variable
	环境变量的设置位于/etc/profile文件
	如果需要增加新的环境变量可以添加下属行
	export path=$path:/path1:/path2:/pahtN
//	5.想将一个路径加入到$PATH中，可以像下面这样做：
//	Permenent Senting variable
	①. 控制台中：
	$ PATH="$PATH:/my_new_path"

	②. 修改profile文件：
	$ vi /etc/profile

	在里面加入:
	export PATH="$PATH:/my_new_path"

	③. 修改.bashrc文件：
	       $ vi /root/.bashrc

		   在里面加入：

		   export PATH="$PATH:/my_new_path"
		   //////////////////////////////////////////////////////////////////////
		   后两种方法一般需要重新注销系统才能生效，最后可以通过echo命令测试一下：
		   $ echo $PATH
		   看看输出里面是不是已经有了/my_new_path这个路径了。





















