#!/bin/bash
. /etc/jelastic/environment
CONFFILE="/opt/repo/versions/${Version}/neo4j-${Version}/conf/variables.conf"
JELASTIC_GC_AGENT="jelastic-gc-agent.jar"

SED=`which sed`
AWK=`which awk`
GREP=`which grep`
DEBUG=0
GC=""

if [ "$1" == "debug" ]
then
    DEBUG=1
fi
confresult=" "
if [ -f $CONFFILE ]
then
    confdata=`$SED '/^#/d' $CONFFILE | $AWK -F# '{print $1}' |$SED 's/\s/\n/g'`
    for i in $confdata
    do
        if `echo $i | grep -q '#'`; then continue;fi
            [ "$DEBUG" -eq 1 ] && echo "Ok    : $i" 1>&2;
            if `echo $i | $GREP -qiE '\-Xmx[[:digit:]]{1,}[mgkMGK]$'`; then XMX="${i:4}"; continue; fi
            if `echo $i | $GREP -qiE '\-Xms[[:digit:]]{1,}[mgkMGK]$'`; then XMS="${i:4}"; continue; fi
            if `echo $i | $GREP -qiE '\-Xmn[[:digit:]]{1,}[mgkMGK]$'`; then XMN="${i:4}"; continue; fi
            if `echo $i | $GREP -qie '\-XX:+Use[[:alnum:]]\{1,\}GC$'`; then GC=$GC" $i"; continue; fi

            confresult=$(echo " $confresult" " $i" | sed -e 's/&/\\&/g' -e 's/;/\\;/g' -e "s/?/\\?/g" -e "s/*/\\*/g" -e "s/(/\\(/g" -e "s/)/\\)/g")
        done
fi


if `echo $confresult | grep -q ${JELASTIC_GC_AGENT}`;
then
    if ! `echo $confresult | grep -q 'UseAdaptiveSizePolicy'`;
    then
	confresult=$confresult" -XX:-UseAdaptiveSizePolicy"
    fi
fi

[ "$DEBUG" -eq 1 ] && {
    echo "confresult=$confresult"
    echo "XMX=$XMX"
    echo "XMS=$XMS"
    echo "XMN=$XMN"
    echo "GC=$GC"
}
