INSTALL APACHE SPARK ON LAPTOP OR DESKTOP
=========================================
##### OS: Linux 
##### Platform: CentOS 6.9
##### Hadoop Version: 2.8.1 
##### Spark Version: 2.2.0

Step 1: Download Spark
----------------------
*Unless otherwise noted the following steps are done by root.*
*Download the latest distribution from the Hadoop web site (http://hadoop.apache.org/).*
*For Example:*

`wget -P /tmp https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz`

*Next extract the package in /opt:*

    mkdir -p /opt/
    tar xvzf /tmp/spark-2.2.0-bin-hadoop2.7.tgz -C /opt

Step 2: Set JAVA_HOME
---------------------
*Spark runs on Java 8, however, the Hadoop version we installed does not suport Java 8.*
*Some changes are needed. Install Java 1.8 (as root)*

`yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel`

*Now set JAVA_HOME to the new path.*
*Also note, the install of java-1.8 will set /etc/alternatives/java to /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java to check which version of java is default run "java -version"*

`export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64`

Test Spark Install
------------------
*Use `spark -h` for options. Run the pi example*

    cd /opt/spark-2.2.0-bin-hadoop2.7
    ./bin/run-example SparkPi 10

*Start the Spark shell (in Scala). Use ":q" to quit. Starts a local version with one thread.*

`./bin/spark-shell`

*Start a Spark shell in Python (Python must be installed) Starts a local master with two threads*
*using the "--master local[2]" option. Use ctrl-D or "quit()" to quit.*

`./bin/pyspark --master local[2]`

*also run the pispark pi example*

`./bin/spark-submit examples/src/main/python/pi.py 10`

*Finally, start the R fronted (Still experimental and R must be installed) Use "q()" to quit.*

`./bin/sparkR --master local`

Connecting to HDFS
------------------
*first start HDFS (if not started).*
*Based on the install from hadoop_install.md, start HDFS and copy a script file to /user/hdfs*
*NOTE: HDFS was started using Java 8. Change the /etc/porfile.d/java.sh to refect java-1.8,*
*change to `export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64`*
*change user to HDFS*

    su -hdfs
    cd /opt/hadoop-2.8.1/sbin
    ./hadoop-daemon.sh start namenode
    ./hadoop-daemon.sh start datanode
    ./hadoop-daemon.sh start secondarynamenode
    hdfs dfs -put distribute-exclude.sh
    exit

*Start a Spark shell and enter*

    val textFile = sc.textFile("hdfs://localhost:9000/user/hdfs/distribute-exclude.sh")
    textFile.count
