#! /vendor/bin/sh

target="$1"
serialno="$2"

btsoc=""

#ifdef OPLUS_FEATURE_WIFI_BDF
#WuGuotian@CONNECTIVITY.WIFI.HARDWARE.BDF.1065227 , 2021/05/26, copy bdf
#Add for make bin Rom-update.
if [ ! -s /mnt/vendor/persist/bdwlan.elf ] ; then
    cp /odm/etc/wifi/bdwlan.elf /mnt/vendor/persist/bdwlan.elf
    sync
fi

if [ -s /odm/etc/wifi/cnss_diag.conf ] ; then
    cp /odm/etc/wifi/cnss_diag.conf /mnt/vendor/persist/wlan/cnss_diag.conf
    chmod 666 /mnt/vendor/persist/wlan/cnss_diag.conf
    sync
fi

if [ ! -s /mnt/vendor/persist/hardware_debug ] ; then
    persistbdf=`md5sum /mnt/vendor/persist/bdwlan.elf |cut -d" " -f1`
    vendorbdf=`md5sum /odm/etc/wifi/bdwlan.elf |cut -d" " -f1`
    if [ x"$vendorbdf" != x"$persistbdf" ]; then
        cp /odm/etc/wifi/bdwlan.elf /mnt/vendor/persist/bdwlan.elf
        sync
        echo "bdf check"
    fi
fi

chmod 666 /mnt/vendor/persist/bdwlan.elf
chown system:wifi /mnt/vendor/persist/bdwlan.elf

#endif /* OPLUS_FEATURE_WIFI_BDF */


#ifdef OPLUS_FEATURE_WIFI_BDF
#WuGuotian@CONNECTIVITY.WIFI.HARDWARE.BDF.1065227, 2021/05/26, copy regbd

if [ ! -s /mnt/vendor/persist/regdb.bin ] ; then
    cp /odm/etc/wifi/regdb.bin /mnt/vendor/persist/regdb.bin
    sync
fi

if [ ! -s /mnt/vendor/persist/hardware_debug ] ; then
    vendorRegdb=`md5sum /mnt/vendor/persist/regdb.bin |cut -d" " -f1`
    persistRegdb=`md5sum /odm/etc/wifi/regdb.bin |cut -d" " -f1`
    if [ x"$vendorRegdb" != x"$persistRegdb" ]; then
        cp /odm/etc/wifi/regdb.bin /mnt/vendor/persist/regdb.bin
        sync
        echo "regdb check"
    fi
fi

chmod 666 /mnt/vendor/persist/regdb.bin
chown system:wifi /mnt/vendor/persist/regdb.bin

#endif /* OPLUS_FEATURE_WIFI_BDF */

#LiJunlong@CONNECTIVITY.WIFI.NETWORK.1065227,2020/08/07
reg_info=`getprop ro.vendor.oplus.euex.country`
if [ "w${reg_info}" = "wUA" ]; then
    sourceFile=/odm/vendor/etc/wifi/WCNSS_qcom_cfg_ua.ini
    echo "export UA file dir config"
else
    sourceFile=/odm/vendor/etc/wifi/WCNSS_qcom_cfg.ini
fi
targetFile=/mnt/vendor/persist/wlan/WCNSS_qcom_cfg.ini
#Yuan.Huang@PSW.CN.Wifi.Network.internet.1065227, 2016/11/09,
#Add for make WCNSS_qcom_cfg.ini Rom-update.
if [ -s "$sourceFile" ]; then
	system_version=`head -1 "$sourceFile" | grep OplusVersion | cut -d= -f2`
	if [ "${system_version}x" = "x" ]; then
		system_version=1
	fi
else
	system_version=1
fi

#LiJunlong@CONNECTIVITY.WIFI.NETWORK,1065227,2020/07/29,Add for rus ini
if [ -s /mnt/vendor/persist/wlan/qca_cld/WCNSS_qcom_cfg.ini ]; then
    cp  /mnt/vendor/persist/wlan/qca_cld/WCNSS_qcom_cfg.ini \
        $targetFile
    sync
    chown system:wifi $targetFile
    chmod 666 $targetFile
    rm -rf /mnt/vendor/persist/wlan/qca_cld
fi

if [ -s "$targetFile" ]; then
	persist_version=`head -1 "$targetFile" | grep OplusVersion | cut -d= -f2`
	if [ "${persist_version}x" = "x" ]; then
		persist_version=0
	fi
else
	persist_version=0
fi


if [ ! -s "$targetFile" -o $system_version -gt $persist_version ]; then
    cp $sourceFile  $targetFile
    sync
    chown system:wifi $targetFile
    chmod 666 $targetFile
fi

persistini=`cat "$targetFile" | grep -v "#" | grep -wc "END"`
if [ x"$persistini" = x"0" ]; then
    cp $sourceFile  $targetFile
    sync
    chown system:wifi $targetFile
    chmod 666 $targetFile
    echo "ini check"
fi

#endif /* OPLUS_FEATURE_WIFI_POWER */
