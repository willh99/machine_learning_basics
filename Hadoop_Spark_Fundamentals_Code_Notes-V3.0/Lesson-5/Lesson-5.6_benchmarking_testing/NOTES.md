# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 5.6: USING HADOOP VERSION 2 MAPREDUCE FEATURES

OS: Linux  
Platform: RHEL 6.3  
Hadoop Version: Hortonworks HDP 2.6 (Hadoop version 2.7.2)   
Cluster: four nodes, 4-cores per node, GbE, 16 GB/node, two SSD's for HDFS (64G and 128G)
         node names are limulus, n0,n1,n2  

_*Run examples as user (not root or user "hdfs")*_  
_*To make the command lines shorter we will create a*_  
_*environment define called YARN_EXAMPLES.*_  

*The YARN_YARN_EXAMPLES define is simply the path to the Hadoop*
*examples jar file. This path will will vary by installation*
*platform) For example, in the current HDP installation, we*
*will use:*

    export EXAMPLES=/usr/hdp/2.6.2.0-205/hadoop-mapreduce/

*To find the path on your platform, use the top level*
*directory where your Hadoop packages were installed.* 
*For instance, for the Linux Hadoop Minimal (LHM) virtual machine use:*

    find /opt -name hadoop-mapreduce-examples* -print

    /opt/hadoop-2.8.1/share/doc/hadoop/hadoop-mapreduce-examples
    /opt/hadoop-2.8.1/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.1.jar
    /opt/hadoop-2.8.1/share/hadoop/mapreduce/sources/hadoop-mapreduce-examples-2.8.1-test-sources.jar
    /opt/hadoop-2.8.1/share/hadoop/mapreduce/sources/hadoop-mapreduce-examples-2.8.1-sources.jar

Note the path for the `hadoop-mapreduce-examples-*.jar` file. In this example
the Hadoop version is 2.8.1 and it is included in all the hadoop jar file names.
In this case it is the YARN_EXAMPLES path is
`/opt/hadoop-2.8.1/share/hadoop/mapreduce/` and the command is:

    export YARN_EXAMPLES=/opt/hadoop-2.8.1/share/hadoop/mapreduce/

**To see all examples (including the famous wordcount example)**  

`yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples.jar`

**or**  

`hadoop jar $YARN_EXAMPLES/hadoop-mapreduce-examples.jar`

#### Example 1: Run the pi Example

* Simple MapReduce program to run, good for quick tests.  

  `yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples.jar pi 16 100000`


#### Example 2: Run the TestDFSIO Benchmark

 Yarn also includes a HDFS benchmark application called TestDFSIO. 
 There are three steps.  We will write and read ten 1 GByte files.

*Step 1: Run TestDFSIO in write mode and create data

`yarn jar $YARN_EXAMPLES/hadoop-mapreduce-client-jobclient.jar TestDFSIO -write  -nrFiles 16 -fileSize 1000`

Example results are as follows *(Note: You may see large variation in results*
*depending on how/where containers are placed on nodes)* :

```
 fs.TestDFSIO: ----- TestDFSIO ----- : write
 fs.TestDFSIO:            Date & time: Sat Jul 26 15:40:12 EDT 2014
 fs.TestDFSIO:        Number of files: 16
 fs.TestDFSIO: Total MBytes processed: 16000.0
 fs.TestDFSIO:      Throughput mb/sec: 18.063379884168576
 fs.TestDFSIO: Average IO rate mb/sec: 19.955001831054688
 fs.TestDFSIO:  IO rate std deviation: 10.075669895666104
 fs.TestDFSIO:     Test exec time sec: 84.236
 fs.TestDFSIO: 
```

* Step 2: Run TestDFSIO in read mode

`arn jar $YARN_EXAMPLES/hadoop-mapreduce-client-jobclient.jar TestDFSIO -read  -nrFiles 16 -fileSize 1000`

Example results are as follows
```
 fs.TestDFSIO: ----- TestDFSIO ----- : read
 fs.TestDFSIO:            Date & time: Sat Jul 26 15:46:22 EDT 2014
 fs.TestDFSIO:        Number of files: 16
 fs.TestDFSIO: Total MBytes processed: 16000.0
 fs.TestDFSIO:      Throughput mb/sec: 48.9936400131058
 fs.TestDFSIO: Average IO rate mb/sec: 170.90463256835938
 fs.TestDFSIO:  IO rate std deviation: 319.9641049269028
 fs.TestDFSIO:     Test exec time sec: 61.393
 fs.TestDFSIO: 
```

* Step 3: Clean up the TestDFSIO data

`yarn jar $YARN_EXAMPLES/hadoop-mapreduce-client-jobclient.jar TestDFSIO -clean`


* Interpret the results:
  * There is a results file created in your local directory called "TestDFSIO_results.log"
  * All new results are appended to this file. 
```
Total Read Throughput Across The Cluster = (Number of files * Throughput mb/sec) 
 (16 * 49)  = 784 MB/Sec

Total Write Throughput Across The Cluster = (Number of files * Throughput mb/sec) 
 (16 x 18) = 288 MB/Sec
```

#### Example 3: Run the terasort Benchmark

To run the terasort benchmark three separate steps required. In general the
rows are 100 bytes long, thus the total amount of data written is 100 times the
number of rows *(i.e. to write a 100 GBytes of data, use 1000000000 rows)*. You
will also need to specify input and output directories in HDFS. 

1. Run teragen to generate 50 GB of data, 500,000,000 rows of random data to sort

`yarn jar  $YARN_EXAMPLES/hadoop-mapreduce-examples.jar teragen 500000000 /user/hdfs/TeraGen-50GB`

2. Run terasort to sort the database

`yarn jar  $YARN_EXAMPLES/hadoop-mapreduce-examples.jar terasort /user/hdfs/TeraGen-50GB /user/hdfs/TeraSort-50GB`

3. Run teravalidate to validate the sort Teragen 

`yarn jar  $YARN_EXAMPLES/hadoop-mapreduce-examples.jar teravalidate  /user/hdfs/TeraSort-50GB /user/hdfs/TeraValid-50GB`

4. Interpret the results:
  * Measure the time it takes to complete the terasort application. Results are 
usually reported in Database Size in Seconds (or Minutes).

 The perforance can be increased by incresing the number of reducers (default is one)
 add the option `-Dmapred.reduce.tasks=NUMBER_OF_REDUCERS`
 The command below uses 4 reducers.

`yarn jar  $YARN_EXAMPLES/hadoop-mapreduce-examples.jar -Dmapred.reduce.tasks=4 terasort /user/hdfs/TeraGen-50GB /user/hdfs/TeraSort-50GB`


_*Don't for get to delete you files in HDFS before the next run!*_

`hdfs dfs -rm -r -skipTrash Tera*`

#### Hadoop Version 2 Log Management

**Improved over version 1. To manual enable log aggregation, do the following. **

* Create the directories in HDFS, as user hdfs  
```
  hdfs dfs -mkdir -p /yarn/logs
  hdfs dfs -chown -R yarn:hadoop /yarn/logs
  hdfs dfs -chmod -R g+rw /yarn/logs
 ```

* Now add the following properties to `yarn-site.xml` (on all nodes) and
restart yarn (on all nodes)
```xml
<property>
    <name>yarn.nodemanager.remote-app-log-dir</name>
    <value>/yarn/logs</value>
</property>
<property>
    <name>yarn.log-aggregation-enable</name>
    <value>true</value>
</property>
```

_*If using Ambari,  under the YARN Service Configs as*_
_*`yarn.log-aggregation-enable` and is on by default*_

#### Command Line Log Management

Logs can be viewed in YARN jobs browser. If command line
is needed, your can use the `yarn logs` command.
With log aggregation enabled.  Log management is 
easier. Otherwise, you need to hunt the logs on the nodes
```
$ yarn logs

  yarn logs
  Retrieve logs for completed YARN applications.
  usage: yarn logs -applicationId <application ID> [OPTIONS]

  general options are:
   -appOwner <Application Owner>   AppOwner (assumed to be current user if
                                   not specified)
   -containerId <Container ID>     ContainerId (must be specified if node
                                   address is specified)
   -nodeAddress <Node Address>     NodeAddress in the format nodename:port
                                   (must be specified if container id is
                                   specified)
```

###### Simple Example with log aggregation on:
1. Run the pi example above

`[...]`

2. grab all logs and save to file:

`$ yarn logs  -applicationId application_1406403419677_0007 > AppOut`

3. then, to find the container names

`grep -B 1 ===== AppOut`

  * For example:
```
[...]
Container: container_1406403419677_0007_01_000011 on n0_45454
===============================================================
--
Container: container_1406403419677_0007_01_000012 on n0_45454
===============================================================
--
Container: container_1406403419677_0007_01_000010 on n0_45454
===============================================================
--
[...]
```

_*You can zero in on specific container (note:  n0_45454 is  -nodeAddress n0:45454)*_

`yarn logs -applicationId application_1406403419677_0007 -containerId container_1406403419677_0007_01_000012 -nodeAddress n0:45454|more`

