# 百变大咖秀
0 10,11 * * 1-4 node /scripts/z_entertainment.js >> /scripts/logs/z_entertainment.log 2>&1

# 联想集卡活动
10 15 15-29 3 * node /scripts/z_lenovo.js >> /scripts/logs/z_lenovo.log 2>&1

# 京东超市-大转盘
10 10 * * * node /scripts/z_marketLottery.js >> /scripts/logs/z_marketLottery.log 2>&1

# 母婴-跳一跳
10 8,14,20 25-31 3 * node /scripts/z_mother_jump.js >> /scripts/logs/z_mother_jump.log 2>&1

# 答题赢京豆
5 1 23-25 3 * node /scripts/z_grassy.js >> /scripts/logs/z_grassy.log 2>&1

# 京东小魔方
10 10 25-27 3 * node /scripts/z_xmf.js >> /scripts/logs/z_xmf.log 2>&1

# 店铺大转盘
5 10,22 * * * node /scripts/monk_shop_lottery.js >> /scripts/logs/monk_shop_lottery.log 2>&1
