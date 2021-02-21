#!/bin/sh


if [ $(grep -c "docker_entrypoint.sh" /scripts/docker/merged_list_file.sh) -eq '0' ]; then
    wget -O /scripts/docker/remote_task.sh https://raw.githubusercontent.com/Aaron-lv/someDockerfile/master/jd_scripts/docker_entrypoint.sh
    echo "# 远程定时任务" >> /scripts/docker/merged_list_file.sh
    echo "55 */1 * * * sh -x /scripts/docker/remote_task.sh >> /scripts/logs/remote_task.log 2>&1" >> /scripts/docker/merged_list_file.sh
    cat /scripts/docker/remote_task.sh > /scripts/docker/docker_entrypoint.sh
fi

if [ ! -e "/scripts/joy_reward.js" ]; then
    echo "未挂载joy_reward.js，跳过添加定时任务..."
else
    echo "已挂载joy_reward.js，添加定时任务..."
    echo "# 宠汪汪积分兑换奖品" >> /scripts/docker/merged_list_file.sh
    echo "0 0-16/8 * * * node /scripts/joy_reward.js >> /scripts/logs/jd_joy_reward.log 2>&1" >> /scripts/docker/merged_list_file.sh
fi

## 克隆i-chenzhe仓库
if [ ! -d "/i-chenzhe/" ]; then
    echo "未检查到i-chenzhe仓库脚本，初始化下载相关脚本..."
    git clone https://github.com/i-chenzhe/qx /i-chenzhe
    cp -f /i-chenzhe/jd_*.js /scripts
else
    echo "更新i-chenzhe脚本相关文件..."
    git -C /i-chenzhe reset --hard
    git -C /i-chenzhe pull --rebase
    cp -f /i-chenzhe/jd_*.js /scripts
fi


## 百变大咖秀
echo "# 百变大咖秀" >> /scripts/docker/merged_list_file.sh
echo "10 10 * * 1-3 node /scripts/jd_entertainment.js >> /scripts/logs/jd_entertainment.log 2>&1" >> /scripts/docker/merged_list_file.sh
## 粉丝互动
echo "# 粉丝互动" >> /scripts/docker/merged_list_file.sh
echo "3 10 * * * node /scripts/jd_fanslove.js >> /scripts/logs/jd_fanslove.log 2>&1" >> /scripts/docker/merged_list_file.sh

## 京喜财富岛
wget -O /scripts/jx_cfd.js https://raw.githubusercontent.com/moposmall/Script/main/Me/jx_cfd.js
echo "# 京喜财富岛" >> /scripts/docker/merged_list_file.sh
echo "1 * * * * node /scripts/jx_cfd.js >> /scripts/logs/jx_cfd.log 2>&1" >> /scripts/docker/merged_list_file.sh
## 京喜财富岛提现
wget -O /scripts/jx_cfdtx.js https://raw.githubusercontent.com/Aaron-lv/JavaScript/master/Task/jx_cfdtx.js
echo "# 京喜财富岛提现" >> /scripts/docker/merged_list_file.sh
echo "0 0 * * * node /scripts/jx_cfdtx.js >> /scripts/logs/jx_cfdtx.log 2>&1" >> /scripts/docker/merged_list_file.sh


## 修改闪购盲盒定时
sed -i "s/27 8 \* \* \* node \/scripts\/jd_sgmh.js/27 8,23 \* \* \* node \/scripts\/jd_sgmh.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/27 8 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_sgmh.js/27 8,23 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_sgmh.js/g" /scripts/docker/merged_list_file.sh
## 修改签到领现金定时
sed -i "s/27 7 \* \* \* node \/scripts\/jd_cash.js/27 7,23 \* \* \* node \/scripts\/jd_cash.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/27 7 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_cash.js/27 7,23 * * * sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_cash.js/g" /scripts/docker/merged_list_file.sh

## 替换环球挑战赛助力码
sed -ie "47,48s/^[^\]*/  'Vi9SR2lwcGdLa0IzNENIVFAwUjcxQT09@cm5GeUZMTmMvMDBLNkd2WnprUC9LYWRaV2wvemFDeGJEZnJWNGpoSEZXWT0=',/g" /scripts/jd_global.js

## 参团
sed -i "s/https:\/\/gitee.com\/shylocks\/updateTeam\/raw\/main\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/JavaScript\/master\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/raw.githubusercontent.com\/LXK9301\/updateTeam\/master\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/JavaScript\/master\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/gitee.com\/lxk0301\/updateTeam\/raw\/master\/shareCodes\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/JavaScript\/master\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
