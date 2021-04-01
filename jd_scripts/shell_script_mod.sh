#!/bin/sh

mergedListFile="/scripts/docker/merged_list_file.sh"
remoteListFile="/scripts/docker/remote_crontab_list.sh"

if [ $(grep -c "docker_entrypoint.sh" $mergedListFile) -eq '0' ]; then
    wget -O /scripts/docker/remote_task.sh https://raw.githubusercontent.com/Aaron-lv/someDockerfile/master/jd_scripts/docker_entrypoint.sh
    echo "# 远程定时任务" >> $mergedListFile
    echo "*/1 */1 * * * sh -x /scripts/docker/remote_task.sh >> /scripts/logs/remote_task.log 2>&1" >> $mergedListFile
    cat /scripts/docker/remote_task.sh > /scripts/docker/docker_entrypoint.sh
fi

# 克隆monk-coder仓库
if [ ! -d "/monk-coder/" ]; then
    echo "未检查到monk-coder仓库脚本，初始化下载相关脚本..."
    git clone https://github.com/monk-coder/dust /monk-coder
else
    echo "更新monk-coder脚本相关文件..."
    git -C /monk-coder reset origin/dust --hard
    git -C /monk-coder pull origin dust --rebase
fi
cp -f /monk-coder/car/*_*.js /scripts
cp -f /monk-coder/i-chenzhe/*_*.js /scripts
cp -f /monk-coder/normal/*_*.js /scripts
sed -i "/^$/d" $remoteListFile
cat $remoteListFile >> $mergedListFile

## 京东试用
if [ $jd_try_ENABLE = "Y" ]; then
    wget -O /scripts/jd_try.js https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/jd_try.js
    echo "# 京东试用" >> $mergedListFile
    echo "30 10 * * * node /scripts/jd_try.js >> /scripts/logs/jd_try.log 2>&1" >> $mergedListFile
fi
