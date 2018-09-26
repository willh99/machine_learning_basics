# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 6.1: Demonstrate a Pig example


* Hadoop Pig Examples
* Source: http://pig.apache.org/docs/r0.10.0/start.html


* Copy the data file to this directory  

`cp /etc/passwd .`

* Copy the data file into HDFS  

`hadoop dfs -put passwd passwd`
 
* local interactive pig operation  
```
pig -x local

grunt> A = load 'passwd' using PigStorage(':'); 
grunt> B = foreach A generate $0 as id; 
grunt> dump B; 
```

* processing begins: `grunt> quit`


* local hadoop MapReduce pig operation  

`pig -x mapreduce`

* or just "pig"
```
grunt> A = load 'passwd' using PigStorage(':'); 
grunt> B = foreach A generate $0 as id; 
grunt> dump B; 
```

* processing begins:  `grunt> quit`

#### Pig Script
```pig
A = load 'passwd' using PigStorage(':');  -- load the passwd file
B = foreach A generate $0 as id;  -- extract the user IDs
dump B;
store B into 'id.out'; -- write the results to a file name id.out
```

* Run the script local. Make sure output directory is gone  

`/bin/rm -r id.out/`

* Run the script  

`pig -x local id.pig`

* Run script through Hadoop mapreduce. Make sure output directory is gone  

`hadoop dfs -rmr id.out`

* Run the script  

`pig id.pig`
