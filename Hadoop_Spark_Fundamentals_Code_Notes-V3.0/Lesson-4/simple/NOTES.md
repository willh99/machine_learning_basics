Apache Hadoop and Spark Fundamentals (Third Edition)

LESSON 4.1 UNDERSTAND THE MAPREDUCE PARADIGM

# Simplified MapReduce using command line

# get a copy of the file
cp ../../Lesson-3/data/war-and-peace.txt .

# grep is the "mapper" and "wc" is the reducer
grep " Kutuzov " war-and-peace.txt|wc -l

# Now use a simple mapper and reducer script
# Note how data flows in one direction
cat war-and-peace.txt |./mapper.sh |./reducer.sh
