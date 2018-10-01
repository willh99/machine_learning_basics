# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 8.4 APACHE SQOOP 

OS: Linux  
Platform: RHEL 6.3  
Hadoop Version: 2.4  
Hadoop Version: Hortonworks HDP 2.1  
Sqoop Version: 1.4.4  
Reference: http://sqoop.apache.org/docs/1.4.5/SqoopUserGuide.html

## What is Apache Sqoop (Version 2)?
Sqoop is a tool designed to transfer data between Hadoop and relational
databases. You can use Sqoop to import data from a relational database
management system (RDBMS) into the Hadoop Distributed File System (HDFS),
transform the dtaa in Hadoop, and then export the data back into an RDBMS.

You can use Sqoop with any JDBC-compliant database. Sqoop has been
tested on the following databases: Microsoft SQL Server, PostgreSQL,
MySQL, and Oracle.

Sqoop version 2 does not suport "connectors" or data transfer from
RDBMS directly to Hive or HBase or data transfer from HIve or HBase
to you RDBMS. (There are pathways to accomplish these tasks)  
<img src="http://4zy7s42hws72i51dv3513vnm-wpengine.netdna-ssl.com/wp-content/uploads/2018/02/Apache-Sqoop-Export-Architecture-Apache-Sqoop-Tutorial-Edureka.png" alt="Sqoop Process" width="75%">

### Step 1: Download and Load Sample MySQL Data

Assume mysql is installed and working on the host  
Ref: http://dev.mysql.com/doc/world-setup/en/index.html  
Get the database:  

`wget http://downloads.mysql.com/docs/world_innodb.sql.gz`

* Load into MySQL
```
   mysql -u root -p
   mysql> CREATE DATABASE world;
   mysql> USE world;
   mysql> SOURCE world_innodb.sql;
   mysql> SHOW TABLES;
   +-----------------+
   | Tables_in_world |
   +-----------------+
   | City            |
   | Country         |
   | CountryLanguage |
   +-----------------+
   3 rows in set (0.01 sec)
```

* To see table details:
```
   mysql> SHOW CREATE TABLE Country;
   mysql> SHOW CREATE TABLE City;
   mysql> SHOW CREATE TABLE CountryLanguage;
```

### Step 2: Add Sqoop User Permissions for Local Machine and Cluster
```
   mysql> GRANT ALL PRIVILEGES ON world.* To 'sqoop'@'limulus' IDENTIFIED BY 'sqoop';
   mysql> GRANT ALL PRIVILEGES ON world.* To 'sqoop'@'10.0.0.%' IDENTIFIED BY 'sqoop';
   mysql> quit
```

* Login as sqoop to test 
```
   mysql -u sqoop -p
   mysql> USE world;
   mysql> SHOW TABLES;
   +-----------------+
   | Tables_in_world |
   +-----------------+
   | City            |
   | Country         |
   | CountryLanguage |
   +-----------------+
   3 rows in set (0.01 sec)

   mysql> quit
```

### Step 3: Import Data Using Sqoop

* Use Sqoop to List Databases
```
   sqoop list-databases --connect jdbc:mysql://limulus/world --username sqoop --password sqoop

   Warning: /usr/lib/sqoop/../accumulo does not exist! Accumulo imports will fail.
   Please set $ACCUMULO_HOME to the root of your Accumulo installation.
   14/08/18 14:38:55 INFO sqoop.Sqoop: Running Sqoop version: 1.4.4.2.1.2.1-471
   14/08/18 14:38:55 WARN tool.BaseSqoopTool: Setting your password on the command-line is 
   insecure. Consider using -P instead.
   14/08/18 14:38:55 INFO manager.MySQLManager: Preparing to use a MySQL streaming resultset.
   information_schema
   test
   world
```

* List Tables:
```
   sqoop list-tables --connect jdbc:mysql://limulus/world --username sqoop --password sqoop

   ...
   14/08/18 14:39:43 INFO sqoop.Sqoop: Running Sqoop version: 1.4.4.2.1.2.1-471
   14/08/18 14:39:43 WARN tool.BaseSqoopTool: Setting your password on the command-line is
   insecure. Consider using -P instead.
   14/08/18 14:39:43 INFO manager.MySQLManager: Preparing to use a MySQL streaming resultset.
   City
   Country
   CountryLanguage
```

* Make directory for data:

`hdfs dfs -mkdir sqoop-mysql-import`

* Do the import (-m is number of map tasks):
```
  sqoop import --connect jdbc:mysql://limulus/world  --username sqoop --password sqoop --table Country  -m 1 --target-dir /user/hdfs/sqoop-mysql-import/country
   ...
   14/08/18 16:47:15 INFO mapreduce.ImportJobBase: Transferred 30.752 KB in 12.7348 seconds 
   (2.4148 KB/sec)
   14/08/18 16:47:15 INFO mapreduce.ImportJobBase: Retrieved 239 records.

   hdfs dfs -ls sqoop-mysql-import/country
   Found 2 items
   -rw-r--r--   2 hdfs hdfs          0 2014-08-18 16:47 sqoop-mysql-import/world/_SUCCESS
   -rw-r--r--   2 hdfs hdfs      31490 2014-08-18 16:47 sqoop-mysql-import/world/part-m-00000

   hdfs dfs  -cat sqoop-mysql-import/country/part-m-00000

   ABW,Aruba,North America,Caribbean,193.0,null,103000,78.4,828.0,793.0,Aruba,Nonmetropolitan 
   Territory of The Netherlands,Beatrix,129,AW
   ...
   ZWE,Zimbabwe,Africa,Eastern Africa,390757.0,1980,11669000,37.8,5951.0,8670.0,Zimbabwe,
   Republic,Robert G. Mugabe,4068,ZW
```
* Using and Options File:
  * Can use and options file to avoid rewriting same options
  * Example (vi world-options.txt):
```
   import
   --connect
   jdbc:mysql://limulus/world
   --username
   sqoop
   --password
   sqoop

sqoop  --options-file world-options.txt --table City  -m 1 --target-dir /user/hdfs/sqoop-mysql-import/city
```

##### Include a SQL Query in the Import Step

* First use a single mapper "-m 1" The $CONDITIONS is requried by WHERE, leave blank.
```
   sqoop  --options-file world-options.txt -m 1 --target-dir /user/hdfs/sqoop-mysql-import/canada-city --query "SELECT ID,Name from City WHERE CountryCode='CAN' AND \$CONDITIONS"

   hdfs dfs  -cat sqoop-mysql-import/canada-city/part-m-00000

   1810,Montréal
   1811,Calgary
   1812,Toronto
   ...
   1856,Sudbury
   1857,Kelowna
   1858,Barrie
```

#### Using Multiple Mappers

The `$CONDITIONS` variable is needed for more than one mapper.
If you want to import the results of a query in parallel, then each map task will need
to execute a copy of the query, with results partitioned by bounding conditions inferred
by Sqoop. Your query must include the token `$CONDITIONS` which each Sqoop process will
replace with a unique condition expression based on the `--split-by` option.
You may need to select another splitting column with `--split-by` option if your
primary key is not uniformly distributed.

Since -m 1 is one map, we don't need to specify a --split-by option.
Now use multiple mappers, clear resutls from previous import. 
```
   hdfs dfs -rm -r -skipTrash  sqoop-mysql-import/canada-city

   sqoop  --options-file world-options.txt -m 4 --target-dir /user/hdfs/sqoop-mysql-import/canada-city --query "SELECT ID,Name from City WHERE CountryCode='CAN' AND \$CONDITIONS" --split-by ID

   hdfs dfs -ls  sqoop-mysql-import/canada-city
   Found 5 items
   -rw-r--r--   2 hdfs hdfs       0 2014-08-18 21:31 sqoop-mysql-import/canada-city/_SUCCESS
   -rw-r--r--   2 hdfs hdfs     175 2014-08-18 21:31 sqoop-mysql-import/canada-city/part-m-00000
   -rw-r--r--   2 hdfs hdfs     153 2014-08-18 21:31 sqoop-mysql-import/canada-city/part-m-00001
   -rw-r--r--   2 hdfs hdfs     186 2014-08-18 21:31 sqoop-mysql-import/canada-city/part-m-00002
   -rw-r--r--   2 hdfs hdfs     182 2014-08-18 21:31 sqoop-mysql-import/canada-city/part-m-00003
```

### Step 4: Export Data from HDFS to MySQL

* Create table for exported data, also need staging table
```
   mysql> CREATE TABLE `CityExport` (
            `ID` int(11) NOT NULL AUTO_INCREMENT,
            `Name` char(35) NOT NULL DEFAULT '',
            `CountryCode` char(3) NOT NULL DEFAULT '',
            `District` char(20) NOT NULL DEFAULT '',
            `Population` int(11) NOT NULL DEFAULT '0',
            PRIMARY KEY (`ID`));

   mysql> CREATE TABLE `CityExportStaging` (
            `ID` int(11) NOT NULL AUTO_INCREMENT,
            `Name` char(35) NOT NULL DEFAULT '',
            `CountryCode` char(3) NOT NULL DEFAULT '',
            `District` char(20) NOT NULL DEFAULT '',
            `Population` int(11) NOT NULL DEFAULT '0',
            PRIMARY KEY (`ID`));


   sqoop --options-file cities-export-options.txt --table CityExport  --staging-table CityExportStaging  --clear-staging-table -m 4 --export-dir /user/hdfs/sqoop-mysql-import/city
```

* Check table in Mysql
```
   mysql> select * from CityExport limit 10;
   +----+----------------+-------------+---------------+------------+
   | ID | Name           | CountryCode | District      | Population |
   +----+----------------+-------------+---------------+------------+
   |  1 | Kabul          | AFG         | Kabol         |    1780000 |
   |  2 | Qandahar       | AFG         | Qandahar      |     237500 |
   |  3 | Herat          | AFG         | Herat         |     186800 |
   |  4 | Mazar-e-Sharif | AFG         | Balkh         |     127800 |
   |  5 | Amsterdam      | NLD         | Noord-Holland |     731200 |
   |  6 | Rotterdam      | NLD         | Zuid-Holland  |     593321 |
   |  7 | Haag           | NLD         | Zuid-Holland  |     440900 |
   |  8 | Utrecht        | NLD         | Utrecht       |     234323 |
   |  9 | Eindhoven      | NLD         | Noord-Brabant |     201843 |
   | 10 | Tilburg        | NLD         | Noord-Brabant |     193238 |
   +----+----------------+-------------+---------------+------------+
   10 rows in set (0.00 sec)
```


### Some Handy Clean-up Commands

* remove the table


    mysql> Drop table `CityExportStaging`;

 * remove data in table
```
   mysql> delete from CityExportStaging;
   mysql> delete from CityExportStaging;
```

* clean-up imported files
`hdfs dfs -rm -r  -skipTrash sqoop-mysql-import/{country,city, canada-city}`
