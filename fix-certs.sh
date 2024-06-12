#!/bin/bash
set -e


HADOOP_USERNAME=salman
CERTS_DIR=/tmp/hopsfs-conf/certs #/srv/hopsworks-data/super_crypto/hdfs
PEMS_DIR=/tmp/hopsfs-conf/certs/pems
LEGACY="-legacy" # set it to "" if you are using older version of openssl. 


TSTORE_FILE=$CERTS_DIR/${HADOOP_USERNAME}__tstore.jks
KSTORE_FILE=$CERTS_DIR/${HADOOP_USERNAME}__kstore.jks
KEY_FILE=$CERTS_DIR/${HADOOP_USERNAME}__passwd #cert.key 



mkdir -p $PEMS_DIR
KEY=$( cat ${KEY_FILE} )

#1. convert to certificates pem
keytool -importkeystore -srckeystore $KSTORE_FILE -destkeystore $PEMS_DIR/${HADOOP_USERNAME}__keystore.p12 -deststoretype PKCS12 -srcstorepass $KEY -keypass $KEY -deststorepass $KEY
openssl pkcs12 -nokeys -in $PEMS_DIR/${HADOOP_USERNAME}__keystore.p12 -out $PEMS_DIR/${HADOOP_USERNAME}_certificate_bundle.pem -passin pass:$KEY $LEGACY

#2. convert to root ca pem
keytool -importkeystore -srckeystore $TSTORE_FILE -destkeystore $PEMS_DIR/${HADOOP_USERNAME}__tstore.p12 -deststoretype PKCS12 -srcstorepass $KEY -keypass $KEY -deststorepass $KEY
openssl pkcs12 -nokeys -in $PEMS_DIR/${HADOOP_USERNAME}__tstore.p12 -out $PEMS_DIR/${HADOOP_USERNAME}_root_ca.pem -passin pass:$KEY $LEGACY

#3 convert to private key pem
openssl pkcs12 -info -in $PEMS_DIR/${HADOOP_USERNAME}__keystore.p12 -nodes -nocerts > $PEMS_DIR/${HADOOP_USERNAME}_private_key.pem -passin pass:$KEY $LEGACY

#4. verify that files have been created
CERTIFICATES_BUNDLE=$PEMS_DIR/${HADOOP_USERNAME}_certificate_bundle.pem
if [ ! -f ${CERTIFICATES_BUNDLE} ]; then
echo "Failed to convert keystore to certificaca pem format for $HADOOP_USERNAME"
exit 4
fi

ROOT_CA=$PEMS_DIR/${HADOOP_USERNAME}_root_ca.pem
if [ ! -f ${ROOT_CA} ]; then
echo "Failed to convert trust store to root ca pem format for $HADOOP_USERNAME"
exit 5
fi

PRIVATE_KEY=$PEMS_DIR/${HADOOP_USERNAME}_private_key.pem
if [ ! -f ${PRIVATE_KEY} ]; then
echo "Failed to covert .jks key to private key pem format  for $HADOOP_USERNAME"
exit 6
fi

chmod 640 $ROOT_CA
chmod 640 $CERTIFICATES_BUNDLE
chmod 640 $PRIVATE_KEY

rm -f $PEMS_DIR/${HADOOP_USERNAME}__keystore.p12
rm -f  $PEMS_DIR/${HADOOP_USERNAME}__tstore.p12

exit 0


