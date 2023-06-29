#!/bin/bash

KRB5_PRINC=tester@${KRB5_REALM}
KRB5_KEYTAB_PATH=${KRB5_HADOOP_KEYTABS}/tester.keytab

source $(dirname $0)/common-functions.sh

create_kerberos_keytabs
