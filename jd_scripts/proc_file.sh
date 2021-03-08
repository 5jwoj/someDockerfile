#!/bin/sh


echo "整理各个日志文件里面的互助码相关信息..."
echo "==========================================================================="
logdDir="/scripts/logs"
sharecodeFile="${logdDir}/sharecode.log"
jdzzFile="${logdDir}/jd_jdzz.log"
jdfactoryFile="${logdDir}/jd_jdfactory.log"
jxFactoryFile="${logdDir}/jd_dreamFactory.log"
plantBean="${logdDir}/jd_plantBean.log"
jdfruit="${logdDir}/jd_fruit.log"
jdpet="${logdDir}/jd_pet.log"
jdcrazyJoy="${logdDir}/jd_crazy_joy.log"

sed -n '/京东赚赚好友互助码】.*/'p $jdzzFile | awk '{print $4,$5}' | sort | uniq >>$sharecodeFile
echo "提取京东赚赚助力码完成"

sed -n '/东东工厂好友互助码】.*/'p $jdfactoryFile | awk '{print $4,$5}' | sort | uniq >>$sharecodeFile
echo "提取东东工厂助力码完成"

sed -n '/京喜工厂好友互助码.*/'p $jxFactoryFile | awk '{print $4,$5}' | sort | uniq >>$sharecodeFile
echo "提取京喜工厂助力码完成"

sed -n '/京东种豆得豆好友互助码】.*/'p $plantBean | awk '{print $4,$5}' | sort | uniq >>$sharecodeFile
echo "提取京东种豆助力码完成"

sed -n '/东东农场好友互助码】.*/'p $jdfruit | awk '{print $4,$5}' | sort | uniq >>$sharecodeFile
echo "提取京东农场助力码完成"

sed -n '/东东萌宠好友互助码】.*/'p $jdpet | awk '{print $4,$5}' | sort | uniq >>$sharecodeFile
echo "提取东东萌宠助力码完成"

sed -n '/crazyJoy任务好友互助码】.*/'p $jdcrazyJoy | awk '{print $4,$5}' | sort | uniq >>$sharecodeFile
echo "提取crazyJoy任务助力码完成"

cp $sharecodeFile ${sharecodeFile}.tmp
sed -i 's/ //' ${sharecodeFile}.tmp
cat ${sharecodeFile}.tmp | sort | uniq >$sharecodeFile
rm ${sharecodeFile}.tmp
echo "互助码排序和去重完成"

echo "==========================================================================="
echo "整理完成，具体结果请查看${sharecodeFile}文件"

echo "处理jd_crazy_joy_coin任务..."
if [ ! $CRZAY_JOY_COIN_ENABLE ]; then
   echo "默认启用jd_crazy_joy_coin杀掉jd_crazy_joy_coin任务，并重启"
   eval $(ps -ef | grep "jd_crazy" | awk '{print "kill "$1}')
   echo '' >/scripts/logs/jd_crazy_joy_coin.log
   node /scripts/jd_crazy_joy_coin.js | ts >>/scripts/logs/jd_crazy_joy_coin.log 2>&1 &
   echo "默认jd_crazy_joy_coin重启完成"
else
   if [ $CRZAY_JOY_COIN_ENABLE = "Y" ]; then
      echo "配置启用jd_crazy_joy_coin，杀掉jd_crazy_joy_coin任务，并重启"
      eval $(ps -ef | grep "jd_crazy" | awk '{print "kill "$1}')
      echo '' >/scripts/logs/jd_crazy_joy_coin.log
      node /scripts/jd_crazy_joy_coin.js | ts >>/scripts/logs/jd_crazy_joy_coin.log 2>&1 &
      echo "配置jd_crazy_joy_coin重启完成"
   else
      eval $(ps -ef | grep "jd_crazy" | awk '{print "kill "$1}')
      echo "已配置不启用jd_crazy_joy_coin任务，不处理"
   fi
fi


## 修改京东汽车兑换定时
sed -i "s/0 0 \* \* \* node \/scripts\/jd_car_exchange.js/2 0 \* \* \* node \/scripts\/jd_car_exchange.js/g" /scripts/docker/merged_list_file.sh
## 修改环球挑战赛定时
sed -i "s/35 6,22 \* \* \* node \/scripts\/jd_global.js/55 6,22 \* \* \* node \/scripts\/jd_global.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/35 6,22 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_global.js/55 6,22 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_global.js/g" /scripts/docker/merged_list_file.sh
## 修改闪购盲盒定时
sed -i "s/27 8 \* \* \* node \/scripts\/jd_sgmh.js/27 8,23 \* \* \* node \/scripts\/jd_sgmh.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/27 8 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_sgmh.js/27 8,23 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_sgmh.js/g" /scripts/docker/merged_list_file.sh
## 修改京东赚赚定时
sed -i "s/10 11 \* \* \* node \/scripts\/jd_jdzz.js/10 \* \* \* \* node \/scripts\/jd_jdzz.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/10 11 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_jdzz.js/10 \* \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_jdzz.js/g" /scripts/docker/merged_list_file.sh
## 修改美丽颜究院定时
sed -i "s/1 7,12,19 \* \* \* node \/scripts\/jd_beauty.js/30 8,13,20 \* \* \* node \/scripts\/jd_beauty.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/1 7,12,19 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_beauty.js/30 8,13,20 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_beauty.js/g" /scripts/docker/merged_list_file.sh

## 京喜工厂
sed -i "s/https:\/\/gitee.com\/shylocks\/updateTeam\/raw\/main\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/raw.githubusercontent.com\/LXK9301\/updateTeam\/master\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/gitee.com\/lxk0301\/updateTeam\/raw\/master\/shareCodes\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
## 签到领现金
sed -ie "32,33s/^[^\]*/  \`aUNmM6_nOP4j-W4@eU9Yau3kZ_4g-DiByHEQ0A@eU9YaOvnM_4k9WrcnnAT1Q@eU9Yar-3M_8v9WndniAQhA@f0JyJuW7bvQ@IhM0bu-0b_kv8W6E@eU9YKpnxOLhYtQSygTJQ@-oaWtXEHOrT_bNMMVso@eU9YG7XaD4lXsR2krgpG\`,/g" /scripts/jd_cash.js
sed -i "s/https:\/\/gitee.com\/shylocks\/updateTeam\/raw\/main\/jd_cash.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateCash.json/g" /scripts/jd_cash.js
sed -i "s/https:\/\/gitee.com\/lxk0301\/updateTeam\/raw\/master\/shareCodes\/jd_updateCash.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_updateCash.json/g" /scripts/jd_cash.js
## 京东赚赚
sed -i "s/https:\/\/gitee.com\/shylocks\/updateTeam\/raw\/main\/jd_zz.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_zz.json/g" /scripts/jd_jdzz.js
sed -i "s/https:\/\/gitee.com\/lxk0301\/updateTeam\/raw\/master\/shareCodes\/jd_zz.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\/jd_zz.json/g" /scripts/jd_jdzz.js

## 宠汪汪赛跑
wget -O /scripts/jd_joy_run.js https://raw.githubusercontent.com/hduwhyso/sync/main/joyrun.js
sed -i "s/let invite_pins =.*$/let invite_pins = ['zhaosen2580,jd_61f1269fd3236,jd_47ee22449e303,jd_6c5e39478ec3b,mjw6652,liuz9988,18323695900a'];/g" /scripts/jd_joy_run.js
sed -i "s/let run_pins =.*$/let run_pins = ['zhaosen2580,jd_61f1269fd3236,jd_47ee22449e303,jd_6c5e39478ec3b,mjw6652,liuz9988,18323695900a'];/g" /scripts/jd_joy_run.js
sed -i 's/let friendsArr =.*$/let friendsArr = ["zhaosen2580","jd_61f1269fd3236","jd_47ee22449e303","jd_6c5e39478ec3b","mjw6652","liuz9988","18323695900a"]/g' /scripts/jd_joy_run.js

## 修改助力开关
sed -i "s/helpAu = true;/helpAu = false;/g" /scripts/jd_*.js
sed -i "s/helpAuthor = true;/helpAuthor = false;/g" /scripts/jd_*.js
