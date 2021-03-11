#!/bin/sh
set -e

MAINPID=`ps -ef|grep jd_zbj|grep -v grep`

if [ ! -f "/telethon/jd_zbj.py" ]; then
    echo "京东直播间抽奖脚本不存在，跳过执行..."
else
    echo "京东直播间抽奖脚本存在，判断进程是否存在..."
    if [ ! "$MAINPID" ];then
        echo "进程不存在，执行脚本..."
        python3 /telethon/jd_zbj.py >> /logs/jd_zbj.log 2>&1
    else
        echo "进程存在，跳过执行..."
    fi
fi
