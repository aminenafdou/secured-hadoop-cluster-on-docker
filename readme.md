
# Simple HDFS Multi-nodes cluster deployed on  a set of docker containers

## How to deploy it ?

```
cd hadoop-developer-starterkit
docker compose up --build --detach

# a little workaround to resolve containers name on the host - must be applied as a root
sudo bash -c "awk '/hostname/ {h=\$2} /ipv4_address/ {printf \"%s %s\n\", \$2, h}' compose.yaml >> /etc/hosts"
```
## How to undeploy it ?
```
docker compose down --volumes --remove-orphans
```

## Component(s) version(s) 
```
# Docker image used : https://registry.hub.docker.com/layers/apache/hadoop/3/images/sha256-793348d0839a55d27fb9466d4a5f7e058744866f5ab2cb7aa32f541b4810b215?context=explore
Hadoop : 3.3.1

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

## Namenode(s) and Datanode(s) Web UI 

 -  [**HDFS Namenode web UI**](http://namenode_1:9870)

 - [**HDFS Datanode N° 1 web UI**](http://datanode_1:9864)

 - [**HDFS Datanode N° 2 web UI**](http://datanode_2:9864)

 - [**HDFS Datanode N° 3 web UI**](http://datanode_3:9864)



## Quick Test 

A simple Hello world file on HDFS ! XD
```
sudo docker exec -it hadoop-developer-starterkit-edge_1-1 bash
# put a simple Hello Wolrd ! in hdfs
echo 'Hello World !' | hdfs dfs -put - /newfile.txt
# and then show it
hdfs dfs -cat /newfile.txt

# or maybe a quick way to generate a dumb file of 1GB
filename=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1); dd if=/dev/urandom of="$filename" bs=1M count=100 && hdfs dfs -put "$filename" / && rm "$filename"
```

## Useful commands 
```
# open an interactive bash session on the container of namenode
docker exec -it hadoop-developer-starterkit-namenode-1 bash

# open an interactive bash session on the container of the first datanode
docker exec -it hadoop-developer-starterkit-datanode_1-1 bash

# open an interactive bash session on the container of second datanode
docker exec -it hadoop-developer-starterkit-datanode_2-1 bash

# open an interactive bash session on the container of third datanode
docker exec -it hadoop-developer-starterkit-datanode_3-1 bash

# open an interactive bash session on the container of edge
docker exec -it hadoop-developer-starterkit-edge_1-1 bash
```

## HDFS Cluster communication simplified

![HDFS communication simplified](hdfs-cluster-simplified.png)


## The internal ports used by a Hadoop Namenode(s) are:

```
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name                  
tcp        0      0 0.0.0.0:9870            0.0.0.0:*               LISTEN      1000       95772      14/java             
tcp        0      0 192.168.100.2:8020      0.0.0.0:*               LISTEN      1000       95790      14/java             
tcp        0      0 192.168.100.2:8020      192.168.100.4:51728     ESTABLISHED 1000       113288     14/java             
tcp        0      0 192.168.100.2:8020      192.168.100.5:47282     ESTABLISHED 1000       113287     14/java             
tcp        0      0 192.168.100.2:8020      192.168.100.3:43566     ESTABLISHED 1000       113289     14/java   
```

 - **9870 :** HDFS Namenode web UI (http) => dfs.namenode.http-address
 - **8020 :** HDFS Namenode IPC/RPC interface => fs.default.name

## The internal ports used by a Hadoop Datanode(s) are:

```
hdfs dfs -appendToFile 
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name    
tcp        0      0 0.0.0.0:9864            0.0.0.0:*               LISTEN      1000       103332     14/java             
tcp        0      0 0.0.0.0:9866            0.0.0.0:*               LISTEN      1000       114859     14/java             
tcp        0      0 0.0.0.0:9867            0.0.0.0:*               LISTEN      1000       92786      14/java             
```

 - **9864:** HTTP port used for browsing the status and data on a datanode => dfs.datanode.http.address
 - **9866:** Data Transfer Protocol (DTP) is used for communication between Datanodes for transferring blocks.
 - **9867:** The datanode IPC/RPC server address and port.

## Client and Namenode and Datanode Communication:

```
hdfs dfs -cat /newfile.txt && netstat -laputen

Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name      
tcp        0  65047 192.168.100.100:48062   192.168.100.4:9866      ESTABLISHED 1000       159033     2017/java       
tcp        0      0 192.168.100.100:42354   192.168.100.2:8020      ESTABLISHED 1000       105980     2017/java                
                
```
 - **8020:** RPC/IPC is used for communication between the client and Namenode.
 - **9866:** DTP is used for communication between the client and Datanodes for reading or writing data.
