FROM apache/hadoop:3

LABEL maintainer="aminenafdou@gmail.com"
LABEL description="Simple hadoop cluster distributed as dockers containers"
LABEL codetype="java"
LABEL license="Hadoop: Apache License 2.0"

# Could be chaned in the next version so maybe it's better to fix it here...
ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz

# Install some debugging tools 
RUN /bin/bash -c 'sudo yum install -y net-tools bind-utils dnsutils vim'
