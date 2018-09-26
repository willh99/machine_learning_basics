# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 2.3 INSTALL APACHE SPARK ON LAPTOP OR DESKTOP

OS: Linux  
Platform: CentOS 6.9  
Hadoop Version: 2.8.1  
Spark Version: 1.6.3  

*NOTE 1: the versions and download links may change! Check the Apache website*
*for each project and confirm the version of Java*
*(For these example java-1.8.0-openjdk, java-1.8.0-openjdk-devel)*  
*NOTE 2: The version used below may be different than that used in the video.*
*The same the lessons will work with all versions.*
*NOTE 3: There is also instructions on how to install the Zeppelin Web GUI for Spark.*


#### Step 1: Download Spark

_*Unless otherwise noted the following steps are done by root*_  

* Note Spark 1.6.3 is used because CentOS 6.x only supports Python 2.6.6 
  * For example:
`wget -P /tmp http://mirrors.ibiblio.org/apache/spark/spark-1.6.3/spark-1.6.3-bin-hadoop2.6.tgz`

* Next extract the package in /opt:
```
  mkdir -p /opt/
  tar xvzf /tmp/spark-1.6.3-bin-hadoop2.6.tgz -C /opt
```

#### Step2: Set Spark Path and JAVA_HOME 

**Spark runs on Java 8, however, the Hadoop version we installed does not**
**support Java 8 Some changes are needed.**
* Install Java 1.8 (as root):  
`yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel`

* now set `JAVA_HOME` to the new path
  * Also note, the install of java-1.8 will set `/etc/alternatives/java` to 
    `/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java`

* to check which version of java is default run `java -version`
* Set spark profile and path:  

`echo 'export PATH=$PATH:/opt/spark-1.6.3-bin-hadoop2.6/bin; export SPARK_HOME=i/opt/spark-1.6.3-bin-hadoop2.6' >/etc/profile.d/spark.sh`

* Create a Spark user and change ownership (do as root):
```
  useradd -g hadoop spark
  chown -R spark:hadoop /opt/spark-1.6.3-bin-hadoop2.6
```

* Create `/tmp/hive` for Spark use
```
  mkdir /tmp/hive
  chmod ugo+rwx /tmp/hive
```

* To turn off all the INFO messages. In `/opt/spark-1.6.3-bin-hadoop2.6/conf/log4j.properties`

Change:
  `# Set everything to be logged to the console`
  `log4j.rootCategory=INFO, console`

To:
  `# Set everything to be logged to the console`
  `log4j.rootCategory=WARN, console`
  `#log4j.rootCategory=INFO, console`

## Test Spark Install

_*If you have not logged out run `. /etc/profile.d/spark.sh` before running*_
_*the tests. This file will be used automatic on all subsequent logins.*_

* Run the pi example: `run-example SparkPi 10`
* Start the Spark shell (in Scala) Use ":q" to quit. Starts a local version with one thread.  
  `spark-shell`

* Start a Spark shell in Python (Python must be installed) Starts a local master with two threads
using the `--master local[2]` option. Use `ctrl-D` or `quit()` to quit.  
`pyspark --master local[2]`

* also run the pispark pi example:  
`spark-submit $SPARK_HOME/examples/src/main/python/pi.py 10`

* Finally, start the R front-end (Still experimental and R must be installed)
Use `q()` to quit.  

`sparkR --master local`

## Connecting to HDFS

* first start HDFS (if not started)
based on install from Lesson 2.2, start HDFS and copy a script file to /user/hdfs

_*NOTE: HDFS was started using Java 8. Change the /etc/profile.d/java.sh to*_
_*reflect java-1.8, change to `export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64`*_

* If HDFS is not running, as root run the `hdfs-start.sh` script
(see `~/Install-Hadoop-Spark/Hadoop-Pig-Hive/scripts`)

* Start a Spark shell and enter:
```
  val textFile = sc.textFile("hdfs://localhost:9000/user/hdfs/distribute-exclude.sh")
  textFile.count
```
  * The results should look like:
```
   scala> val textFile = sc.textFile("hdfs://localhost:9000/user/hdfs/distribute-exclude.sh")
   textFile: org.apache.spark.rdd.RDD[String] = hdfs://localhost:9000/user/hdfs/distribute-exclude.sh MapPartitionsRDD[1]i
    at textFile at <console>:24

   scala> textFile.count
   res0: Long = 81   
```

*The HDFS URL comes from the ~/hadoop-2.8.1/etc/hadoop/core-site.xml configuration file.*
* The line "<value>hdfs://localhost:9000</value>" assigns port 9000 for the HDFS interface.*

* don't forget to stop HDFS if you are not using HDFS any further. Use
the `hdfs-stop` script (see `Install-Hadoop-Spark/Hadoop-Pig-Hive/scripts/`)


## Install Zeppelin Web Notebook

* The following may need some additional configuration for you environment.
```
  wget -P /tmp http://mirrors.ibiblio.org/apache/zeppelin/zeppelin-0.7.3/zeppelin-0.7.3-bin-all.tgz
  tar xvzf /tmp/zeppelin-0.7.3-bin-all.tgz -C /opt
```

* See this URL: _*https://zeppelin.apache.org/docs/0.6.0/install/install.html*_

* Once Zeppelin is installed, you can change the port for the Zeppelin notebook
```
  cd /opt/zeppelin-0.7.3-bin-all/conf
  cp zeppelin-site.xml.template zeppelin-site.xml 
```

* Change  port 8080 to 9995
```xml
<property>
  <name>zeppelin.server.port</name>
  <value>8080</value>
  <description>Server port.</description>
</property>
```
* After Change:
```xml
<property>
  <name>zeppelin.server.port</name>
  <value>9995</value>
  <description>Server port.</description>
</property>
```

* Create a Zeppelin user and change ownership (do as root)
```
  useradd -g hadoop zeppelin 
  chown -R zeppelin:hadoop /opt/zeppelin-0.7.3-bin-all
```

### Starting Zeppelin

* use the two scripts to start and stop Zeppelin
```
  start-zeppelin.sh  
  stop-zeppelin.sh
```

### Connect to Zeppelin

* use a web browser to point to "localhost:9995" For example:   

  `firefox http://localhost:9995`
