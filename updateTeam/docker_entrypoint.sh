#!/bin/sh
set -e

#获取配置的自定义参数
if [ $1 ]; then
    run_cmd=$1
fi

echo "设定远程仓库地址..."
cd /scripts
git remote set-url origin $REPO_URL
echo "git pull拉取最新代码..."
git -C /scripts reset --hard
git -C /scripts pull origin master --rebase
echo "npm install 安装最新依赖..."
npm install --loglevel error --prefix /scripts

function initupdateTeam() {
    mkdir /updateTeam
    cd /updateTeam
    git init
    git remote set-url origin $updateTeam_URL
    git reset --hard
    git pull origin master --rebase
}

if [ ! -d "/updateTeam/" ]; then
    echo "未检查到updateTeam仓库，初始化下载..."
    initupdateTeam
else
    echo "更新updateTeam仓库文件..."
    git -C /updateTeam reset --hard
    git -C /updateTeam pull origin master --rebase
    echo "提交updateTeam仓库文件..."
    git -C /updateTeam push origin master
fi

echo "------------------------------------------------执行定时任务任务shell脚本------------------------------------------------"
sh -x /scripts/docker/default_task.sh
echo "--------------------------------------------------默认定时任务执行完成---------------------------------------------------"

if [ $run_cmd ]; then
    echo "启动crondtab定时任务主进程..."
    crond -f
else
    echo "默认定时任务执行结束。"
fi
echo -e "\n\n"
