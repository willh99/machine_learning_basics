#!/bin/bash
# change HADOOP_PATH as needed
HADOOP_PATH=/opt/hadoop-2.8.1
FILES_PATH=../files
# add users
groupadd hadoop
useradd -g hadoop yarn
useradd -g hadoop hdfs
useradd -g hadoop mapred
# These are for data storage (owned by user hdfs)
mkdir -p /var/data/hadoop/hdfs/nn
mkdir -p /var/data/hadoop/hdfs/snn
mkdir -p /var/data/hadoop/hdfs/dn
chown hdfs:hadoop /var/data/hadoop/hdfs -R
#  Create the log directory and set the owner and group
mkdir $HADOOP_PATH/logs
chmod g+w $HADOOP_PATH/logs
# copy configuration files
/bin/cp $HADOOP_PATH/etc/hadoop/mapred-site.xml.template  $HADOOP_PATH/etc/hadoop/mapred-site.xml
LIST="core-site.xml hdfs-site.xml mapred-site.xml yarn-env.sh yarn-site.xml"
for I in $LIST; do
  /bin/cp $HADOOP_PATH/etc/hadoop/$I $HADOOP_PATH/etc/hadoop/$I.orig
  /bin/cp $FILES_PATH/$I $HADOOP_PATH/etc/hadoop/$I
done
chown -R yarn:hadoop $HADOOP_PATH
echo "Complete"
