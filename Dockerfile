FROM apache/hadoop:3

LABEL maintainer="aminenafdou@gmail.com"
LABEL description="Simple hadoop cluster distributed as dockers containers"
LABEL codetype="java"
LABEL license="Hadoop: Apache License 2.0"

# Install some debugging tools 
RUN /bin/bash -c 'sudo yum install -y net-tools \
      curl \
      netcat'
