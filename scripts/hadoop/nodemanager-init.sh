#!/bin/bash

KRB5_PRINC=nm/$HOSTNAME@${KRB5_REALM}
KRB5_HTTP_PRINC=HTTP/$HOSTNAME@${KRB5_REALM}
KRB5_KEYTAB_PATH=${KRB5_HADOOP_KEYTABS}/nm.service.keytab
SSL_ALIAS=$HOSTNAME

source $(dirname $0)/common-functions.sh

create_internal_directories
create_kerberos_keytabs
create_tls_keystore

sudo cp /opt/hadoop/bin/container-executor /var/lib/yarn-ce
sudo chown root:hadoop /var/lib/yarn-ce/container-executor
sudo chmod 6050 /var/lib/yarn-ce/container-executor
sudo chown root:hadoop /var/lib/etc/hadoop/container-executor.cfg
sudo chmod 440 /var/lib/etc/hadoop/container-executor.cfg

# Start NodeManager
yarn nodemanager
