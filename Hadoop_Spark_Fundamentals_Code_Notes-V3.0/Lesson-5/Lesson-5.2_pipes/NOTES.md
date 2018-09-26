Apache Hadoop and Spark Fundamentals (Third Edition)

LESSON 5.2 Use the Pipes interface 

# Hadoop C++ Pipes example
# Source:
#  http://wiki.apache.org/hadoop/C%2B%2BWordCount
#
## Compile the program
g++ wordcount.cpp -o wordcount -lhadooppipes -lhadooputils -lpthread -lcrypto

# If needed, create a directory and move the file into HDFS
hadoop dfs -mkdir /user/doug/war-and-peace
cp ../../Lesson-3/data/war-and-peace.txt .
hadoop dfs -put war-and-peace.txt war-and-peace

# put  executable into HDFS so tasktrackers can find the program
hadoop dfs -put wordcount bin
hadoop dfs -rmr war-and-peace-output

# Run program
hadoop pipes \
-D hadoop.pipes.java.recordreader=true  \
-D hadoop.pipes.java.recordwriter=true \
-input war-and-peace   \
-output war-and-peace-output  \
-program bin/wordcount

# Single line version 
hadoop pipes -D hadoop.pipes.java.recordreader=true   -D hadoop.pipes.java.recordwriter=true -input war-and-peace   -output war-and-peace-output  -program bin/wordcount
