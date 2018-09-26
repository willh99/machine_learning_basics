# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 5.3 Run the Hadoop grep example

* Haddop Grep example
  * Source: http://wiki.apache.org/hadoop/Grep

`mkdir Grep_classes`

1. Compile the WordCount.java program  

`javac -classpath /usr/lib/hadoop/hadoop-core.jar -d Grep_classes Grep.java`

2. Create a java archive for distribution   
`jar -cvf Grep.jar -C Grep_classes/ .`

3.  If needed, create a directory and move the file into HDFS   
```
hadoop dfs -mkdir /user/doug/war-and-peace
cp ../../Lesson-3/data/war-and-peace.txt .
hadoop dfs -put war-and-peace.txt war-and-peace
```

4. make sure output dir is gone   
`hadoop dfs -rmr war-and-peace-output`

5. Run program  
`hadoop jar Grep.jar  org.myorg.Grep /user/doug/war-and-peace /user/doug/war-and-peace-output Kutuzov`


