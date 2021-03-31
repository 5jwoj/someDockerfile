# 百变大咖秀
0 10,11 * * 1-4 node /scripts/z_entertainment.js >> /scripts/logs/z_entertainment.log 2>&1

# 京东超市-大转盘
10 10 * * * node /scripts/z_marketLottery.js >> /scripts/logs/z_marketLottery.log 2>&1

# 母婴-跳一跳
10 8,14,20 25-31 3 * node /scripts/z_mother_jump.js >> /scripts/logs/z_mother_jump.log 2>&1

# 店铺加购有礼
15 12 * * * node /scripts/monk_shop_add_to_car.js >> /scripts/logs/monk_shop_add_to_car.log 2>&1

# 店铺关注有礼
15 15 * * * node /scripts/monk_shop_follow_sku.js >> /scripts/logs/monk_shop_follow_sku.log 2>&1

# 店铺大转盘
5 10,22 * * * node /scripts/monk_shop_lottery.js >> /scripts/logs/monk_shop_lottery.log 2>&1
