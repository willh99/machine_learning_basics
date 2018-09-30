# Hadoop MapReduce

## What is MapReduce?
You may not know it, but MapReduce programs are actually ubiquitous amoung
programmers of all experience levels. One example is grep-ing a wordcount:

`grep something | wc -l`

* Map (`grep something`)
* Reduce (`wc -l`)
* MapReduce is a simple algorithm!
  * It is made up of distinct steps and data only flows one way
* One of the most popular Hadoop algorithms, but not the only one.
  It may not be ideal for some applications.
* Basis of many tools built on top of or side-by-side with Hadoop including
  Pig Query and HiveQL

## MapReduce Design Principles
* Based on simple [key, value] pairs
* Moving computation is cheaper than moving data (data locality is percious!)
* Hardware will fail. Let software manage it
* Hide execution from user
* Optimised for big blocks and streaming data access
* Simple and familiar file system coherency
  * Despite it's parallel nature, HDFS looks to the users like any other FS

## Hadoop MapReduce - A High Level View
* Data is stored in a distributed, redundant, parallel file system (HDFS)
* Queries are applied (mapped) to each distributed data set  
<img src="https://image.slidesharecdn.com/module3-bigdataandhadoop-160425063358/95/hadoop-mapreduce-framework-29-638.jpg?cb=1461743943" alt="MapReduce Flow Diagram" width="75%">

#### The Map Step
- Step 1: Files Loaded into HDFS (performed all at once) 
- Step 2: User Query is mapped to all nodes

#### The Reduce Step
- Step 3: Reduce the Output list. For instance, collect and sum all occurences of
  a word in a text to one number.

## Native MapReduce Program
* Natively, MapReduce uses Java
* Other languages can use Standard Interface (stdin, stdout, and text only)
* C++ pipes interface supported
* HW faults are handled automatically by the master node which restarts the
  task. This is transparent to the user
* Computation is moved to the node/server that holds the data slice
* Parallel SIMD operations (no need to manage side-jobs or manage program state)
