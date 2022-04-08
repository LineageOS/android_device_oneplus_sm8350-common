#!/vendor/bin/sh

NATIVE_PROCESS_LIST="mediaserver mediadrmserver audioserver netd"
JAVA_PROCESS_LIST=""
#############################function defined part start##########################################
prepare_env()
{
	if [ -d "/sdcard/" ];then
		mkdir  -p /sdcard/oppo_log/sec_debug
		target_dir='/sdcard/oppo_log/sec_debug'
	else
		if [ -d "/data/" ];then
			mkdir -p /data/oppo_log/sec_debug
			target_dir='/data/oppo_log/sec_debug'
		fi
	fi
}

dump_system_env_info()
{
	ps -A -T -Z -O pri,nice,rtprio,sched,pcy,bit,cpu,name > $target_dir/SYS_PROCESSES_AND_THREADS
	/system/bin/dumpsys meminfo > $target_dir/DUMPSYS_MEMINFO
	cat /proc/meminfo > $target_dir/SYS_MEMORY_INFO
	cat /proc/slabinfo > $target_dir/SYS_SLAB_INFO
	echo w > /proc/sysrq-trigger
	echo l > /proc/sysrq-trigger
	dmesg > $target_dir/SYS_DMESG_LOG
	df > $target_dir/SYS_DF
	top -m 10 -n 2 > $target_dir/SYS_TOP
	cat /proc/interrupts > $target_dir/SYS_INTERRUPTS
}

dump_system_server_info()
{
	system_server_pid=$(pidof system_server)
	if [ $system_server_pid != 1 ];then
		kill -3 $system_server_pid
		echo system_server $system_server_pid dump done
	fi
}

dump_surfaceflinger_info()
{
    sf_pid=$(pidof surfaceflinger)
	if [ $sf_pid != 1 ];then
		debuggerd -b $sf_pid > $target_dir/surfaceflinger
		/system/bin/dumpsys SurfaceFlinger --dps dbg--dr
		#adb pull /data/oppo_log/sf
		echo SurfaceFlinger $sf_pid dump done
	fi
}

dump_native_deamon_callstack()
{
	for dump_process in $NATIVE_PROCESS_LIST; do
		dump_process_pid=$(pidof $dump_process)
		echo process name $dump_process $dump_process_pid
		if [ $dump_process_pid != 1 ];then
			debuggerd -b $dump_process_pid  > $target_dir/$dump_process
			echo $dump_process $dump_process_pid dump done
		fi
	done
}

dump_java_process_callstack()
{
	for dump_process in $JAVA_PROCESS_LIST; do
		dump_process_pid=$(pidof $dump_process)
		echo process name $dump_process $dump_process_pid
		if [ $dump_process_pid != 1 ];then
			kill -3 $dump_process_pid
			echo $dump_process $dump_process_pid dump done
		fi
	done
}
#############################function defined part end##########################################


############################function called logic start#########################################
echo $PATH
export PATH=$PATH:/sbin:/system/sbin:/product/bin:/apex/com.android.runtime/bin:/system/bin:/system/xbin:/odm/bin:/vendor/bin:/vendor/xbin
echo $PATH
prepare_env
dump_system_env_info
dump_system_server_info
dump_surfaceflinger_info
dump_native_deamon_callstack
dump_java_process_callstack

#############################function called logic end##########################################
