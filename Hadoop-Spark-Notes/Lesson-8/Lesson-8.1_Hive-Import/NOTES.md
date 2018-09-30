# Apache Hadoop and Spark Fundamentals (Third Edition)

## Lesson 8.1 IMPORT DATA INTO HIVE TABLES

Example commands for loading CSV data into a HIVE table

Assumes path is for user "deadline," change all references from
/user/deadline to your path in HDFS

* create the names directly in HDFS  
`hdfs dfs -mkdir names`

* move names to HDFS:  
`hdfs dfs -put names.csv names`

* start HIVE: `hive`

* HIVE commands to create external HIVE table
```
CREATE EXTERNAL TABLE IF NOT EXISTS Names_text(
EmployeeID INT, FirstName STRING, Title STRING, State STRING, Laptop STRING)
COMMENT 'Employee Names'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
location '/user/deadline/names';
```

* check to see if names are there:

`Select * from Names_text limit 5;`

* now create HIVE table
```
CREATE TABLE IF NOT EXISTS Names(
EmployeeID INT, FirstName STRING, Title STRING, State STRING, Laptop STRING)
COMMENT 'Employee Names'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS ORC;
```

* copy data from external table to internal table

`INSERT OVERWRITE TABLE Names SELECT * FROM Names_text;`

* check to see if names are there:

`Select * from Names limit 5;`

* create partitioned table
```
CREATE TABLE IF NOT EXISTS Names_part(
EmployeeID INT, FirstName STRING, Title STRING, Laptop STRING)
COMMENT 'Employee names partitioned by state'
PARTITIONED BY (State STRING) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS ORC;
```

* Turn off dynamic partition strict mode (requires at least one static partition column)

`hive> SET hive.exec.dynamic.partition.mode = nonstrict;`


* create partitioned (by State) table 
```
INSERT INTO TABLE Names_part PARTITION(state)
SELECT EmployeeID, FirstName, Title, Laptop, State FROM Names_text; 
```

* check to see if names are there:

`Select * FROM Names_part WHERE State='DE';`

* Create table using Parquet format
```
CREATE TABLE IF NOT EXISTS Names_Parquet(
EmployeeID INT, FirstName STRING, Title STRING, State STRING, Laptop STRING)
COMMENT 'Employee Names'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS PARQUET;
```

* add data

`INSERT OVERWRITE TABLE Names_Parquet SELECT * FROM Names_text;`

### [Parquet Format in Hive](https://acadgild.com/blog/parquet-file-format-hadoop)
* save external table in Parquet format
```
CREATE EXTERNAL TABLE IF NOT EXISTS Names_Parquet_Ext(
EmployeeID INT, FirstName STRING, Title STRING, State STRING, Laptop STRING)
COMMENT 'Employee Names'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS PARQUET
LOCATION '/user/deadline/names-parquet';
```

* add data

`INSERT OVERWRITE TABLE Names_Parquet_Ext SELECT * FROM Names_text;`
