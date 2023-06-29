#!/bin/bash

KRB5_PRINC=dn/$HOSTNAME@${KRB5_REALM}
KRB5_KEYTAB_PATH=${KRB5_HADOOP_KEYTABS}/dn.service.keytab
SSL_ALIAS=$HOSTNAME

source $(dirname $0)/common-functions.sh

create_internal_directories
create_kerberos_keytabs
create_tls_keystore

# Start Datanode
hdfs datanode
