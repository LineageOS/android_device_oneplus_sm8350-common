#! /vendor/bin/sh
#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# 18821 - 7 Pro
# 18831 - 7 Pro TMO
# 18857 - 7
# 18865 - 7T
# 19801 - 7T Pro
# 19863 - 7T TMO

if grep -qE "androidboot.rf_version=(11|13|21)" /proc/cmdline; then
    setprop vendor.radio.multisim.config dsds
fi
