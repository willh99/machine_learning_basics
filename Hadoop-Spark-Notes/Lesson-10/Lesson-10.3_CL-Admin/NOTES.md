# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 10.3: PERFORM SIMPLE ADMINISTRATION AND MONITORING USING THE COMMAND LINE

OS: Linux  
Platform: CentOS 6.9  
Hadoop Version: 2.7.3  

Cluster: four nodes, 4-cores per node, GbE, 16 GB/node, two SSD's for HDFS (64G and 128G)
         node names are limulus, n0,n1,n2

### Background:

We will be using a small cluster to demonstrate some basic command line functions
The following list of tasks is only a quick summary of some common tasks.
There are many other aspects to Hadoop and Spark administration (most of
which can be done with Ambari)



### Managing YARN Jobs
* YARN jobs can be managed using the yarn application command. 
```
yarn application -help

usage: application
 -appStates <States>             Works with -list to filter applications
                                 based on input comma-separated list of
                                 application states. The valid application
                                 state can be one of the following:
                                 ALL,NEW,NEW_SAVING,SUBMITTED,ACCEPTED,RUN
                                 NING,FINISHED,FAILED,KILLED
 -appTypes <Types>               Works with -list to filter applications
                                 based on input comma-separated list of
                                 application types.
 -help                           Displays help for all commands.
 -kill <Application ID>          Kills the application.
 -list                           List applications. Supports optional use
                                 of -appTypes to filter applications based
                                 on application type, and -appStates to
                                 filter applications based on application
                                 state.
 -movetoqueue <Application ID>   Moves the application to a different
                                 queue.
 -queue <Queue Name>             Works with the movetoqueue command to
                                 specify which queue to move an
                                 application to.
 -status <Application ID>        Prints the status of the application.
```


The following shows a listing for a MAPREDUCE job running on the cluster. 
MapReduce jobs can also be controlled with the mapred job command. 
```
  yarn application -list
  Total number of applications (application-types: [] and states: [SUBMITTED, ACCEPTED, RUNNING]):1
         Application-Id	 Application-Name   Application-Type  User   Queue   State    Final-State  Progress  Tracking-URL
  application_1508525544406_0003   TeraSort     MAPREDUCE   deadline default RUNNING UNDEFINED     38.28%    http://n1:35445
```

*To kill and application use the Application-Id*
```
  yarn application -kill application_1508525544406_0003
  Killing application application_1508525544406_0003
  17/10/23 13:15:24 INFO impl.YarnClientImpl: Killed application application_1508525544406_0003
```

* To see all finished applications

`  yarn application -list -appStates FINISHED`

* To see all finished SPARK jobs

`  yarn application -list -appTypes SPARK -appStates FINISHED`


### Adding Users to HDFS

_*Must be done as user hdfs*_

For a full explanation of HDFS permissions see the following: 
http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsPermissionsGuide.html. 
Keep in mind errors running Hadoop applications are often due to file permissions. 

* To quickly create user accounts manually on a Linux based system, perform the following:
  1. Add the user to the group for your OS on the HDFS client system. In most cases, 
     the groupname should be the that of the hdfs superuser user, which is often "hadoop" or "hdfs."  
     `useradd -G <groupname> <username>`
  2. Create the username directory in HDFS.  
     `hdfs dfs -mkdir /user/<username>`
  3. Give that account ownership over its directory in HDFS.  
     `hdfs dfs -chown <username>:<groupname> /user/<username>`

### Perform an FSCK on HDFS
_*Must be done as user hdfs*_

The health of HDFS is checked by using the `hdfs fsck <path>`
(file system check) command. The entire HDFS name space can be checked, or a 
subdirectory can be entered as an argument to the command. The following 
example checks the entire HDFS namespace. 

`  hdfs fsck /`

* To remove corrupted files

`  hdfs fsck -delete /user`

* To move corrupted files to `/lost+found` (in HDFS)

`  hdfs fsck -move /`

### Generate HDFS Report
_*Must be done as user hdfs -- all others get an abbreviated report*_

* Similar information on HDFS web GUI

`  hdfs dfsadmin -report`

* Get a quick look at HDFS "spread"

`  hdfs dfsadmin -report|grep "DFS Used%"`

### Balance HDFS
_*Must be done as user hdfs*_

HDFS may become unbalanced. Run the following to get all data nodes storage
levels within 10% of each other. 

* For lower or higher percentage use 1=1% 2=2% 5=5% etc. 

`  hdfs balancer -threshold 10`

* You can set upper limit on bandwidth. Balancing can be stopped and restarted at any time.

### HDFS Safe Mode
_*Must be done as user hdfs*_

When the NameNode starts, it loads the file system state from the fsimage and
then applies the edits log file. It then waits for DataNodes to report their 
blocks. During this time, the NameNode stays in a read-only safemode. 
The NameNode leaves safemode automatically after the DataNodes have reported
that most file system blocks are available. No changes are allowed when HDFS is
in safe mode. The administrator can place HDFS in safemode using the 
following command:

    hdfs dfsadmin -safemode enter

Entering the following can turn off safemode:

    hdfs dfsadmin -safemode leave

HDFS may drop into safe mode if there is a major issue with the file system
(e.g. a full DataNode). The file system will not leave safemode until the 
situation is resolved. To check whether HDFS is in safemode, enter the
following command:

    hdfs dfsadmin -safemode get





