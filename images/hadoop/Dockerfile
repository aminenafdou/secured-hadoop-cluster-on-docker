FROM ubuntu:focal

LABEL maintainer="aminenafdou@gmail.com"
LABEL description="Simple hadoop cluster distributed as dockers containers"
LABEL codetype="java"
LABEL license="Hadoop: Apache License 2.0"

WORKDIR /opt

# Use Bash as the default shell with 'pipefail' to ensure pipeline failures are detected
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Disable the installation of suggested packages in APT to minimize installed dependencies
RUN echo APT::Install-Suggests "0"\; >> /etc/apt/apt.conf.d/10disableextras

# Disable the installation of recommended packages in APT to further reduce dependencies
RUN echo APT::Install-Recommends "0"\; > /etc/apt/apt.conf.d/10disableextras

# Minimize the verbosity of output during package configuration
ENV DEBCONF_TERSE=true
# Define the path to the Java runtime environment for Java-based applications
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
# Specify the directory where Hadoop logs will be stored
ENV HADOOP_LOG_DIR=/var/log/hadoop
# Define the configuration directory for Hadoop
ENV HADOOP_CONF_DIR=/etc/hadoop
# Redefine the frontend for Debian package manager to noninteractive (repeated for emphasis or override)
ENV DEBIAN_FRONTEND=noninteractive

ARG SPARK_VERSION=3.5.4
ARG HADOOP_VERSION=3.4.1

ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ARG SPARK_URL=https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Set the system PATH to include Hadoop & Spark binaries and other essential directories
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/hadoop/bin:/opt/spark/sbin:/opt/spark/bin

RUN /bin/bash -c 'apt update -y'
RUN /bin/bash -c 'apt install -y sudo python3-pip wget openjdk-8-jdk curl krb5-user'

# Create a new group named 'hadoop' with the group ID (GID) set to 1000
RUN /bin/bash -c 'groupadd --gid 1000 hadoop'
# Create a new user named 'hadoop' with the user ID (UID) set to 1000,
# assign the user to the group with GID 100, and set the home directory to /opt/hadoop
RUN /bin/bash -c 'useradd --uid 1000 hadoop --gid 100 --home /opt/hadoop'

# Add a sudoers entry to allow the 'hadoop' user passwordless sudo access to all commands globally
RUN /bin/bash -c 'echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
# Add a sudoers entry to allow members of the 'hadoop' group passwordless sudo access, stored in a dedicated sudoers file
RUN /bin/bash -c 'echo "%hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/hadoop'

# Add users hdfs,yarn,mapred to hadoop group (which is a sudoer)
RUN /bin/bash -c 'useradd -d /opt/hadoop -u 1001 -g 1000 hdfs -s /usr/sbin/nologin'
RUN /bin/bash -c 'useradd -d /opt/hadoop -u 1002 -g 1000 yarn -s /usr/sbin/nologin'
RUN /bin/bash -c 'useradd -d /opt/hadoop -u 1003 -g 1000 mapred -s /usr/sbin/nologin'
RUN /bin/bash -c 'useradd -d /opt/spark  -u 1004 -g 1000 spark -s /usr/sbin/nologin'

# User that will be used for tests...
RUN /bin/bash -c 'useradd -d /opt/hadoop -u 1005 -g 1000 tester -s /usr/sbin/nologin'


RUN /bin/bash -c 'rm -rf /opt/hadoop && \
     curl -LSs -o hadoop.tar.gz $HADOOP_URL && \
     tar zxf hadoop.tar.gz && rm hadoop.tar.gz && mv hadoop* hadoop && \
     rm -rf /opt/hadoop/share/doc'

RUN /bin/bash -c 'mkdir -p /etc/security/keytabs/hadoop && \
                  mkdir -p /etc/hadoop && \
                  mkdir -p /var/log/hadoop && \
                  chown -R hadoop:hadoop /etc/security/keytabs && \
                  chown -R hadoop:hadoop /opt && \
                  chmod -R 770 /etc/security/keytabs && \
                  chmod -R 1777 /etc/hadoop && \
                  chmod -R 1777 /var/log/hadoop'

RUN /bin/bash -x -c 'curl -LSs -o spark.tar.gz $SPARK_URL && \
     tar -xvf spark.tar.gz -C /opt && rm spark.tar.gz && mv spark* spark && \
     chown -R spark:hadoop /opt/spark* && chmod -R 771 /opt/spark*'

# Install some debugging tools 
RUN /bin/bash -c 'apt install -y net-tools bind9-utils dnsutils vim less'

WORKDIR /opt
