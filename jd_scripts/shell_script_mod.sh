#!/bin/sh


if [ $(grep -c "docker_entrypoint.sh" /scripts/docker/merged_list_file.sh) -eq '0' ]; then
    wget -O /scripts/docker/remote_task.sh https://raw.githubusercontent.com/Aaron-lv/someDockerfile/master/jd_scripts/docker_entrypoint.sh
    echo "# 远程定时任务" >> /scripts/docker/merged_list_file.sh
    echo "55 */1 * * * sh -x /scripts/docker/remote_task.sh >> /scripts/logs/remote_task.log 2>&1" >> /scripts/docker/merged_list_file.sh
    cat /scripts/docker/remote_task.sh > /scripts/docker/docker_entrypoint.sh
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
echo "10 10,11 * * 2-5 node /scripts/jd_entertainment.js >> /scripts/logs/jd_entertainment.log 2>&1" >> /scripts/docker/merged_list_file.sh
## 粉丝互动
echo "# 粉丝互动" >> /scripts/docker/merged_list_file.sh
echo "3 10 * * * node /scripts/jd_fanslove.js >> /scripts/logs/jd_fanslove.log 2>&1" >> /scripts/docker/merged_list_file.sh
## 母婴-跳一跳
echo "# 母婴-跳一跳" >> /scripts/docker/merged_list_file.sh
echo "5 12 22-27 2 * node /scripts/jd_jump-jump.js >> /scripts/logs/jd_jump-jump.log 2>&1" >> /scripts/docker/merged_list_file.sh
## 超级摇一摇
echo "# 超级摇一摇" >> /scripts/docker/merged_list_file.sh
echo "3 20 * * * node /scripts/jd_shake.js >> /scripts/logs/jd_shake.log 2>&1" >> /scripts/docker/merged_list_file.sh


## 修改闪购盲盒定时
sed -i "s/27 8 \* \* \* node \/scripts\/jd_sgmh.js/27 8,23 \* \* \* node \/scripts\/jd_sgmh.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/27 8 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_sgmh.js/27 8,23 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_sgmh.js/g" /scripts/docker/merged_list_file.sh
## 修改京东赚赚定时
sed -i "s/10 11 \* \* \* node \/scripts\/jd_jdzz.js/10 \* \* \* \* node \/scripts\/jd_jdzz.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/10 11 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_jdzz.js/10 \* \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_jdzz.js/g" /scripts/docker/merged_list_file.sh
## 修改美丽颜究院定时
sed -i "s/1 7,12,19 \* \* \* node \/scripts\/jd_beauty.js/30 8,13,20 \* \* \* node \/scripts\/jd_beauty.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/1 7,12,19 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_beauty.js/30 8,13,20 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_beauty.js/g" /scripts/docker/merged_list_file.sh

## 替换签到领现金助力码
sed -ie "32,33s/^[^\]*/  \`aUNmM6_nOP4j-W4@eU9Yau3kZ_4g-DiByHEQ0A@eU9YaOvnM_4k9WrcnnAT1Q@eU9Yar-3M_8v9WndniAQhA@f0JyJuW7bvQ@IhM0bu-0b_kv8W6E@eU9YKpnxOLhYtQSygTJQ@-oaWtXEHOrT_bNMMVso@eU9YG7XaD4lXsR2krgpG\`,/g" /scripts/jd_cash.js

## 京喜工厂
sed -i "/^.*jsjiami.com.v6.*$/d" /scripts/jd_dreamFactory.js
sed -i "s/\/\/.*await joinLeaderTuan();/await joinLeaderTuan();/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/gitee.com\/shylocks\/updateTeam\/raw\/main\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/raw.githubusercontent.com\/LXK9301\/updateTeam\/master\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/gitee.com\/lxk0301\/updateTeam\/raw\/master\/shareCodes\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
## 京东赚赚
sed -i "s/https:\/\/gitee.com\/shylocks\/updateTeam\/raw\/main\/jd_zz.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_zz.json/g" /scripts/jd_jdzz.js
sed -i "s/https:\/\/gitee.com\/lxk0301\/updateTeam\/raw\/master\/shareCodes\/jd_zz.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_zz.json/g" /scripts/jd_jdzz.js

## 修改助力开关
sed -i "s/helpAu = true;/helpAu = false;/g" /scripts/jd_*.js
sed -i "s/helpAuthor = true;/helpAuthor = false;/g" /scripts/jd_*.js
