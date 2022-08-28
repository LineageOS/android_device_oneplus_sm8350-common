#! /vendor/bin/sh
#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

if grep simcardnum.doublesim=1 /proc/cmdline | grep -qv androidboot.opcarrier=tmo; then
    setprop vendor.radio.multisim.config dsds
fi
