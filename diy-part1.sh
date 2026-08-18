#!/bin/bash
# 描述: 编译前引入第三方软件源 (Feeds)

# 1. OpenClash
echo 'src-git openclash https://github.com/vernesong/OpenClash.git;master' >> feeds.conf.default

# 2. PassWall 及其依赖包
echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main' >> feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main' >> feeds.conf.default

# 3. SSR+ (helloworld)
echo 'src-git helloworld https://github.com/fw876/helloworld.git;master' >> feeds.conf.default
