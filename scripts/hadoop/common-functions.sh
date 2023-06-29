#!/bin/bash

function create_internal_directories() {
    sudo mkdir -p ${SSL_KEYSTORES_PATH}
    sudo chown ${HADOOP_USER}:${HADOOP_GROUP} -R ${SSL_KEYSTORES_PATH}
    sudo chown ${HADOOP_USER}:${HADOOP_GROUP} -R ${SSL_TRUSTSTORES_PATH}
    sudo chown ${HADOOP_USER}:${HADOOP_GROUP} -R ${SCRIPTS_PATH}
    sudo chmod +x -R ${SCRIPTS_PATH}
}


function create_kerberos_keytabs() {

    # FIXME : Create an empty/dumb keytab
    echo -e "\0005\0002\c" > ${KRB5_KEYTAB_PATH}

    kadmin -w ${KRB5_ADMIN_USER_PASSWD} -p admin/admin@${KRB5_REALM} \
    -q "addprinc -e  aes256-cts -randkey ${KRB5_PRINC}"
    kadmin -w ${KRB5_ADMIN_USER_PASSWD} -p admin/admin@${KRB5_REALM} \
    -q "ktadd -e  aes256-cts -k ${KRB5_KEYTAB_PATH} ${KRB5_PRINC}"

    if [ -v KRB5_HTTP_PRINC ]; then
        # HTTP SPN
        kadmin -w ${KRB5_ADMIN_USER_PASSWD} -p admin/admin@${KRB5_REALM} \
        -q "addprinc -e  aes256-cts -randkey ${KRB5_HTTP_PRINC}"
        kadmin -w ${KRB5_ADMIN_USER_PASSWD} -p admin/admin@${KRB5_REALM} \
        -q "ktadd -e  aes256-cts -k ${KRB5_KEYTAB_PATH} ${KRB5_HTTP_PRINC}"
    fi

    klist -kt ${KRB5_KEYTAB_PATH} -e 

}

function create_tls_keystore() {

    # Generate a Keystore with a PrivateKey/Certificate
    keytool -genkey -alias ${SSL_ALIAS} \
            -keyalg rsa -keysize 1024 \
            -dname "CN=${HOSTNAME},OU=LOCAL,O=HADOOP" \
            -keypass ${STORE_PASSWD} -storepass ${STORE_PASSWD} \
            -keystore ${SSL_KEYSTORE_PATH}

    # Export Service Certificate
    keytool -exportcert -v -alias ${SSL_ALIAS} \
            -file ${SSL_KEYSTORES_PATH}/${SSL_ALIAS}.cer \
            -keystore ${SSL_KEYSTORE_PATH}

    # Import Service Certificate into Trusted Hadoop certificates
    keytool  -importcert -alias ${SSL_ALIAS} \
            -file ${SSL_KEYSTORES_PATH}/${SSL_ALIAS}.cer \
            -keypass ${STORE_PASSWD} -storepass ${STORE_PASSWD} \
            -keystore ${SSL_TRUSTSTORE_PATH} -noprompt

    # Show Keystore Content
    echo -e "\n\n ==================== Keystore Content : ================================="
    echo ${STORE_PASSWD} | keytool -keystore ${SSL_KEYSTORE_PATH} -v -list

    # Show Trustore Content
    echo -e "\n\n ==================== Trustore Content : ================================="
    echo ${STORE_PASSWD} | keytool -keystore ${SSL_TRUSTSTORE_PATH} -v -list

}