# Apache Hadoop and Spark Fundamentals (Third Edition)

## Lesson 7.1 LEARN SPARK LANGUAGE BASICS

* Using Spark version 1.6.3
* Using Python version 2.6.6
* From Hortonworks HDP 2.6


### Background

Resilient Distributed Datasets (RDDs) are the fundamental unit of data in Spark. 
RDDs can be created from a file, from data in memory, or from another RDD. RDDs 
are immutable.

Spark Data Frames are covered as part of Lesson 8.2: Using Spark to Import 
Data into HDFS

* Spark has two basic classes of operations
  1. transformations - lazy operations that return another RDD.
   (map, flatMap, filter, reduceByKey)
2. actions - operations that trigger computation and return values.
   (count, collect, take, saveAsTextFile)


### Starting an Interactive Spark Shell

Start with Scala front end (default) (:q or :quit to exit)
https://spark.apache.org/docs/1.6.2/quick-start.html

`spark-shell`

Start with R front end (q() to exit)
https://spark.apache.org/docs/1.6.2/sparkr.html

`sparkR`

Start with Python front end (quit() or ctrl-D to exit)
https://spark.apache.org/docs/1.6.2/quick-start.html

`pyspark`

### Interactive Example with PySpark

* First quiet down the logging:
  * Valid log levels include: `ALL, DEBUG, ERROR, FATAL, INFO, OFF, TRACE, WARN`

`sc.setLogLevel("WARN")`

RDDs have actions, which return values, and transformations, which return pointers 
to new RDDs. Spark performs its calculations, it will not execute any of 
the transformations until an action occurs. 

* Read a text file from local file systems (TRANSFORMATION):

`text=sc.textFile("file:///home/deadline/Hadoop_Fundamentals_Code_Notes-V3/Lesson-7/Lesson-7.1/war-and-peace.txt")`

* Read a text file from HDFS (TRANSFORMATION)

`text=sc.textFile("War-and-Peace/war-and-peace.txt")`

* Count number f lines (ACTION)
```
text.count()
65336
```

### Mapping and Reducing

* Word count in spark looks like the following:

```python
counts = text.flatMap(lambda line: line.split(" ")). \
         map(lambda word: (word, 1)). \
         reduceByKey(lambda a, b: a + b)
```

* Use two kinds of map functions: map and flatmap
  * map: It returns a new RDD by applying given function to each element of the RDD. 
    Function in map returns only one item.
  * flatMap: Similar to map, it returns a new RDD by applying a function to each 
    element of the RDD, but output is flattened.   
* Consider a simple test file:
```
cat map-text.txt

see spot run
run spot run
see the cat
```

* Read in file:  

`MapText=sc.textFile("file:///home/deadline/Hadoop_Fundamentals_Code_Notes-V3/Lesson-7/Lesson-7.1/map-text.txt")`

* inspect file as read:  
```
MapText.collect()
[u'see spot run', u'run spot run', u'see the cat']
```

* now do map to split on spaces, result is lines broken into words (elements) and 
sentences still exist (lists) 
```
mp=MapText.map(lambda line:line.split(" "))
mp.collect()

[[u'see', u'spot', u'run'], [u'run', u'spot', u'run'], [u'see', u'the', u'cat']]
```

* now do flatMap to split on spaces, result is lines broken on words (elements) and
sentences are gone (flattened to one big list)
```
fm=MapText.flatMap(lambda line:line.split(" "))
fm.collect()

[u'see', u'spot', u'run', u'run', u'spot', u'run', u'see', u'the', u'cat']
```

### What is "lambda"

Anonymous functions (i.e. functions that are not bound to a name) at runtime, 
using a construct called lambda.  lambda variables are anonymous, they do not 
relate to the rest of the code, only operate within the lambda statement
```python
 lambda x, y, z: x + y + z
 (return is x + y + z)
```

* apply operation to each map  
`flatMap(lambda line: line.split(" "))`

### Reducing

* Combine values with the same key (a is the the accumulator)  
`reduceByKey(lambda a, b: a + b)`

### Word Count

* Put it all together and count all words, split on spaces, i.e. spaces define a word
```python
counts = text.flatMap(lambda line: line.split(" ")). \
         map(lambda word: (word, 1)). \
         reduceByKey(lambda a, b: a + b)
```

* look at first 5 elements
```
counts.take(5)

[(u'', 15502), (u'instinctive,', 1), (u'concessions', 1), (u'shouted,', 31), (u'Virgin.', 1)]
```

* Save results locally (also in HDFS if needed) 

`counts.saveAsTextFile("file:///home/deadline/Hadoop_Fundamentals_Code_Notes-V3/Lesson-7/Lesson-7.1/counts-result")`

* Modify for single word search "Kutuzov"
```
counts = text.flatMap(lambda line: line.split(" ")). \
         filter(lambda w: "Kutuzov" in w). \
         map(lambda word: (word, 1)). \
         reduceByKey(lambda a, b: a + b)
```

* Show all results
```
counts.collect()

[(u'Kutuzov?"', 5), (u"Kutuzov's.", 1), (u'Kutuzov--having', 1), (u"Kutuzov's,", 2), (u'(Kutuzov', 1), (u'Kutuzov:', 3), (u'Kutuzov...', 1), (u'Dokhturov--Kutuzov', 1), (u'Kutuzov!"', 1), (u'Kutuzov.', 31), (u'happening--Kutuzov', 1), (u'Kutuzov,', 68), (u'*Kutuzov.', 1), (u'Kutuzov--the', 1), (u'Kutuzov,"', 2), (u'Kutuzov?', 1), (u"Kutuzov's", 76), (u'Kutuzov!', 1), (u'Kutuzov."', 1), (u'Kutuzov', 327), (u'Kutuzov)', 1), (u"Kutuzov's;", 1), (u'Kutuzov;', 2)]
```

* print results using for loop
```
for x in counts.collect(): print x

(u'Kutuzov?"', 5)
(u"Kutuzov's.", 1)
(u'Kutuzov--having', 1)
(u"Kutuzov's,", 2)
(u'(Kutuzov', 1)
(u'Kutuzov:', 3)
(u'Kutuzov...', 1)
(u'Dokhturov--Kutuzov', 1)
(u'Kutuzov!"', 1)
(u'Kutuzov.', 31)
(u'happening--Kutuzov', 1)
(u'Kutuzov,', 68)
(u'*Kutuzov.', 1)
(u'Kutuzov--the', 1)
(u'Kutuzov,"', 2)
(u'Kutuzov?', 1)
(u"Kutuzov's", 76)
(u'Kutuzov!', 1)
(u'Kutuzov."', 1)
(u'Kutuzov', 327)
(u'Kutuzov)', 1)
(u"Kutuzov's;", 1)
(u'Kutuzov;', 2)
```

* add a map to replace "," note how (u'Kutuzov,', 68) is now gone 
and (u'Kutuzov', 395) has increased.
```
counts = text.flatMap(lambda line: line.split(" ")). \
         filter(lambda w: "Kutuzov" in w). \
         map(lambda x: x.replace(',','')). \
         map(lambda word: (word, 1)). \
         reduceByKey(lambda a, b: a + b)

for x in counts.collect(): print x

(u'Kutuzov?"', 5)
(u"Kutuzov's.", 1)
(u'Kutuzov--having', 1)
(u'(Kutuzov', 1)
(u'Kutuzov"', 2)
(u'Kutuzov:', 3)
(u'Kutuzov...', 1)
(u'Kutuzov!"', 1)
(u'Kutuzov.', 31)
(u'happening--Kutuzov', 1)
(u'Dokhturov--Kutuzov', 1)
(u'*Kutuzov.', 1)
(u'Kutuzov--the', 1)
(u'Kutuzov;', 2)
(u"Kutuzov's", 78)
(u'Kutuzov?', 1)
(u'Kutuzov!', 1)
(u'Kutuzov."', 1)
(u'Kutuzov', 395)
(u'Kutuzov)', 1)
(u"Kutuzov's;", 1)
```
