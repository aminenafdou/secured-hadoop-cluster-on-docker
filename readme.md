
# Simple secured HDFS/YARN Multi-nodes cluster deployed on a set of docker containers

This is a small secured cluster i use personnally to test new functionalities on new releases of hadoop...

## How to deploy it ?

```
docker compose up --build --force-recreate

# a little workaround to resolve containers name on the host - must be applied as a root
sudo bash -c "awk '/hostname/ {h=\$2} /ipv4_address/ {printf \"%s %s\n\", \$2, h}' compose.yaml >> /etc/hosts"
```
## How to undeploy it ?
```
docker compose down --volumes --remove-orphans
```

## Component(s) version(s) 
```
Docker image used : https://registry.hub.docker.com/layers/apache/hadoop/3/images/sha256-793348d0839a55d27fb9466d4a5f7e058744866f5ab2cb7aa32f541b4810b215?context=explore

Hadoop : 3.3.5

Java : 1.8.0_212

Client: Docker Engine - Community
 Version:           23.0.1
 API version:       1.42
 Go version:        go1.19.5
 Git commit:        a5ee5b1
 Built:             Thu Feb  9 19:47:01 2023
 OS/Arch:           linux/amd64
 Context:           default

 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d

 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

 buildx: Docker Buildx (Docker Inc.)
   Version:  v0.10.2
   
 compose: Docker Compose (Docker Inc.)
   Version:  v2.16.0
   
 scan: Docker Scan (Docker Inc.)
   Version:  v0.23.0

```

## Namenode(s), Datanode(s), ResourceManager(s) and NodeManager(s) Web UI 

 - [**HDFS Namenode web UI**](https://namenode-1.hadoop:9871)

 - [**HDFS Datanode N° 1 web UI**](https://datanode-1.hadoop:9865)

 - [**HDFS Datanode N° 2 web UI**](https://datanode-2.hadoop:9865)

 - [**YARN ResourceManager web UI**](https://resourcemanager-1.hadoop:8090)

 - [**YARN NodeManager N° 1 web UI**](https://nodemanager-1.hadoop:8044)

 - [**YARN NodeManager N° 2 web UI**](https://nodemanager-1.hadoop:8044)

## Quick Test 

A simple Hello world file on HDFS ! XD
```
docker exec -it edgenode-1 bash

# Kerberos Log in as user tester
kinit -kt /etc/security/keytabs/tester.keytab tester

# put a simple Hello Wolrd ! in hdfs
echo 'Hello World !' | hdfs dfs -put - /newfile.txt
# and then show it
hdfs dfs -cat /newfile.txt

# or maybe a quick way to generate a dumb file of 1GB
filename=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1); dd if=/dev/urandom of="$filename" bs=1M count=1000 && hdfs dfs -put "$filename" / && rm "$filename"

# put a simple file on hdfs as an input for the map-reduce job to run on yarn
echo 'Hadoop is the Elephant King! \\nA yellow and elegant thing.\\nHe never forgets\\nUseful data, or lets\\nAn extraneous element cling! ' | hdfs dfs -put - /input.txt

# run a simple map-reduce job on yarn (wordcount example)
yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar wordcount /input.txt /output

# and then show it
hdfs dfs -cat /output/*

```

## Useful commands

```
# open an interactive bash session on the container of hdfs namenode
docker exec -it namenode-1 bash

# open an interactive bash session on the container of the first hdfs datanode
docker exec -it datanode-1 bash

# open an interactive bash session on the container of second hdfs datanode
docker exec -it datanode-2 bash

# open an interactive bash session on the container of edge
docker exec -it edgenode-1 bash

# open an interactive bash session on the container of yarn resourcemanager
docker exec -it resourcemanager-1 bash

# open an interactive bash session on the container of yarn node manager 1
docker exec -it nodemanager-1 bash

# open an interactive bash session on the container of yarn node manager 2
docker exec -it nodemanager-2 bash

# open an interactive bash session on the container of kerberos server
docker exec -it kerberos-server bash
```
