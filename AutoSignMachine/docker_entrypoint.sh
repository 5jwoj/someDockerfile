#!/bin/sh
set -e

#获取配置的自定义参数
if [ $1 ]; then
    run_cmd=$1
fi

cd /pss
echo "获取最新定时任务相关代码..."
git reset --hard
git pull origin master --rebase

echo "------------------------------------------------执行定时任务任务shell脚本------------------------------------------------"
sh -x /pss/AutoSignMachine/default_task.sh
echo "--------------------------------------------------默认定时任务执行完成---------------------------------------------------"

if [ $run_cmd ]; then
    echo "启动crondtab定时任务主进程..."
    crond -f
else
    echo "默认定时任务执行结束。"
fi
echo -e "\n\n"
