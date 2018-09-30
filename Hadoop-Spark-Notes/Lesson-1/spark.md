# Apache Spark

## The History of Spark
Spark was created in 2009 in UC Berkley's AMPLab by Matei Zaharia and
became an open-source project in 2010 under the BSD License. In 2013
it was donated to the Apache Software Foundation. It is similar to
Hadoop MapReduce, but it is an independent project.

## What is Spark and Why is it Use?
**Speed** - Spark keeps intermediate results and processing data in 
memeory. Many analytics jobs consist of stages; traditional MapReduce
jobs write results to disk between stages.

**Supports Multiples Languages** - Spark provides built-in APIs in Java,
Scala, and Python. Therefore, you can write native Spark applications
in different languages. Spark includes 80 high-level operators for querying.

**Advance Analytics** - Spark provides more functionality than just MapReduce.
It also supports SQL queries, streaming data, machine learning, and graph
algorithms. It is higher level than native MapReduce, so it can be used in
place of Hive and/or Pig.

<img scr="https://dzone.com/storage/temp/8571839-picture1.png" alt="Spark Core" width="75%">

## Spark Resilient Distributed Data Sets (RDDs)
* RDDs are the fudamental data structures of Spark
* It is a distributed, immutable collection of objects
* Each dataset in a RDD is divided into logical partitions, which may be
  computed on different nodes in the cluster
* RDDs can contain any type of Python, Java, or Scala objects, including
  user defined classes


## Spark Operations
* _*RDD Transformations*_ return a pointer to a new RDD. The original RDD
  cannont be changed (immutable). Spark is lazy, so nothing will be changed
  unless a transformation action is called.
  * An RDD Transformation is not a set of data but is a step within a program
    (might be the only one) that tells Spark how to get data and what to do
    with it. 
* _*RDD Actions*_ return values (i.e. collect, count, take, save-as)

#### RDD vs Dataframe
* A **RDD** is a blind structure partitioned accros the nodes of a cluster
  and provides many transformation methods, such as `map()`, `filter()`, 
  and `reduce()`. Each of these methods results in a new RDD representing
  the transformed data
* The **Dataframe** introduces the conept of a schema to describe data
  (named coloumns), enabling Spark to manage and optimise data accros nodes.
  They are conceptually equivalent to a table in a structured query language
  or a datafrom in R/Python.

### How Big is Spark's Speed Advantage?
* In reality, Hadoop has been significantly optimised using Tez (keeps tuples
  in memory). Pig and HiveQL have become more interactive and fast like Spark
  and less like batch jobs which storge tuples on disk.
* Spark uses in-memory computing, but if memory runs out then intermediate results
  will spill onto disk. In this case Hadoop MapReduce is preferable.

#### PySpark Example:

```python
    from pyspark import SparkContext
    from numpy import random

    n=5000000

    def sample(p):
        x, y = random.random(), random.random()
        return 1 if x*x + y*y < 1 else 0

    count = sc.parallelize(xrange(0,n)).map(sample).reduce(lambda a, b: a+b)
    print "Pi is roughly %f" % (4.0 * count / n)
```
