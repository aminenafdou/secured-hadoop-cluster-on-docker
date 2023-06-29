#!/bin/bash

KRB5_PRINC=nn/$HOSTNAME@${KRB5_REALM}
KRB5_HTTP_PRINC=HTTP/$HOSTNAME@${KRB5_REALM}
KRB5_KEYTAB_PATH=${KRB5_HADOOP_KEYTABS}/nn.service.keytab
SSL_ALIAS=$HOSTNAME

source $(dirname $0)/common-functions.sh

create_internal_directories
create_kerberos_keytabs
create_tls_keystore

# Format HDFS Filesystem
hdfs namenode -format

# Start Namenode
hdfs namenode
