Apache Hadoop and Spark Fundamentals (Third Edition)

LESSON 4.1 UNDERSTAND THE MAPREDUCE PARADIGM

# Basic Hadoop java word count example
# Source: 
  http://hadoop.apache.org/docs/r0.18.3/mapred_tutorial.html

# Tutorial Steps:
mkdir wordcount_classes

#Compile the WordCount.java program
javac -classpath /usr/lib/hadoop/hadoop-core.jar -d wordcount_classes WordCount.java

#Create a java archive for distribution 
jar -cvf wordcount.jar -C wordcount_classes/ .

# Create a directory and move the file into HDFS
hadoop dfs -mkdir /user/doug/war-and-peace
cp ../../Lesson-3/data/war-and-peace.txt .
hadoop dfs -put war-and-peace.txt war-and-peace

# run work count, but first
hadoop jar wordcount.jar  org.myorg.WordCount /user/doug/war-and-peace /user/doug/war-and-peace-output

# check for output form Hadoop job
hadoop dfs -ls war-and-peace-output

# move it back to working directory (example of "hadoop dfs -get")
hadoop dfs -get war-and-peace-output/part-00000 .

# Note: If you run program again it wont work because /war-and-peace-output exists.
# Hadoop will not overwrite files!

