#! /vendor/bin/sh
#***********************************************************
#** Copyright (C), 2021, OPPO Mobile Comm Corp., Ltd.
#** OPLUS_FEATURE_BT_RESOURCE_SAU
#**
#** Version: 1.0
#** Date : 2021/01/06
#** Author: YangQiang@CONNECTIVITY.BT
#** change permission of /data/vendor/bluetooth/fw for supporting QC firmware update by sau_res for bluetooth model.
#**
#** ---------------------Revision History: ---------------------
#**  <author>    <data>       <version >       <desc>
#**  Yangqiang   2021/01/06     1.0     build this module
#****************************************************************/


config="$1"

function changeBtFwPermission() {
    chown -R bluetooth bluetooth /data/vendor/bluetooth/fw/
#    chmod 0777 /data/vendor/bluetooth/fw/*
    chmod -R 0777 /data/vendor/bluetooth/fw/
}

case "$config" in
        "changeBtFwPermission")
        changeBtFwPermission
    ;;
esac
