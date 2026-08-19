#!/bin/bash
# 描述: 修改默认配置与修复包冲突

# 如果在根目录，进入 openwrt 文件夹；如果已经在 openwrt 文件夹，则跳过
[ -d openwrt ] && cd openwrt

# 1. 修改默认后台 IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认主机名
sed -i 's/OpenWrt/JDC-Arthur/g' package/base-files/files/bin/config_generate

# 3. 移除冲突的软件包
rm -rf feeds/luci/applications/luci-app-openclash
