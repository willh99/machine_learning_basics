# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 6.2: Demonstrate a Hive example

* Source:
  * http://gettingstarted.hadooponazure.com/hw/hive.html#_Task_3:_Create_1
  * http://www.johnandcailin.com/blog/cailin/exploring-apache-log-files-using-hive-and-hadoop

## What is Hive?
Apache Hive is a data warehouse infrastructure built on top of Hadoop.
Originally developed by Facebook and donated to Apache, Hive provides data
summarization, ad-hoc queries, and the analysis of large datasets using data
in HDFS. If provides a mechanism to query the data using
an SQL-like language called HiveQL.

1. Make sure metastor is running, start as user hive   

`nohup hive --service metastore > /var/log/hive/hive.out 2> /var/log/hive/hive.log &`

2. start hive  

`hive`

3. simple test   
```
hive> CREATE TABLE pokes (foo INT, bar STRING);
hive> SHOW TABLES;
hive> DROP TABLE pokes;
```

4. create, load and run a query   
```
hive> CREATE TABLE logs(t1 string, t2 string, t3 string, t4 string, t5 string, t6 string, t7 string) ROW FORMAT DELIMITED FIELDS TERMINATED BY ' ';
hive> LOAD DATA LOCAL INPATH 'sample.log' OVERWRITE INTO TABLE logs;
hive> SELECT t4 AS sev, COUNT(*) AS cnt FROM logs WHERE t4 LIKE '[%' GROUP BY t4;
```

5. exit hive  

`hive> exit;`

