#!/bin/sh
set -e

echo "git 拉取最新代码..."
git -C /Scripts reset --hard
git -C /Scripts pull origin master --rebase
npm install --loglevel error --prefix /Scripts


##定义合并定时任务相关文件路径变量
defaultListFile="/pss/$DEFAULT_LIST_FILE"
customListFile="/pss/$CUSTOM_LIST_FILE"
mergedListFile="/pss/merged_list_file.sh"


#判断百度极速版相关变量存在，才会配置定时任务
if [ 0"$BAIDU_COOKIE" = "0" ]; then
    echo "没有配置百度Cookie，相关环境变量参数，跳过配置定时任务"
else
    if [ 0"$BAIDU_CRON" = "0" ]; then
        BAIDU_CRON="*/20 6-22/1 * * *"
    fi
    echo "#百度极速版" >>$defaultListFile
    echo "$BAIDU_CRON node /Scripts/Task/baidu_speed.js >> /logs/baidu_speed.log 2>&1" >>$defaultListFile
fi

#判断中青看点极速版相关变量存在，才会配置定时任务
if [ 0"$YOUTH_HEADER" = "0" ]; then
    echo "没有配置中青youth.js，相关环境变量参数，跳过配置定时任务"
else
    sed -i 's/"false"/"true"/g' /Scripts/Task/youth.js
    sed -i "s/await readArticle();/\/\/await readArticle();/g" /Scripts/Task/youth.js
    if [ 0"$YOUTH_CRON" = "0" ]; then
        YOUTH_CRON="*/15 */1 * * *"
    fi
    echo "#中青看点极速版" >>$defaultListFile
    echo "$YOUTH_CRON node /Scripts/Task/youth.js >> /logs/youth.log 2>&1" >>$defaultListFile
fi

if [ 0"$YOUTH_START" = "0" ]; then
    echo "没有配置中青youth_gain.js，相关环境变量参数，跳过配置定时任务"
else
    if [ 0"$YOUTH_GAIN_CRON" = "0" ]; then
        YOUTH_GAIN_CRON="0 8 * * *"
    fi
    echo "$YOUTH_GAIN_CRON node /Scripts/Task/youth_gain.js >> /logs/youth_gain.log 2>&1" >>$defaultListFile
fi

if [ 0"$YOUTH_READ2" = "0" ]; then
    if [ 0"$YOUTH_READ" = "0" ]; then
        echo "没有配置中青youth_read.js，相关环境变量参数，跳过配置定时任务"
    else
        if [ 0"$YOUTH_READ_CRON" = "0" ]; then
            YOUTH_READ_CRON="5 9-21/3 * * *"
        fi
        echo "$YOUTH_READ_CRON node /Scripts/Task/Youth_Read.js >> /logs/Youth_Read.log 2>&1" >>$defaultListFile
    fi
else
    cp -f /Scripts/Task/Youth_Read.js /Scripts/Task/Youth_Read2.js
    sed -i 's/YOUTH_READ/YOUTH_READ2/g' /Scripts/Task/Youth_Read2.js
    
    if [ 0"$YOUTH_READ_CRON" = "0" ]; then
        YOUTH_READ_CRON="5 9-21/3 * * *"
    fi
    echo "$YOUTH_READ_CRON node /Scripts/Task/Youth_Read.js >> /logs/Youth_Read.log 2>&1 && node /Scripts/Task/Youth_Read2.js >> /logs/Youth_Read2.log 2>&1" >>$defaultListFile
fi

#判断快手极速版相关变量存在，才会配置定时任务
if [ 0"$KS_TOKEN" = "0" ]; then
    echo "没有配置快手极速版，相关环境变量参数，跳过配置定时任务"
else
    if [ 0"$KS_CRON" = "0" ]; then
        KS_CRON="0 8 * * *"
    fi
    echo "#快手极速版" >>$defaultListFile
    echo "$KS_CRON node /Scripts/Task/kuaishou.js >> /logs/kuaishou.log 2>&1" >>$defaultListFile
fi


###追加|ts 任务日志时间戳
if type ts >/dev/null 2>&1; then
    echo '系统已安装moreutils工具包，默认定时任务增加｜ts 输出'
    ##复制一个新文件来追加|ts，防止git pull的时候冲突
    cp -f $defaultListFile /pss/default_list.sh
    defaultListFile="/pss/default_list.sh"
    sed -i '/|ts/!s/>>/|ts >>/g' $defaultListFile
fi

#判断自定义定时文件是否存在
if [ $CUSTOM_LIST_FILE ]; then
    echo "您配置了自定义任务文件：$CUSTOM_LIST_FILE，自定义任务类型为：$CUSTOM_LIST_MERGE_TYPE..."
    if [ -f "$customListFile" ]; then
        if [ $CUSTOM_LIST_MERGE_TYPE == "append" ]; then
            echo "合并默认定时任务文件：$DEFAULT_LIST_FILE 和 自定义定时任务文件：$CUSTOM_LIST_FILE"
            cat $defaultListFile >$mergedListFile
            echo -e "" >>$mergedListFile
            cat $customListFile >>$mergedListFile
        elif [ $CUSTOM_LIST_MERGE_TYPE == "overwrite" ]; then
            cat $customListFile >$mergedListFile
            echo "合并自定义任务文件：$CUSTOM_LIST_FILE"
            touch "$customListFile"
        else
            echo "配置配置了错误的自定义定时任务类型：$CUSTOM_LIST_MERGE_TYPE，自定义任务类型为只能为append或者overwrite..."
            cat $defaultListFile >$mergedListFile
        fi
    else
        echo "自定义任务文件：$CUSTOM_LIST_FILE 未找到，使用默认配置$DEFAULT_LIST_FILE..."
        cat $defaultListFile >$mergedListFile
    fi
else
    echo "当前使用的为默认定时任务文件 $DEFAULT_LIST_FILE ..."
    cat $defaultListFile >$mergedListFile
fi

# 判断最后要加载的定时任务是否包含默认定时任务，不包含的话就加进去
if [ $(grep -c "default_task.sh" $mergedListFile) -eq '0' ]; then
    echo "合并后的定时任务文件，未包含必须的默认定时任务，增加默认定时任务..."
    echo -e >>$mergedListFile
    echo "#默认定时任务" >>$mergedListFile
    echo "52 */1 * * * sh /pss/default_task.sh |ts >> /logs/default_task.log 2>&1" >>$mergedListFile
fi

echo "加载最新的定时任务文件..."
crontab $mergedListFile