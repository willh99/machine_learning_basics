# Apache Hadoop and Spark Fundamentals (Third Edition)

# Lesson 8.2 USE SPARK TO IMPORT DATA INTO HDFS

Example commands to enter data (CSV/JSON) into Spark using PySpark 

* Start PiSpark  
`pyspark `

* Use `quit()` or `Ctrl-D` to exit

* Import some functions:
```
from pyspark.sql import SQLContext
from pyspark.sql.types import *
from pyspark.sql import Row
```

* Create the SQL context

`sqlContext = SQLContext(sc)`

* read in CSV data

`csv_data = sc.textFile("file:////home/deadline/Hadoop_Fundamentals_Code_Notes-V3/Lesson-8/Lesson-8.2/names.csv")`

* confirm RDD
```
type(csv_data)

<class 'pyspark.rdd.RDD'>
```

* peak at the RDD data
```python
csv_data.take(5)

[u'EmployeeID,FirstName,Title,State,Laptop', u'10,Andrew,Manager,DE,PC', u'11,Arun,Manager,NJ,PC', u'12,Harish,Sales,NJ,MAC', u'13,Robert,Manager,PA,MAC']
```

* Split on comma, and see difference
```python
csv_data  = csv_data.map(lambda p: p.split(","))
csv_data.take(5)

[[u'EmployeeID', u'FirstName', u'Title', u'State', u'Laptop'], [u'10', u'Andrew', u'Manager', u'DE', u'PC'], [u'11', u'Arun', u'Manager', u'NJ', u'PC'], [u'12', u'Harish', u'Sales', u'NJ', u'MAC'], [u'13', u'Robert', u'Manager', u'PA', u'MAC']]
```

* remove the header
```python
header=csv_data.first()
csv_data = csv_data.filter(lambda p:p != header)
```

* Place RRD into Spark DataFrame

`df_csv = csv_data.map(lambda p: Row(EmployeeID = int(p[0]), FirstName = p[1], Title=p[2], State=p[3], Laptop=p[4])).toDF()`

* show the DataFrame format  
```
df_csv

DataFrame[EmployeeID: bigint, FirstName: string, Laptop: string, State: string, Title: string]
```

* show the first 5 rows of the DataFrame
```
df_csv.show(5)

+----------+---------+------+-----+--------+
|EmployeeID|FirstName|Laptop|State|   Title|
+----------+---------+------+-----+--------+
|        10|   Andrew|    PC|   DE| Manager|
|        11|     Arun|    PC|   NJ| Manager|
|        12|   Harish|   MAC|   NJ|   Sales|
|        13|   Robert|   MAC|   PA| Manager|
|        14|    Laura|   MAC|   PA|Engineer|
+----------+---------+------+-----+--------+
only showing top 5 rows
```

* print the DataFrame schema
```
df_csv.printSchema()
root
 |-- EmployeeID: long (nullable = true)
 |-- FirstName: string (nullable = true)
 |-- Laptop: string (nullable = true)
 |-- State: string (nullable = true)
 |-- Title: string (nullable = true)
```

* Create and Write a Hive External and Internal Table in pySpark
Similar to using Hive, just call Hive commands
```python
from pyspark.sql import HiveContext
sqlContext = HiveContext(sc)

sqlContext.sql("CREATE TABLE IF NOT EXISTS MoreNames_text(EmployeeID INT, FirstName STRING, Title STRING, State STRING, Preference STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ")

sqlContext.sql("CREATE TABLE IF NOT EXISTS MoreNames(EmployeeID INT, FirstName STRING, Title STRING, State STRING, Preference STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS ORC")

sqlContext.sql("LOAD DATA LOCAL INPATH 'MoreNames.txt' INTO TABLE MoreNames_text")

sqlContext.sql("INSERT OVERWRITE TABLE MoreNames SELECT * FROM MoreNames_text")

result = sqlContext.sql("FROM MoreNames SELECT EmployeeID, FirstName, State")

result.show(5)
```

* Read a Hive table from Spark. Only read EmplyeeID and Laptop
```
sqlContext = HiveContext(sc)
df_hive = sqlContext.sql("SELECT EmployeeID, Laptop  FROM names")

df_hive.show(5) 

+----------+------+
|EmployeeID|Laptop|
+----------+------+
|        10|    PC|
|        11|    PC|
|        12|   MAC|
|        13|   MAC|
|        14|   MAC|
+----------+------+
only showing top 5 rows

df_hive.printSchema()
root
 |-- EmployeeID: integer (nullable = true)
 |-- Laptop: string (nullable = true)
```

* Read from JSON
  * Please note Spark expects each line to be a separate JSON object, 
    so it will fail if you’ll try to load a pretty formatted JSON file.
```
from pyspark.sql import SQLContext
sqlContext = SQLContext(sc)
df_json = sqlContext.read.json("file:////home/deadline/Hadoop_Fundamentals_Code_Notes-V3/Lesson-8/Lesson-8.2/names.json")
df_json.show()

+----------+---------+------+-----+--------+
|EmployeeID|FirstName|Laptop|State|   Title|
+----------+---------+------+-----+--------+
|        10|   Andrew|    PC|   DE| Manager|
|        11|     Arun|    PC|   NJ| Manager|
|        12|   Harish|   MAC|   NJ|   Sales|
|        13|   Robert|   MAC|   PA| Manager|
|        14|    Laura|   MAC|   PA|Engineer|
|        15|     Anju|    PC|   PA|     CEO|
|        16|  Aarathi|    PC|   NJ| Manager|
|        17| Parvathy|   MAC|   DE|Engineer|
|        18|   Gopika|   MAC|   DE|   Admin|
|        19|   Steven|   MAC|   PA|Engineer|
|        20|  Michael|    PC|   PA|     CFO|
|        21|    Gokul|    PC|   PA|   Admin|
|        23|    Janet|    PC|   DE|   Sales|
|        22|     Anne|    PC|   PA|   Admin|
|        24|     Hari|    PC|   NJ|   Admin|
|        25|   Sanker|   MAC|   NJ|   Admin|
|        26| Margaret|    PC|   PA|    Tech|
|        27|   Nirmal|   MAC|   PA|    Tech|
|        28|    jinju|   MAC|   PA|Engineer|
|        29|    Nancy|    PC|   NJ|   Admin|
+----------+---------+------+-----+--------+

df_json

DataFrame[EmployeeID: bigint, FirstName: string, Laptop: string, State: string, Title: string]

df_json.printSchema()

root
 |-- EmployeeID: long (nullable = true)
 |-- FirstName: string (nullable = true)
 |-- Laptop: string (nullable = true)
 |-- State: string (nullable = true)
 |-- Title: string (nullable = true)
```
