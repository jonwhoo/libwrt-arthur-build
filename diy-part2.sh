#!/bin/bash

#
# ============================================================
# LiBwrt 25.12-nss
# JDC Arthur / JDCloud RE-SS-01
#
# DIY Part 2
# After feeds update/install
# Before make defconfig
# ============================================================
#

set -e

cd "$GITHUB_WORKSPACE/openwrt"

echo "============================================================"
echo " DIY Part 2"
echo " JDC Arthur customization"
echo "============================================================"


#
# ============================================================
# Default LAN IP
# ============================================================
#

echo
echo ">>> Setting default LAN IP to 192.168.2.1"

sed -i \
    's/192\.168\.1\.1/192.168.2.1/g' \
    package/base-files/files/bin/config_generate


#
# ============================================================
# Default hostname
# ============================================================
#

echo
echo ">>> Setting default hostname to JDC-Arthur"

sed -i \
    's/OpenWrt/JDC-Arthur/g' \
    package/base-files/files/bin/config_generate


#
# ============================================================
# Verify Arthur target configuration BEFORE defconfig
# ============================================================
#

echo
echo "============================================================"
echo " Checking Arthur Target"
echo "============================================================"

grep -E \
    '^CONFIG_TARGET_(qualcommax|qualcommax_ipq60xx|DEVICE_qualcommax_ipq60xx_DEVICE_jdcloud_re-ss-01)=' \
    .config || true


#
# ============================================================
# Verify required applications
# ============================================================
#

echo
echo "============================================================"
echo " Checking required applications"
echo "============================================================"

for pkg in \
    luci-app-openclash \
    luci-app-ssr-plus \
    luci-app-passwall
do
    if [ -d "package/helloworld/$pkg" ]; then
        echo "[OK] $pkg"
    else
        echo "[ERROR] Missing $pkg"
        exit 1
    fi
done


#
# ============================================================
# Verify NSS
# ============================================================
#

echo
echo "============================================================"
echo " Checking NSS packages"
echo "============================================================"

for pkg in \
    nss-firmware-ipq60xx \
    kmod-qca-nss-crypto
do
    if grep -Rqs \
        "Package: $pkg" \
        package/feeds/nss_packages \
        package \
        2>/dev/null; then

        echo "[OK] $pkg"

    else

        echo "[WARN] Could not locate package metadata: $pkg"

    fi
done


#
# ============================================================
# Show proxy package Makefiles
# ============================================================
#

echo
echo ">>> OpenClash:"
grep -E \
    '^(PKG_NAME|PKG_VERSION)' \
    package/helloworld/luci-app-openclash/Makefile \
    2>/dev/null || true

echo
echo ">>> SSR Plus:"
grep -E \
    '^(PKG_NAME|PKG_VERSION|PKG_RELEASE)' \
    package/helloworld/luci-app-ssr-plus/Makefile \
    2>/dev/null || true

echo
echo ">>> PassWall:"
grep -E \
    '^(PKG_NAME|PKG_VERSION|PKG_RELEASE)' \
    package/helloworld/luci-app-passwall/Makefile \
    2>/dev/null || true


#
# ============================================================
# Finished
# ============================================================
#

echo
echo "============================================================"
echo " DIY Part 2 completed successfully"
echo "============================================================"
