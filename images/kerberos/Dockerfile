FROM ubuntu:focal

LABEL maintainer="aminenafdou@gmail.com"
LABEL description="Simple Kerberos server"

ENV DEBIAN_FRONTEND noninteractive

# Add kerberos user in the group 0 to have access to the mounted volumes and storage
RUN /bin/bash -c 'useradd -m -u 1000 -g 0 kerberos'

# Create directories for kerberos
RUN /bin/bash -c 'mkdir -p /var/log/kerberos \
                  mkdir -p /var/kerberos \
                  mkdir -p /var/lib/krb5kdc\
                  mkdir -p /etc/krb5kdc'

# Change ownership
RUN /bin/bash -c 'chown -R kerberos /var/log/kerberos/ /var/lib/krb5kdc /etc/krb5kdc'

# Install some debugging tools & kerberos server packages
RUN /bin/bash -c 'apt update && apt-get install -y\
    net-tools bind9-utils dnsutils vim strace\
    ntp krb5-kdc krb5-admin-server krb5-config'

USER kerberos

EXPOSE 88
EXPOSE 464
EXPOSE 749
