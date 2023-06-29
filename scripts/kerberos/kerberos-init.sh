#!/bin/bash

# Creating KDC Database
echo "Creating master admin user with password : '${KRB5_MASTER_PASSWD}'"
echo -e "${KRB5_MASTER_PASSWD}\n${KRB5_MASTER_PASSWD}\n" | kdb5_util create -s

# Creating kadmin User
echo "Creating admin user with password : '${KRB5_ADMIN_USER_PASSWD}'"
kadmin.local -q "addprinc -pw ${KRB5_ADMIN_USER_PASSWD} admin/admin@${KRB5_REALM}"

# Starting kadmin daemon
kadmind

# Starting KDC server (not in daemon mode)
krb5kdc -n
