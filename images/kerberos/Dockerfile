FROM ubuntu:focal

WORKDIR /root

LABEL maintainer="aminenafdou@gmail.com"
LABEL description="Simple Kerberos server"

ENV DEBIAN_FRONTEND noninteractive

# Create log directories for kerberos
RUN /bin/bash -c 'mkdir -p /var/log/kerberos\
    mkdir -p /var/kerberos'

# Install some debugging tools & kerberos server packages
RUN /bin/bash -c 'apt update && apt-get install -y\
    net-tools bind9-utils dnsutils vim strace\
    ntp krb5-kdc krb5-admin-server krb5-config'

EXPOSE 88
EXPOSE 464
EXPOSE 749
