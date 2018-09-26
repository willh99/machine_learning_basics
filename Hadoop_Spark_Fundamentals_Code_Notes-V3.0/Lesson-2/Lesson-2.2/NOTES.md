Apache Hadoop and Spark Fundamentals (Third Edition)

LESSON 2.2 INSTALL APACHE HADOOP, PIG, AND HIVE ON LAPTOP OR DESKTOP

OS: Linux
Platform: CentOS 6.9
Hadoop Version: 2.8.1

NOTE 1: The versions and download links may change! The following instructions should work with
        newer versions. Check the Apache website for each project
NOTE 2: This file includes instructions on how to install PIG and HIVE
NOTE 3: There may be some extra files and scripts that were not mentioned in the video.
        The scripts make it easier to start and stop the Hadoop services.


Step 1: Download Hadoop
=======================
# Unless otherwise noted the following steps are done by root
# Download the latest distribution from the Hadoop web site (http://hadoop.apache.org/). 
# For example:

  wget -P /tmp http://mirrors.ibiblio.org/apache/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz

# Next extract the package in /opt:

  mkdir -p /opt/
  tar xvzf /tmp/hadoop-2.8.1.tar.gz -C /opt


Step 2: Set JAVA_HOME and HADOOP_HOME
=====================================

# The Hadoop documentation recommends Java 7, however to be compatible with  Spark (requires version 8)
# Java 8 will be installed. This version of Hadoop seems to work with version 8, so for compatibility
# version 8 (openjdk 1.8) will be installed:

  yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel

# Also note, the install of java-1.8 will set /etc/alternatives/java to /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
# to check which version of java is default run "java -version"

# Add java.sh to profile.d

echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64'> /etc/profile.d/java.sh

# Add hadoop.sh to profile.d

echo 'export HADOOP_HOME=/opt/hadoop-2.8.1;export PATH=$HADOOP_HOME/bin:$PATH' >/etc/profile.d/hadoop.sh

# To make sure JAVA_HOME and HADOOP_HOME are defined for this session, source the new script:

 source /etc/profile.d/java.sh
 source /etc/profile.d/hadoop.sh

# Other Linux distributions may differ, and the steps that follow will need to be adjusted.
# If you want to use Java 7, remove java-1.8.0-openjdk java-1.8.0-openjdk-devel 
# (yum remove  java-1.8.0-openjdk java-1.8.0-openjdk-devel) and install Java 7 rpms
# as root (yum install java-1.7.0-openjdk-devel java-1.7.0-openjdk)

# repeat the step above to set java.sh to the proper path.


Step 3A: Script Install
=======================

The script "hadoop-setup-script.sh" (in the scripts directory) will perform 
Steps 3 through 9.  Run the script as root and skip to Step 10. Steps 3 through 9
perform the same tasks as the script. 
  
  cd scripts
  sh hadoop-setup-script.sh

Step 3: Create Users and Groups
===============================
(Skip to Step 10 if you ran the script in Step 3A)

  groupadd hadoop
  useradd -g hadoop yarn
  useradd -g hadoop hdfs
  useradd -g hadoop mapred


Step 4: Make Data and Log Directories
=====================================

  mkdir -p /var/data/hadoop/hdfs/nn
  mkdir -p /var/data/hadoop/hdfs/snn
  mkdir -p /var/data/hadoop/hdfs/dn
  chown hdfs:hadoop /var/data/hadoop/hdfs -R

#  Create the log directory and set the owner and group as follows:

  cd /opt/hadoop-2.8.1
  mkdir logs
  chmod g+w logs
  chown -R yarn:hadoop . 


Step 5: Configure core-site.xml  
===============================
# Add the following properties to /opt/hadoop-2.8.1/etc/hadoop/core-site.xml

<configuration>
       <property>
               <name>fs.default.name</name>
               <value>hdfs://localhost:9000</value>
       </property>
       <property>
               <name>hadoop.http.staticuser.user</name>
               <value>hdfs</value>
       </property>
</configuration>

Step 6: Configure hdfs-site.xml
===============================
# Add the following properties to /opt/hadoop-2.8.1/etc/hadoop/hdfs-site.xml

<configuration>
 <property>
   <name>dfs.replication</name>
   <value>1</value>
 </property>
 <property>
   <name>dfs.namenode.name.dir</name>
   <value>file:/var/data/hadoop/hdfs/nn</value>
 </property>
 <property>
   <name>fs.checkpoint.dir</name>
   <value>file:/var/data/hadoop/hdfs/snn</value>
 </property>
 <property>
   <name>fs.checkpoint.edits.dir</name>
   <value>file:/var/data/hadoop/hdfs/snn</value>
 </property>
 <property>
   <name>dfs.datanode.data.dir</name>
   <value>file:/var/data/hadoop/hdfs/dn</value>
 </property>
</configuration>


Step 7: Configure mapred-site.xml
=================================
# copy the template file
 
  cp mapred-site.xml.template mapred-site.xml

# Add the following properties to /opt/hadoop-2.8.1/etc/hadoop/mapred-site.xml

<configuration>
<property>
   <name>mapreduce.framework.name</name>
   <value>yarn</value>
</property>
<property>
   <name>mapreduce.jobhistory.intermediate-done-dir</name>
   <value>/mr-history/tmp </value>
</property>
<property>
   <name> mapreduce.jobhistory.done-dir</name>
   <value>/mr-history/done</value>
</property>

</configuration>

Step 8: Configure yarn-site.xml
===============================
# Add the following properties to /opt/hadoop-2.8.1/etc/hadoop/yarn-site.xml

<configuration>
<property>
   <name>yarn.nodemanager.aux-services</name>
   <value>mapreduce_shuffle</value>
 </property>
 <property>
   <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
   <value>org.apache.hadoop.mapred.ShuffleHandler</value>
 </property>
</configuration>


Step 9: Modify Java Heap Sizes
==============================
# Edit /opt/hadoop-2.8.1/etc/hadoop/hadoop-env.sh file to reflect the following 
# (Don't forget to remove the "#" at the beginning of the line.):

HADOOP_HEAPSIZE=500
HADOOP_NAMENODE_INIT_HEAPSIZE="500"

# Next, in the same directory, edit the mapred-env.sh to reflect the following:

HADOOP_JOB_HISTORYSERVER_HEAPSIZE=250

# Edit yarn-env.sh to reflect the following:

JAVA_HEAP_MAX=-Xmx500m 

#The following will need to added to yarn-env.sh

YARN_HEAPSIZE=500

# Finally, edit hadoop-env.sh and add the following to the end:

export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib "

Step 10: Format HDFS
====================
# As user "hdfs" 

 su - hdfs

 cd /opt/hadoop-2.8.1/bin
 ./hdfs namenode -format

# If the command worked, you should see the following near the end of a long list of messages:

INFO common.Storage: Storage directory /var/data/hadoop/hdfs/nn has been successfully formatted.


Step 11: Start the HDFS Services
================================
# As user hdfs
  cd /opt/hadoop-2.8.1/sbin
  ./hadoop-daemon.sh start namenode
  ./hadoop-daemon.sh start secondarynamenode 
  ./hadoop-daemon.sh start datanode

# If the daemon started, you should see responses above that will point to the log file.
# (Note that the actual log file is appended with ".log" not ".out.")
# Issue a jps command to see that all the services are running. The actual PID 
# values will be different than shown in this listing:

$ jps
15140 SecondaryNameNode
15015 NameNode
15335 Jps
15214 DataNode

# All Hadoop services can be stopped using the hadoop-daemon.sh script.  
# For example, to stop the datanode service enter the following

   ./hadoop-daemon.sh stop datanode

# The same can be done for the Namenode and SecondaryNameNode

# create /mr-history for job history server directory in hdfs
# (Also a good test to make sure HDFS is working)

 hdfs dfs -mkdir -p /mr-history/tmp
 hdfs dfs -mkdir -p /mr-history/done
 hdfs dfs -chown -R yarn:hadoop  /mr-history
 hdfs dfs -chmod go+rwx /tmp


# There are two convenience scripts in the scripts directory to start and stop HDFS services (run as root)
# You can add them to /etc/rc.local file

  start-hdfs.sh   
  stop-hdfs.sh

Step 12: Start YARN Services
============================
# as user "yarn"

  su - yarn
  cd /opt/hadoop-2.8.1/sbin
  ./yarn-daemon.sh start resourcemanager
  ./yarn-daemon.sh start nodemanager
  ./mr-jobhistory-daemon.sh start historyserver 

  jps
  23090 Jps
  20546 JobHistoryServer
  19987 ResourceManager
  20080 NodeManager

# Similar to HDFS, the services can be stopped by issuing a stop argument to the daemon script:
  
  ./yarn-daemon.sh stop nodemanager

# There are two convenience scripts in the scripts directory to start and stop YARN services (run as root)
# You can add them to /etc/rc.local file

  start-yarn.sh      
  stop-yarn.sh

Step 13: Verify the Running Services Using the Web Interface
============================================================
# As user "hdfs" Do the following
# To see the HDFS web interface (other browsers can be used):

 firefox  http://localhost:50070

# To see the ResourceManager (YARN) web interface:

 firefox http://localhost:8088

# Run a Sample MapReduce Examples

 export YARN_EXAMPLES=/opt/hadoop-2.8.1/share/hadoop/mapreduce/

# To test your installation, run the sample "pi" application
 
 yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples-2.8.1.jar pi 8 100000

 
If these tests worked, the Hadoop installation should be working correctly. 

------------------
Install Apache Pig
------------------
OS: Linux
Platform: CentOS 6.9
Pig Version: 0.17

# As root, get sources
  wget -P /tmp http://mirrors.ibiblio.org/apache/pig/pig-0.17.0/pig-0.17.0.tar.gz

# Next extract the package in /opt:

  mkdir -p /opt/
  tar xvzf /tmp/pig-0.17.0.tar.gz -C /opt

# set environment
  echo 'export PATH=$PATH:/opt/pig-0.17.0/bin; export PIG_HOME=/opt/pig-0.17.0; export PIG_CLASSPATH=/opt/hadoop-2.8.1/etc/hadoop' >/etc/profile.d/pig.sh

# Create a Pig user and change ownership (do as root)

  useradd -g hadoop pig
  chown -R pig:hadoop /opt/pig-0.17.0

# Pig is ready for use by users (they must re-login or "source /etc/profile.d/pig.sh")

-------------------
Install Apache Hive 
-------------------
OS: Linux
Platform: CentOS 6.9
Hive Version:  2.3.2

Step 1: Install and Configure Hive
=================================

# As root, get sources, extract, create /etc/profile.d/hive.sh

  wget -P /tmp http://mirrors.ibiblio.org/apache/hive/hive-2.3.2/apache-hive-2.3.2-bin.tar.gz

  tar xvzf /tmp/apache-hive-2.3.2-bin.tar.gz -C /opt

  echo 'export PATH=$PATH:/opt/apache-hive-2.3.2-bin/bin; export HIVE_HOME=/opt/apache-hive-2.3.2-bin' >/etc/profile.d/hive.sh

# make needed directories in HDFS

  su - hdfs -c "hdfs dfs -mkdir -p /user/hive/warehouse"
  su - hdfs -c "hdfs dfs -chmod g+w /user/hive/warehouse"

# Copy hive-site.xml file in files directory

  cp files/hive-site.xml /opt/apache-hive-2.3.2-bin/conf

Or, create conf/hive-site.xml and add the following:

<configuration>

<property>
  <name>javax.jdo.option.ConnectionURL</name>
  <value>jdbc:derby://localhost:1527/metastore_db;create=true</value>
  <description>JDBC connect string for a JDBC metastore</description>
</property>
 
<property>
  <name>javax.jdo.option.ConnectionDriverName</name>
  <value>org.apache.derby.jdbc.ClientDriver</value>
  <description>Driver class name for a JDBC metastore</description>
</property>

</configuration>

# remove the extra log4j-slf4j library (included in Hadoop install)

  mv /opt/apache-hive-2.3.2-bin/lib/log4j-slf4j-impl-2.6.2.jar /opt/apache-hive-2.3.2-bin/lib/log4j-slf4j-impl-2.6.2.jar.extra

# Create a Hive user and change ownership (do as root)

  useradd -g hadoop hive
  chown -R hive:hadoop /opt/apache-hive-2.3.2-bin



Step 2: Install Apache Derby
============================

# Hive needs a "metastore" database for metadata. The default is Apache Derby
# install Apache Derby version 10.13.1.1 (Note version 10.13+ will not work with Java 1.7)

  wget -P /tmp http://mirrors.gigenet.com/apache//db/derby/db-derby-10.13.1.1/db-derby-10.13.1.1-bin.tar.gz

  tar xvzf /tmp/db-derby-10.13.1.1-bin.tar.gz -C /opt

# set the Derby environment defines. Note, derby database will be in $DERBY_HOME/data, change as needed.

  echo 'export DERBY_HOME=/opt/db-derby-10.13.1.1-bin; export PATH=$DERBY_HOME/bin:$PATH; export DERBY_OPTS="-Dderby.system.home=$DERBY_HOME/data"'>/etc/profile.d/derby.sh

# source these file to make sure $DERBY_HOME and $HIVE_HOME are defined

  source /etc/profile.d/derby.sh
  source /etc/profile.d/hive.sh

# copy these libraries to $HIVE_HOME

  cp $DERBY_HOME/lib/derbyclient.jar $HIVE_HOME/lib
  cp $DERBY_HOME/lib/derbytools.jar $HIVE_HOME/lib

# Start (and Stop) Derby (nohup will leave log file in the directory you run command)

  nohup startNetworkServer -h 0.0.0.0 &

# To stop use "stopNetworkServer"
# Change derby to hive user

  chown -R hive:hadoop /opt/db-derby-10.13.1.1-bin

# configure Hive schema

  schematool -initSchema -dbType derby

# There are two convenience scripts in the scripts directory to start and stop Derby (run as root)
# You can add them to /etc/rc.local file
  
  start-derby.sh  
  stop-derby.sh

Step 3: Start/Test Hive
=======================

# Make sure all Hadoop services are running (see above, Steps 11 and 12).
# As user hdfs

  su - hdfs

# Enter "hive" at prompt. Output as follows. Ignore "which: no hbase" warning 

$ hive
which: no hbase in (/usr/lib64/qt-3.3/bin:/opt/hadoop-2.8.1/bin:/opt/db-derby-10.13.1.1-bin/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/bps/bin:/opt/apache-hive-2.3.2-bin/bin:/opt/pig-0.17.0/bin:/opt/userstat/bin:/home/hdfs/bin)

Logging initialized using configuration in jar:file:/opt/apache-hive-2.3.2-bin/lib/hive-common-2.3.2.jar!/hive-log4j2.properties Async: true
Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. tez, spark) or using Hive 1.X releases.

# Make sure hive is working (simple test) and quit.

hive> show tables;
OK
Time taken: 2.867 seconds
hive> quit;

