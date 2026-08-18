#!/bin/bash
# 描述: 修改默认配置与修复包冲突

# 1. 修改默认后台 IP (可改为你需要的 IP，如 192.168.66.1)
sed -i 's/192.168.1.1/192.168.66.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认主机名
sed -i 's/OpenWrt/JDC-Arthur/g' package/base-files/files/bin/config_generate

# 3. 移除重复/冲突的软件包（确保编译顺利）
rm -rf feeds/luci/applications/luci-app-openclash
