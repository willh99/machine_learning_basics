Apache Hadoop and Spark Fundamentals (Third Edition)

LESSON 3.3 USE HDFS IN PROGRAMS

# Notes for libhdfs HDFS API
# References:
#   http://wiki.apache.org/hadoop/LibHDFS
# Tutorial Steps:

# build the program
export JAVA_LIB=/usr/java/default
gcc hdfs-simple-test.c -I${JAVA_LIB}/include -I${JAVA_LIB}/include/linux -L${JAVA_LIB}/jre/lib/amd64/server -ljvm -lhdfs -o hdfs-simple-test

# Set Library and Class paths, then run the program
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/java/default/jre/lib/amd64/server/
export CLASSPATH=$(hadoop classpath)

./hdfs-simple-test 

