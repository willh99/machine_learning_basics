# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 3.2 USE HDFS COMMAND LINE TOOLS


_*To interact with HDFS, the hdfs command must be used.8_
_*HDFS provides a series of commands similar to those found in a standard*_
_*Unix/Linux file system, excpet they must be prefaced with `hdfs dfs`*_

### List Files in HDFS

* To list the files in the root HDFS directory enter the following:
```
$ hdfs dfs -ls /
Found 8 items
drwxr-xr-x  - hdfs  hdfs   0 2013-02-06 21:17 /apps
drwxr-xr-x  - hdfs  hadoop   0 2014-01-01 14:17 /benchmarks
drwx------  - mapred hdfs   0 2013-04-25 16:20 /mapred
drwxr-xr-x  - hdfs  hdfs   0 2013-12-17 12:57 /system
drwxrwxr--  - hdfs  hadoop   0 2013-11-21 14:07 /tmp
drwxrwxr-x  - hdfs  hadoop   0 2013-10-31 11:13 /user
drwxr-xr-x  - doug  hdfs   0 2013-10-11 16:24 /usr
drwxr-xr-x  - hdfs  hdfs   0 2013-10-31 21:25 /yarn
```

* To list files in your home directory in HDFS enter the following:
```
$ hdfs dfs –ls
Found 16 items
drwx------  - doug hadoop   0 2013-04-26 02:00 .Trash
drwxr-xr-x  - doug hadoop   0 2013-05-14 17:07 test
drwxr-xr-x  - doug hadoop   0 2013-05-14 17:23 test-output
drwx------  - doug hadoop              0 2013-05-15 11:21 war-and-peace
drwxr-xr-x  - doug hadoop   0 2013-02-06 15:14 wikipedia
drwxr-xr-x  - doug hadoop   0 2013-08-27 15:54 wikipedia-output
```

* The same result can be obtained by issuing a:  
`$ hdfs dfs -ls /user/doug`

### Make a Directory in HDFS

* To make a directory in HDFS use the following command. 
As with the `–ls` command, when no path is supplied the users home directory 
is used.   (i.e. `/users/doug`)

`$ hdfs dfs -mkdir stuff`

### Copy Files to HDFS

_*To copy a file from your current local directory into HDFS use the following.*_
_*Note again, that the absence of a full path assumes your home directory.*_
_*In this case the file test is placed in the directory stuff,*_
_*which was created above.*_

`$ hdfs dfs -put test stuff`

*The file transfer can be confirmed by using the –ls command:*
```
$ hdfs dfs -ls stuff
  
Found 1 items
-rw-r--r--  3 doug hadoop   0 2014-01-03 17:03 stuff/test
```

### Copy Files from HDFS

_*Files can be copied back to your local file system using the following.*_
_*In this case, the file we copied into HDFS, test, will be copied back to the*_
_*current local directory with the name test-local.*_

`$ hdfs dfs -get stuff/test test-local`

### Copy Files within HDFS

* The following will copy a file in HDFS:

`$ hdfs dfs -cp stuff/test test.hdfs`

### Delete a File within HDFS

_*The following will delete the HDFS file test.dhfs that was created above.*_  
*Note, if the "-skipTrash" argument is not provided, a message indicating*
*that the file has been moved to your .Trash directory will be printed.*
```
$ hdfs dfs -rm -skipTrash test.hdfs
  
Deleted test.hdfs
```

### Delete a Directory in HDFS

* The following will delete the HDFS directory stuff and all its contents:
```
$ hdfs dfs -rm -r stuff
  
Deleted stuff
```