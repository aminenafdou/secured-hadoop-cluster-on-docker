#!/bin/bash

KRB5_PRINC=jhs/$HOSTNAME@${KRB5_REALM}
KRB5_HTTP_PRINC=HTTP/$HOSTNAME@${KRB5_REALM}
KRB5_KEYTAB_PATH=${KRB5_HADOOP_KEYTABS}/jhs.service.keytab
SSL_ALIAS=$HOSTNAME

source $(dirname $0)/common-functions.sh

create_internal_directories
create_kerberos_keytabs
create_tls_keystore

# Start History Server 
mapred historyserver
