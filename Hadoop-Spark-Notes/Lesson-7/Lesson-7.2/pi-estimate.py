from pyspark import SparkContext
from numpy import random
sc = SparkContext(appName = "test")
sc.setLogLevel("WARN")
n=5000000
def sample(p):
    x, y = random.random(), random.random()
    return 1 if x*x + y*y < 1 else 0
count = sc.parallelize(xrange(0,n)).map(sample).reduce(lambda a, b: a + b)
print "Pi is roughly %f" % (4.0 * count / n)
