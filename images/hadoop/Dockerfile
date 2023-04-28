FROM apache/hadoop:3

LABEL maintainer="aminenafdou@gmail.com"
LABEL description="Simple hadoop cluster distributed as dockers containers"
LABEL codetype="java"
LABEL license="Hadoop: Apache License 2.0"

USER root

RUN echo "%hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/hadoop

# Add users hdfs,yarn,mapred to hadoop group (which is a sudoer)
# The user is in the group 0 to have access to the mounted volumes and storage
RUN /bin/bash -c 'sudo useradd -d /opt/hadoop -u 1001 -g 1000 hdfs'
RUN /bin/bash -c 'sudo useradd -d /opt/hadoop -u 1002 -g 1000 yarn'
RUN /bin/bash -c 'sudo useradd -d /opt/hadoop -u 1003 -g 1000 mapred'

# Could be chaned in the next version so maybe it's better to fix it here...
ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz

# Install some debugging tools 
RUN /bin/bash -c 'sudo yum install -y net-tools bind-utils dnsutils vim'
