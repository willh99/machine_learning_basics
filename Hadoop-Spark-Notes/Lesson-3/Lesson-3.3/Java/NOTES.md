# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 3.3 USE HDFS IN PROGRAMS

* Notes for Java Based HDFS API
* References:
  * http://wiki.apache.org/hadoop/HadoopDfsReadWriteExample
  * http://blog.rajeevsharma.in/2009/06/using-hdfs-in-java-0200.html

1. Tutorial Steps:
`mkdir  HDFSClient-classes`

2. Compile program
`javac -classpath /usr/lib/hadoop/hadoop-core.jar -d HDFSClient-classes HDFSClient.java `

3. Create a java archive file
`jar -cvfe HDFSClient.jar org/myorg.HDFSClient -C HDFSClient-classes/ .`

4. Run the program
`hadoop jar ./HDFSClient.jar add ./NOTES.txt /user/doug`

