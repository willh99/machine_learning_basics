# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 6.3 APACHE OOZIE 

OS: Linux  
Platform: RHEL 6.3  
Hadoop Version: 2.4  
Hadoop Version: Hortonworks HDP 2.1  
Oozie Version: 4.0.0  

Reference: http://oozie.apache.org/docs/4.0.0/index.html
 

#### Step 1: Set hadoop.proxyuser.oozie.groups in core-site.xml

_*This step depends on the group that will be running*_
_*Oozie. The default is "users." We are going to run*_
_*Oozie as group "hadoop" so there is a change needed*_
_*in the core-site.xml file.*_

* If using Ambari, go to Services/HDFS/Config tab and at the bottom
click on  Custom core-site.xml. Change "hadoop.proxyuser.oozie.groups"
from "users" to "hadoop."

*Note: You may wish to change this for faclon, hcat, and hive as well.*
*If you plan on keeping placing users in group "users" this is not needed.*

* If not using Ambari, set this directly in core-site.xml and restart Hadoop.
```xml
<property>
   <name>hadoop.proxyuser.oozie.groups</name>
   <value>hadoop</value>
</property>
```

#### Step 2: Download Oozie Examples

* The examples are part of the oozie-client-4.0.0.2.1.2.1-471.el6.noarch.rpm
package. Make sure this is installed, then as user hdfs,

`tar xvzf /usr/share/doc/oozie-4.0.0.2.1.2.1/oozie-examples.tar.gz`

* the examples must also be placed in HDFS:

`hdfs dfs -put examples/ examples`

The the Oozie Share Library must be installed in HDFS.
If you are using the Ambari install of HDP 2.1 from lesson 8.6, this is 
already in HDFS under: `/user/oozie/share/lib`. It is part of the 
`oozie-4.0.0.2.1.2.1-471.el6.noarch.rpm` and is installed on the host in 
`/usr/lib/oozie/oozie-sharelib.tar.gz`. If you install by hand, then 
make /user/oozie in HDFS and put the extracted oozie-sharelib files
in this directory as user oozie and group hadoop.

The example applications are under the examples/app directory, one directory per example. 
The directory contains the application XML file (workflow, or worklfow and coordinator), 
the job.properties file to submit the job and any JAR files the example may need.

The inputs for all examples are in the `examples/input-data/` directory.
The examples create output under the `examples/output-data/${EXAMPLE_NAME}` directory.

#### Step 3: Run The Simple MapReduce Example

`job.properties` - defined values (path names, ports, etc) for a jobs
`workflow.xml` - workflow for the job. In this case, simple MR (pass/fail)

* view the workflow.xml

`vim examples/apps/map-reduce/workflow.xml`

* Update local `job.properties` to reflect current system.
  *Important: This must be done for all the examples.

`vim examples/apps/map-reduce/job.properties`

**Change **
```
   nameNode=hdfs://localhost:8020
   jobTracker=localhost:8032
```
**to**
```
   nameNode=hdfs://limulus:8020
   jobTracker=limulus:8050
```

_*Note the change in port number for the jobTracker line.*_

* Run the job

`oozie job -run -oozie http://limulus:11000/oozie -config examples/apps/map-reduce/job.properties`

* To avoid having to provide the -oozie option with the Oozie URL with every oozie command, 
set OOZIE_URL env variable to the Oozie URL in the shell environment. For example:

`export OOZIE_URL="http://limulus:11000/oozie`

* Then the command is (it then prints the job id number):
```
   oozie job  -config examples/apps/map-reduce/job.properties -run
   job: 0000005-140824145757925-oozie-oozi-W

   oozie job  -info job: 0000005-140824145757925-oozie-oozi-W
```

* Use the Oozie web console to view job progress and flow.

`http://limulus:11000/oozie/`



#### Step 4: Run the Oozie Demo Application

A more sophisticated example can be found in the demo directory:

* View the workflow.xml

`vim examples/apps/demo/workflow.xml`

* Don't forget to change `examples/apps/demo/job.properties` (see above) to run:

`oozie job -run   -config examples/apps/demo/job.properties`


### Short Summary of Oozie job Commands


1. Run Job:

`oozie job -run  -config JOB_PROPERITES`

2. Submit job:

`oozie job -config JOB_PROPERTIES -submit job: OOZIE_JOB_ID`
 
3. Run job:

`oozie job  -start OOZIE_JOB_ID`
 
4. Check the status:

`oozie job  -info OOZIE_JOB_ID`
 
5. Suspend workflow:

`oozie job  -suspend OOZIE_JOB_ID`
 
6. Resume workflow:

`oozie job  -resume OOZIE_JOB_ID`
 
7. Re-run workflow:

`oozie job  -config JOB_PROPERTIES -rerun OOZIE_JOB_ID`
 
8. Should you need to kill the job:

`oozie job  -kill OOZIE_JOB_ID`
 
9. View server logs:

`oozie job  -logs OOZIE_JOB_ID`
 
  * Full Logs are available at:

   `/var/log/oozie on the Oozie server.`
