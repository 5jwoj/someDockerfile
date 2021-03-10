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

function initjds() {
    mkdir /jds
    cd /jds
    git init
    git remote add -f origin https://github.com/Aaron-lv/someDockerfile
    git config core.sparsecheckout true
    echo jd_scripts >> /jds/.git/info/sparse-checkout
    git pull origin master --rebase
}

if [ ! -d "/jds/" ]; then
    echo "未检查到jds仓库，初始化下载..."
    initjds
else
    echo "更新jds仓库文件..."
    git -C /jds reset --hard
    git -C /jds pull origin master --rebase
fi

echo "替换执行文件..."
ls /jds/jd_scripts/*.sh |grep -v shell_script_mod.sh |xargs -i cp -rf /jds/jd_scripts/{} /scripts/docker/
echo "替换完成。"

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
