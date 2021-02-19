#!/bin/sh


echo "整理各个日志文件里面的互助码相关信息......"
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

echo "处理jd_crazy_joy_coin任务......"
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

if [ $JXTUAN_ENABLE = "Y" ]; then
   wget -O /scripts/jd_dreamFactory_tuanid.js https://raw.githubusercontent.com/FKPYW/SomeScripts/master/JXTuan/scripts/jd_dreamFactory_tuanid.js
   sed -i 's/"jd_updateFactoryTuanId.json/"\/scripts\/logs\/jd_updateFactoryTuanId.json/g' /scripts/jd_dreamFactory_tuanid.js
   echo "# 京喜工厂开团" >> /scripts/docker/merged_list_file.sh
   echo "59 */1 * * * node /scripts/jd_dreamFactory_tuanid.js |ts >> /scripts/logs/jd_dreamFactory_tuanid.log 2>&1" >> /scripts/docker/merged_list_file.sh
fi


## 修改闪购盲盒定时
sed -i "s/27 8 \* \* \* node \/scripts\/jd_sgmh.js/27 8,23 \* \* \* node \/scripts\/jd_sgmh.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/27 8 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_sgmh.js/27 8,23 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_sgmh.js/g" /scripts/docker/merged_list_file.sh
## 修改签到领现金定时
sed -i "s/27 7 \* \* \* node \/scripts\/jd_cash.js/27 7,23 \* \* \* node \/scripts\/jd_cash.js/g" /scripts/docker/merged_list_file.sh
sed -i "s/27 7 \* \* \* sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_cash.js/27 7,23 * * * sleep \$((RANDOM % \$RANDOM_DELAY_MAX)); node \/scripts\/jd_cash.js/g" /scripts/docker/merged_list_file.sh

## 替换环球挑战赛助力码
sed -ie "53,54s/^[^\]*/  'Vi9SR2lwcGdLa0IzNENIVFAwUjcxQT09@cm5GeUZMTmMvMDBLNkd2WnprUC9LYWRaV2wvemFDeGJEZnJWNGpoSEZXWT0=',/g" /scripts/jd_global.js

## 参团
sed -i "s/https:\/\/gitee.com\/shylocks\/updateTeam\/raw\/main\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/JavaScript\/master\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/raw.githubusercontent.com\/LXK9301\/updateTeam\/master\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/JavaScript\/master\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/gitee.com\/lxk0301\/updateTeam\/raw\/master\/shareCodes\/jd_updateFactoryTuanId.json/https:\/\/raw.githubusercontent.com\/Aaron-lv\/JavaScript\/master\/jd_updateFactoryTuanId.json/g" /scripts/jd_dreamFactory.js