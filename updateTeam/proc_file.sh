#!/bin/sh

##定义合并定时任务相关文件路径变量
defaultListFile="/jds/updateTeam/$DEFAULT_LIST_FILE"
customListFile="/jds/updateTeam/$CUSTOM_LIST_FILE"
mergedListFile="/jds/updateTeam/merged_list_file.sh"

function initupdateTeam() {
    mkdir /updateTeam
    cd /updateTeam
    git init
    git remote add -f origin $updateTeam_URL
    git config --global user.email "$email"
    git config --global user.name "$name"
    echo -e $KEY > /root/.ssh/id_rsa
    git pull origin master --rebase
}

if [ 0"$updateTeam_URL" = "0" ]; then
    echo "没有配置远程仓库地址，跳过初始化。"
else
    if [ ! -d "/updateTeam/" ]; then
        echo "未检查到updateTeam仓库，初始化下载..."
        initupdateTeam
    else
        cd /updateTeam
        echo "更新updateTeam仓库文件..."
        git reset --hard
        git pull origin master --rebase
    fi
fi

##京东京喜工厂自动开团
if [ $jd_jxFactoryCreateTuan_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/shareCodes/g" /scripts/jd_jxFactoryCreateTuan.js
    echo "执行京东京喜工厂自动开团..."
    node /scripts/jd_jxFactoryCreateTuan.js >> /scripts/logs/jd_jxFactoryCreateTuan.log 2>&1
fi

##更新领现金
if [ $jd_updateCash_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/shareCodes/g" /scripts/jd_updateCash.js
    echo "执行更新领现金..."
    node /scripts/jd_updateCash.js >> /scripts/logs/jd_updateCash.log 2>&1
fi

##赚京豆小程序
if [ $jd_zzUpdate_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/shareCodes/g" /scripts/jd_zzUpdate.js
    echo "执行赚京豆小程序..."
    node /scripts/jd_zzUpdate.js >> /scripts/logs/jd_zzUpdate.log 2>&1
fi

cp -rf /shareCodes /updateTeam/
echo "提交updateTeam仓库文件..."
git add -A
git commit -m "更新JSON文件"
git push origin master
