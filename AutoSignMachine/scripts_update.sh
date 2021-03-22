#!/bin/sh
set -e

##定义合并定时任务相关文件路径变量
defaultListFile="/pss/AutoSignMachine/$DEFAULT_LIST_FILE"
customListFile="/pss/AutoSignMachine/$CUSTOM_LIST_FILE"
mergedListFile="/pss/AutoSignMachine/merged_list_file.sh"


cd /AutoSignMachine
echo "更新AutoSignMachine仓库脚本..."
git reset --hard
git pull origin main --rebase
echo "安装最新依赖..."
npm install --loglevel error --prefix /AutoSignMachine

cd /UnicomTask
echo "更新AutoSignMachine仓库脚本..."
git reset --hard
git pull origin main --rebase
echo "安装最新依赖..."
pip3 install -r requirements.txt


if [ $ENABLE_52POJIE ]; then
    echo "10 13 * * * node /AutoSignMachine/index.js 52pojie --htVD_2132_auth=$htVD_2132_auth --htVD_2132_saltkey=$htVD_2132_saltkey >> /logs/52pojie.log 2>&1" >>$mergedListFile
else
    echo "未配置启用52pojie签到任务环境变量ENABLE_52POJIE，故不添加52pojie定时任务..."
fi

if [ $ENABLE_BILIBILI ]; then
    echo "*/30 7-22 * * * node /AutoSignMachine/index.js bilibili --username $BILIBILI_ACCOUNT --password $BILIBILI_PWD >> /logs/bilibili.log 2>&1" >>$mergedListFile
else
    echo "未配置启用bilibi签到任务环境变量ENABLE_BILIBILI，故不添加Bilibili定时任务..."
fi

if [ $ENABLE_IQIYI ]; then
    echo "*/30 7-22 * * * node /AutoSignMachine/index.js iqiyi --P00001 $P00001 --P00PRU $P00PRU --QC005 $QC005  --dfp $dfp >> /logs/iqiyi.log 2>&1" >>$mergedListFile
else
    echo "未配置启用iqiyi签到任务环境变量ENABLE_IQIYI，故不添加iqiyi定时任务..."
fi

if [ $ENABLE_UNICOM ]; then
    if [ -f $envFile ]; then
        cp -f $envFile /AutoSignMachine/config/.env
        if [ $UNICOM_TRYRUN_NODE ]; then
            echo "联通配置了UNICOM_TRYRUN_NODE参数，所以定时任务以tryrun模式生成"
            minute=$((RANDOM % 10+4))
            hour=8
            n_hour="`date +%H`"
            n_minute="`date +%M`"
            for job in $(awk '/scheduler.regTask/getline a;print a' /AutoSignMachine/commands/tasks/unicom/unicom.js | sed "/\//d" | sed "s/\( \|,\|\"\|\\t\)//g"|tr "\n" " "); do
                minute2=$(expr $minute + $((RANDOM % 10+3)))
                if [ $minute2 -ge 60 ]; then
                    minute2=59
                fi
                echo "$minute,$minute2 $hour * * * node /AutoSignMachine/index.js unicom --tryrun --tasks $job >>/logs/unicom_$job.log 2>&1" >>$mergedListFile
                minute=$(expr $minute + $((RANDOM % 10+4)))
                if [ $minute -ge 60 ]; then
                    minute=0
                    hour=$(expr $hour + 1)
                fi
                if [ -z "$(crontab -l | grep $job)" ];then
                    echo "  ->发现新增加任务$job所以在当前时间后面增加一个 $n_hour时$n_minute分的单次任务，防止今天漏跑"
                    echo "$n_minute $n_hour * * * node /AutoSignMachine/index.js unicom --tryrun --tasks $job >>/logs/unicom_$job.log 2>&1" >>$mergedListFile
                    n_minute=$(expr $n_minute + $((RANDOM % 10+4)))
                    if [ $n_minute -ge 60 ];then
                        n_minute=0
                        n_hour=$(expr $n_hour + 1)
                    fi
                    if [ $n_hour -ge 24 ];then
                        n_hour=0
                    fi
                fi
            done
        else
            echo "*/10 6-23 * * * node /AutoSignMachine/index.js unicom >> /logs/unicom.log 2>&1" >>$mergedListFile
        fi
    else
        echo "未找到 .env配置文件，故不添加unicom定时任务。"
    fi
else
    echo "未配置启用unicom签到任务环境变量ENABLE_UNICOM，故不添加unicom定时任务..."
fi

if [ $ENABLE_UNICOMTASK ]; then
    cp -f $USERS_COVER /UnicomTask/config.json
    echo "30 6 * * * python /UnicomTask/main.py >> /logs/UnicomTask.log 2>&1" >>$mergedListFile
else
    echo "未配置启用UnicomTask签到任务环境变量ENABLE_UNICOMTASK，故不添加UnicomTask定时任务..."
fi
