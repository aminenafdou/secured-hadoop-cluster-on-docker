#!/bin/bash

source $(dirname $0)/common-functions.sh
create_internal_directories

# creating tester keytab
KRB5_PRINC=tester@${KRB5_REALM}
KRB5_KEYTAB_PATH=${KRB5_HADOOP_KEYTABS}/tester.keytab
create_kerberos_keytabs

# Begin - Specific for Spark history server
KRB5_PRINC=shs/$HOSTNAME@${KRB5_REALM}
KRB5_KEYTAB_PATH=${KRB5_HADOOP_KEYTABS}/shs.service.keytab
create_kerberos_keytabs

kinit -kt /etc/security/keytabs/hadoop/shs.service.keytab shs/edgenode-1.hadoop@HADOOP.LOCAL
hdfs dfs -mkdir hdfs://namenode-1.hadoop/spark-logs
kdestroy 

sudo -E -u spark /opt/spark/sbin/start-history-server.sh
# End - Specific for Spark history server

# Begin - Specific for Yarn Job history server
KRB5_PRINC=jhs/$HOSTNAME@${KRB5_REALM}
KRB5_HTTP_PRINC=HTTP/$HOSTNAME@${KRB5_REALM}
KRB5_KEYTAB_PATH=${KRB5_HADOOP_KEYTABS}/jhs.service.keytab
SSL_ALIAS=$HOSTNAME

create_kerberos_keytabs
create_tls_keystore

sudo -E -u mapred /opt/hadoop/bin/mapred historyserver
# End - Specific for Yarn Job history server
