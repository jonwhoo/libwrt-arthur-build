#!/bin/bash

#
# ============================================================
# LiBwrt 25.12-nss
# JDC Arthur / JDCloud RE-SS-01
#
# DIY Part 1
# Before feeds update/install
# ============================================================
#

set -e

echo "============================================================"
echo " DIY Part 1"
echo " LiBwrt 25.12-nss / JDC Arthur"
echo "============================================================"

cd "$GITHUB_WORKSPACE/openwrt"

echo
echo ">>> OpenWrt source:"
git remote -v | head -2

echo
echo ">>> OpenWrt branch:"
git branch --show-current || true

#
# ============================================================
# Update official feeds
# ============================================================
#

echo
echo ">>> Updating official feeds..."

./scripts/feeds update -a

echo
echo ">>> Installing official feeds..."

./scripts/feeds install -a


#
# ============================================================
# Replace official proxy cores with sbwml maintained versions
# ============================================================
#

echo
echo ">>> Removing duplicate upstream proxy cores..."

rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/v2ray-core
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/sing-box


#
# ============================================================
# Replace Golang toolchain
#
# sbwml/openwrt_helloworld recommends its packages_lang_golang
# 23.x branch for this package set.
# ============================================================
#

echo
echo ">>> Installing sbwml Golang 1.23 feed..."

rm -rf feeds/packages/lang/golang

git clone \
    --depth 1 \
    -b 23.x \
    https://github.com/sbwml/packages_lang_golang.git \
    feeds/packages/lang/golang


#
# ============================================================
# Clone sbwml OpenWrt extra packages
#
# IMPORTANT:
# Do NOT use scripts/feeds for this repository.
# The upstream README recommends package/helloworld directly.
# ============================================================
#

echo
echo ">>> Cloning sbwml/openwrt_helloworld..."

rm -rf package/helloworld

git clone \
    --depth 1 \
    https://github.com/sbwml/openwrt_helloworld.git \
    package/helloworld


#
# ============================================================
# Verify required applications
# ============================================================
#

echo
echo "============================================================"
echo " Verifying proxy packages"
echo "============================================================"

for pkg in \
    luci-app-openclash \
    luci-app-ssr-plus \
    luci-app-passwall
do
    if [ -d "package/helloworld/$pkg" ]; then
        echo "[OK] $pkg"
    else
        echo "[ERROR] Missing package/helloworld/$pkg"
        exit 1
    fi
done


#
# ============================================================
# Verify required proxy cores
# ============================================================
#

echo
echo ">>> Verifying proxy cores..."

for pkg in \
    mihomo-meta \
    xray-core \
    sing-box \
    shadowsocksr-libev \
    chinadns-ng
do
    if [ -d "package/helloworld/$pkg" ]; then
        echo "[OK] $pkg"
    else
        echo "[WARN] $pkg directory not found"
    fi
done


#
# ============================================================
# Display feeds
# ============================================================
#

echo
echo ">>> feeds.conf.default:"
cat feeds.conf.default

echo
echo "============================================================"
echo " DIY Part 1 completed successfully"
echo "============================================================"
