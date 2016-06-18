#!/bin/bash 

. /etc/jelastic/environment

SED=$(which sed);

NEO4J_WRAPPER_PROP_FILE="${OPENSHIFT_NEO4J_DIR}/versions/${Version}/neo4j-${Version}/conf/neo4j-wrapper.conf";

[ -e ${OPENSHIFT_NEO4J_DIR}/versions/${Version}/neo4j-${Version}/bin/variablesparser.sh ] && . ${OPENSHIFT_NEO4J_DIR}/versions/${Version}/neo4j-${Version}/bin/variablesparser.sh;

$SED -i "s/^#wrapper.java.initmemory/wrapper.java.initmemory/g" $NEO4J_WRAPPER_PROP_FILE;
$SED -i "s/^wrapper.java.initmemory=.*/wrapper.java.initmemory=32/" $NEO4J_WRAPPER_PROP_FILE;

$SED -i "s/^#wrapper.java.maxmemory/wrapper.java.maxmemory/g" $NEO4J_WRAPPER_PROP_FILE;
$SED -i "s/^wrapper.java.maxmemory=.*/wrapper.java.maxmemory=${XMX_VALUE}/" $NEO4J_WRAPPER_PROP_FILE;
