#!/bin/sh
set -e

##定义合并定时任务相关文件路径变量
defaultListFile="/jds/updateTeam/$DEFAULT_LIST_FILE"
customListFile="/jds/updateTeam/$CUSTOM_LIST_FILE"
mergedListFile="/jds/updateTeam/merged_list_file.sh"


##京东京喜工厂自动开团
if [ $jd_jxFactoryCreateTuan_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/updateTeam/g" /scripts/jd_jxFactoryCreateTuan.js
    echo "# 京东京喜工厂自动开团" >> /jds/updateTeam/merged_list_file.sh
    echo "55 */1 * * * node /scripts/jd_jxFactoryCreateTuan.js >> /scripts/logs/jd_jxFactoryCreateTuan.log 2>&1" >> /jds/updateTeam/merged_list_file.sh
fi
