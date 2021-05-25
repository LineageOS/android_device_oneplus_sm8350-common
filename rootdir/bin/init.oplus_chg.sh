#! /vendor/bin/sh

export PATH=/vendor/bin

prefix="/sys/class/oplus_chg"
call_on_name="call_on"

if [[ -d "$prefix" ]]
then
    for i in `ls "$prefix"`
    do
        for j in `ls "$prefix"/"$i"`
        do
            #skip directories to prevent possible security issues.
            if [[ -d "$prefix"/"$i"/"$j" ]]
            then
                continue
            else
                if [[ "$j" == "$call_on_name" ]]
                then
                    chown -h radio.radio "$prefix"/"$i"/"$j"
                else
                    chown -h system.system "$prefix"/"$i"/"$j"
                fi
            fi
        done
    done
fi

