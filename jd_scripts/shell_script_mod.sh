#!/bin/sh


if [ $(grep -c "docker_entrypoint.sh" /scripts/docker/merged_list_file.sh) -eq '0' ]; then
    wget -O /scripts/docker/remote_task.sh https://raw.githubusercontent.com/Aaron-lv/someDockerfile/master/jd_scripts/docker_entrypoint.sh
    echo "# 远程定时任务" >> /scripts/docker/merged_list_file.sh
    echo "*/1 */1 * * * sh -x /scripts/docker/remote_task.sh >> /scripts/logs/remote_task.log 2>&1" >> /scripts/docker/merged_list_file.sh
    cat /scripts/docker/remote_task.sh > /scripts/docker/docker_entrypoint.sh
fi

## 克隆i-chenzhe仓库
if [ ! -d "/i-chenzhe/" ]; then
    echo "未检查到i-chenzhe仓库脚本，初始化下载相关脚本..."
    git clone https://github.com/i-chenzhe/qx /i-chenzhe
else
    echo "更新i-chenzhe脚本相关文件..."
    git -C /i-chenzhe reset origin/main --hard
    git -C /i-chenzhe pull origin main --rebase
fi
cp -f /i-chenzhe/*_*.js /scripts
sed -i "/^$/d" /i-chenzhe/remote_crontab_list.sh
cat /i-chenzhe/remote_crontab_list.sh >> /scripts/docker/merged_list_file.sh

## 京东试用
if [ $jd_try_ENABLE = "Y" ]; then
    wget -O /scripts/jd_try.js https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/jd_try.js
    echo "# 京东试用" >> /scripts/docker/merged_list_file.sh
    echo "30 10 * * * node /scripts/jd_try.js >> /scripts/logs/jd_try.log 2>&1" >> /scripts/docker/merged_list_file.sh
fi
