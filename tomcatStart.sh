#!/bin/bash
projectName=$1; # 指定需要重启得服务=f:学生端；m:教师端；s:SDK项目
installationDirectory=${2:-'/data/'}; # web容器得安装目录
tomcatName=$3; # 指定tomcat名称
logFlag=${4:-'nlog'}; # 是否需要输出日志=ylog:需要；nlog:不需要；
startFlag=${5:-'ystart'}; #是否需要启动=ystart:需要：nstart:不需要；
tomcatPath="";

echo "第一个参数："$projectName
echo "第二个参数："$installationDirectory

function msg(){
    echo "封装信息KEY = $1"  
    if [ $1 = "one" ]
		then  
        echo "传入为空，终止执行本脚本。第一个参数：【"$2"】";
		
	elif [ $1 = "two" ]
		then
		echo "第二个参数不正确：【"$2"】";
		
	else
		echo "未知错误！！！";
    fi  
}
function exitShell(){
  echo $(msg $1 $2)
  exit 
  echo "啊~ 我死了"
}

if [ -z "$projectName" ]; 
	then
	exitShell one $projectName
fi

echo "传入得不为空：【"$projectName"】;字符串得长度：【"${projectName}"】";

# 判断 启动的服务 是否存在
if [[ $projectName = "f" || $projectName = "front" ]];then
	echo "学生端";
	tomcatName=${tomcatName:-'tomcat_front'};	
elif [[ $projectName = "m" || $projectName = "manage" ]];then
	echo "教师端";
	tomcatName=${tomcatName:-'tomcat_manage'};
elif [[ $projectName = "s" || $projectName = "sdk" ]];then
	echo "SDK项目";
	tomcatName=${tomcatName:-'tomcat_sdk'};
else
	echo "未找到指定得项目"$projectName
	exitShell one $projectName
fi
# web容器的指定目录
echo "指定了安装目录"$installationDirectory

tomcatPath="$installationDirectory$tomcatName"

echo "判断web容器路径是否正确，且真实有效"$tomcatPath

# 判断 拼接的安装目录 是否真实存在
if [ ! -d "$tomcatPath/webapps/ROOT/" ]
	then
	echo "容器路径不合法"
	exitShell two $tomcatPath
fi

echo "进入启动/重启操作"

# Web名称
kill -9 $(ps -ef | grep "file=$tomcatPath" | grep -v grep | awk '{print $2}');


if [ $startFlag = "ystart" ] 
	then
	echo "启动的服务"
	${tomcatPath}/bin/startup.sh;
else
	echo
	echo "不需要启动的服务"
fi

echo "是否输出日志："$logFlag

if [ $logFlag = "ylog" ] 
	then
	echo "输出日志！！！！"
	tail -f ${tomcatPath}/logs/catalina.out;
else
	ps -ef |grep ${tomcatName};
	echo "不输出日志！！！！"
fi
