#!/bin/bash

set -e
source myenv/bin/activate


###############################################################################
##           
##                 For testing on local machine 
##           
###############################################################################
HADOOP_USER_NAME=salman   
NAMENODE_IP=127.0.0.1
NAMENODE_PORT=8020
export     LIBHDFS_ROOT_CA_BUNDLE="/tmp/hopsfs-conf/certs/pems/salman_root_ca.pem"
export LIBHDFS_CLIENT_CERTIFICATE="/tmp/hopsfs-conf/certs/pems/salman_certificate_bundle.pem"
export         LIBHDFS_CLIENT_KEY="/tmp/hopsfs-conf/certs/pems/salman_private_key.pem"

            
###############################################################################
##           
##                 For testing  in VM using hdfs user           
##           
###############################################################################
#HADOOP_USER_NAME=hdfs
#NAMENODE_IP=rpc.namenode.service.consul
#NAMENODE_PORT=8020
#export     LIBHDFS_ROOT_CA_BUNDLE="/srv/hops/super_crypto/hdfs/hops_root_ca.pem"
#export LIBHDFS_CLIENT_CERTIFICATE="/srv/hops/super_crypto/hdfs/hdfs_certificate_bundle.pem"
#export         LIBHDFS_CLIENT_KEY="/srv/hops/super_crypto/hdfs/hdfs_priv.pem"


###############################################################################

if [ ! -f  $LIBHDFS_ROOT_CA_BUNDLE ]; then
    echo "$LIBHDFS_ROOT_CA_BUNDLE does not exist"
    exit 1
fi

if [ ! -f  $LIBHDFS_CLIENT_CERTIFICATE ]; then
    echo "$LIBHDFS_CLIENT_CERTIFICATE does not exist"
    exit 1
fi

if [ ! -f  $LIBHDFS_CLIENT_KEY ]; then
    echo "$LIBHDFS_CLIENT_KEY does not exist"
    exit 1
fi


export LIBHDFS_DEFAULT_FS="$NAMENODE_IP:$NAMENODE_PORT"
export LIBHDFS_DEFAULT_USER="$HADOOP_USER_NAME"

# for libhdfs logging
export LIBHDFS_ENABLE_LOG="true"
#export LIBHDFS_LOG_FILE="/tmp/libhdfs.log"

libhdfs_path=$(readlink -f libhdfs.so)
export LD_PRELOAD=$libhdfs_path 
python test.py 
