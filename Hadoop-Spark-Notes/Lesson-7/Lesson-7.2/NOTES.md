Apache Hadoop and Spark Fundamentals (Third Edition)

Lesson 7.2 DEMONSTRATE A PYSPARK COMMAND LINE EXAMPLE

#
# Using Spark version 1.6.3
# Using Python version 2.6.6
# From Hortonworks HDP 2.6

A Stand Alone Pi Estimator
===========================

# Needs numpy installed for random function.
# Includes an example of how to uses a Python function
# Also note the use of "sc = SparkContext(appName = "test")"
# to set spark context.
# Uses parallelize() function to break up count function across available executors

cat pi-estimate.py

from pyspark import SparkContext
from numpy import random
sc = SparkContext(appName = "test")
sc.setLogLevel("WARN")

n=5000000
def sample(p):
    x, y = random.random(), random.random()
    return 1 if x*x + y*y < 1 else 0

count = sc.parallelize(xrange(0,n)). \
           map(sample). \
           reduce(lambda a, b: a + b)

print "Pi is roughly %f" % (4.0 * count / n)

# Pick random points in the unit square ((0, 0) to (1,1)) and see how many 
# fall in the unit circle. The fraction should be pi/4

# Run as stand alone:

spark-submit pi-estimate.py 

