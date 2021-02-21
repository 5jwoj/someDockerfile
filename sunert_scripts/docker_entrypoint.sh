#!/bin/sh
set -e

if [ $1 ]; then
    echo "暂时不支持指定启动参数，请删除 docker run时最后附带的命令 或者 docker-compose.yml中的配置的command:指令 "
fi


echo "获取最新定时任务相关代码..."
echo "##############################################################################"
cd /pss
git pull origin master --rebase
cd sunert_scripts
cp -f crontab_list.sh default_task.sh scripts_update.sh /pss
echo "##############################################################################"
echo "获取最新定时任务相关代码完成。"


echo "首次初始化定时任务..."
echo "=============================================================================="
sh -x /pss/scripts_update.sh
echo "=============================================================================="
echo "初始化完成。"

echo "启动crondtab定时任务主进程..."
crond -f