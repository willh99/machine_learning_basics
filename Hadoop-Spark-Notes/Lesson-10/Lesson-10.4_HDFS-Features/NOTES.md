# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 10.4: UTILIZE ADDITIONAL FEATURES OF HDFS

OS: Linux  
Platform: CentOS 6.9  
Hadoop Version: 2.7.3  

Cluster: four nodes, 4-cores per node, GbE, 16 GB/node, two SSD's for HDFS (64G and 128G)
         node names are limulus, n0,n1,n2

### Background:

We will be using a small cluster to demonstrate some basic HDFS features
*  Snapshots
*  Web GUI
*  NFSv3 gateway to HDFS


### HDFS Snapshots

HDFS Snapshots are read-only, point-in-time copies of HDFS. Snapshots 
can be taken on a sub tree of the file system or the entire file system. 
Some common use cases of snapshots are data backup, protection against 
user errors and disaster recovery. 
Snapshots can be taken on any directory once the directory has been set as 
`snapshot-able`. (Up to 65,536 simultaneous snapshots.)

* Administrators may set any directory to be snapshottable. 
Nested snapshottable directories are currently not allowed. 

`  hdfs dfsadmin -allowSnapshot  /user/deadline/War-and-Peace`

* Once the directory has been made snapshottable, the snapshot can be taken with
the following command. 
  * The command requires the directory path and a name for the snapshot:

`  hdfs dfs -createSnapshot /user/deadline/War-and-Peace WaP-snap-1`

* Check the contents of the directory

`   hdfs dfs -ls /user/deadline/War-and-Peace`

* If the file is deleted, it can be restored from the snapshot:

`  hdfs dfs -rm -skipTrash /user/deadline/War-and-Peace/war-and-peace.txt`

* Deleted `/user/hdfs/war-and-peace-input/war-and-peace.txt`

`   hdfs dfs -ls /user/deadline/War-and-Peace`

* The restoration process is basically a simple copy from the .snapshot directory
to the previous directory (or anywhere else). 

`   hdfs dfs -cp /user/deadline/War-and-Peace/.snapshot/WaP-snap-1/war-and-peace.txt /user/deadline/War-and-Peace/`

* A snapshot can be deleted using the following command:

`  hdfs dfs -deleteSnapshot /user/deadline/War-and-Peace WaP-snap-1`

* Finally, a directory can be made un-snapshot-able by using the 
following command:

`  hdfs dfsadmin -disallowSnapshot /user/deadline/War-and-Peace`


### Configuring an NFSv3 Gateway to HDFS 

HDFS supports an NFS version 3 (NFSv3) gateway. This feature enables files 
to be easily moved between HDFS and client systems. The NFS Gateway supports 
NFSv3 and allows HDFS to be mounted as part of the client's local file system. 

In Lesson 10.2 we added HDFS NFS gateway to node "n0"
* The following commands illustrate the gateway usage
```
  mkdir /mnt/hdfs

  mount -t nfs -o vers=3,proto=tcp,nolock n0:/  /mnt/hdfs/
  
  ls /mnt/hdfs 
  app-logs  ats  livy2-recovery  mapred      spark2-history  system  user
  apps      hdp  livy-recovery   mr-history  spark-history   tmp

  hdfs dfs -ls /
  Found 13 items
  drwxrwxrwx   - yarn   hadoop          0 2017-10-18 08:51 /app-logs
  drwxr-xr-x   - hdfs   hdfs            0 2017-10-11 16:27 /apps
  drwxr-xr-x   - yarn   hadoop          0 2017-10-11 16:19 /ats
  drwxr-xr-x   - hdfs   hdfs            0 2017-10-11 16:19 /hdp
  drwx------   - livy   hdfs            0 2017-10-11 16:21 /livy-recovery
  drwx------   - livy   hdfs            0 2017-10-11 16:21 /livy2-recovery
  drwxr-xr-x   - mapred hdfs            0 2017-10-11 16:19 /mapred
  drwxrwxrwx   - mapred hadoop          0 2017-10-11 16:20 /mr-history
  drwxrwxrwx   - spark  hadoop          0 2017-10-23 16:34 /spark-history
  drwxrwxrwx   - spark  hadoop          0 2017-10-23 16:34 /spark2-history
  drwxr-xr-x   - hdfs   hdfs            0 2017-10-23 15:49 /system
  drwxrwxrwx   - hdfs   hdfs            0 2017-10-11 16:27 /tmp
  drwxr-xr-x   - hdfs   hdfs            0 2017-10-18 08:48 /user
```

* test the gateway
```
  cp /mnt/hdfs/user/deadline/War-and-Peace/war-and-peace.txt copy-of-war-and-peace.txt

  cp copy-of-war-and-peace.txt /mnt/hdfs/user/deadline/War-and-Peace/

  ls -l /mnt/hdfs/user/deadline/
```

* node n0 uses `/tmp/.hdfs-nfs` for staging

##### NOTE:

If when copying files to and from the NFSv3 gateway, you get 
`cp: cannot create regular file '....': Input/output error`
you may need to set HDFS Access time precision (dfs.namenode.accesstime.precision)
to 3600000 (default is 0) in the HDFS General settings. 
