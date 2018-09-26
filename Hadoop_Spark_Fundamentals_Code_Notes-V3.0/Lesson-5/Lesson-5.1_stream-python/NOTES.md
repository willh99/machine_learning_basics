Apache Hadoop and Spark Fundamentals (Third Edition)

LESSON 5.1 Use the Streaming Interface

# Python Example of using Hadoop Streams interface
# This method will work with any program that can read and write
# to stdin and stdout
#Source:
#  http://www.michael-noll.com/tutorials/writing-an-hadoop-mapreduce-program-in-python/

# Start on the command line and map the results.
 echo "foo foo quux labs foo bar quux" | ./mapper.py
# Now sort the results (similar to shuffle) 
 echo "foo foo quux labs foo bar quux" | ./mapper.py|sort -k1,1
# Now run the full program with the reduce step
 echo "foo foo quux labs foo bar quux" | ./mapper.py|sort -k1,1|./reducer.py 

# If needed, create a directory and move the file into HDFS
hadoop dfs -mkdir /user/doug/war-and-peace
cp ../../Lesson-3/data/war-and-peace.txt .
hadoop dfs -put war-and-peace.txt war-and-peace

# make sure output directory is removed from any previous runs
hadoop dfs -rmr war-and-peace-output

# run the following (using the run.sh script may be easier)
hadoop jar /usr/lib/hadoop/contrib/streaming/hadoop-streaming-1.1.2.21.jar \ 
-file ./mapper.py \
-mapper ./mapper.py \
-file ./reducer.py -reducer ./reducer.py \
-input /user/doug/war-and-peace/war-and-peace.txt \
-output /user/doug/war-and-peace-output

