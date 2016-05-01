#!/bin/bash 

. /etc/jelastic/environment

SED=$(which sed);

NEO4J_WRAPPER_PROP_FILE="${OPENSHIFT_NEO4J_DIR}/versions/${Version}/neo4j-${Version}/conf/neo4j-wrapper.conf";

[ -e ${OPENSHIFT_NEO4J_DIR}/versions/${Version}/neo4j-${Version}/bin/variablesparser.sh ] && . ${OPENSHIFT_NEO4J_DIR}/versions/${Version}/neo4j-${Version}/bin/variablesparser.sh;

[ -z "$XMS" ] && XMS=32 || XMS=$(echo $XMS | grep -o "[0-9]*")
[ -z "$XMX" ] && { memory_total=`free -m | grep Mem | awk '{print $2}'`; let XMX=memory_total-35; XMX="${XMX}"; } || XMX=$(echo $XMX | grep -o "[0-9]*")

$SED -i "s/^#wrapper.java.initmemory/wrapper.java.initmemory/g" $NEO4J_WRAPPER_PROP_FILE;
$SED -i "s/^wrapper.java.initmemory=.*/wrapper.java.initmemory=${XMS}/" $NEO4J_WRAPPER_PROP_FILE;

$SED -i "s/^#wrapper.java.maxmemory/wrapper.java.maxmemory/g" $NEO4J_WRAPPER_PROP_FILE;
$SED -i "s/^wrapper.java.maxmemory=.*/wrapper.java.maxmemory=${XMX}/" $NEO4J_WRAPPER_PROP_FILE;
