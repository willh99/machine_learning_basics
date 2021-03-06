# Apache Hadoop and Spark Fundamentals (Third Edition)

## LESSON 10.1: APACHE AMBARI 2.5 INSTALL OF APACHE HADOOP (part 1)

OS: Linux  
Platform: CentOS 6.9  
Ambari Version: 2.5.1.0  

Cluster: four nodes, 4-cores per node, GbE, 16 GB/node, two SSD's for
HDFS (64G and 128G) node names are limulus, n0,n1,n2

### Background:

We will be using Ambari to install Hadoop on a small 4-node cluster. 
The cluster will have one "login" node named "limulus"
and three worker nodes named "n0, n1, n2"

* There are two steps:
  1. Configure nodes and start ambari-agents and start ambari-server (text mode)
  2. Switch to web browser and use Ambari

### Step 1: Install Java (if needed) and PDSH

We are using OpenJDK 1.7, usually installed with Red Hat/CentOS
If using RHEL (or variant) use java-1.7.0-openjdk RPM (install if needed,
as root, `yum install java-1.7.0-openjdk-devel java-1.7.0-openjdk`
Add `java.sh` to `profile.d`

    echo 'export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64'> /etc/profile.d/java.sh

    source /etc/profile.d/java.sh

Other Linux distributions may differ, and the steps may need to be adjusted.

Java needs to be present on all cluster nodes, this can be accomplished through 
a kickstart file.

To make installation easier, the parallel distributed shell (pdsh) package
is installed. We also add the "epel" repository so we can find the pdsh package.

On admin, main or headnode install epel repo and pdsh
In general there will be a node from which you will run the main
Ambari server. We will refer to this as the headnode.

    rpm -Uvh  http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

    yum install pdsh-rcmd-ssh

To have pdsh work effectively, each host in the cluster must support password-less
root login. This task is accomplished by placing the head node public ssh key 
in the .ssh directory in each of the worker nodes `~/.ssh/authorized_keys` file
If provisioning nodes with a "kickstart" install, this is easily done by 
writing the key in the post install section.


### Step 2: Set up the Ambari Server and Agents

Use wget to install the Ambari repo on the head node  
Check on https://docs.hortonworks.com for latest version 

    wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.5.1.0/ambari.repo -O /etc/yum.repos.d/ambari.repo

* Use pdsh to install Ambari repo on the worker nodes (run "man pdsh" for options explanation):

`pdsh -w n[0-2] wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.5.1.0/ambari.repo -O /etc/yum.repos.d/ambari.repo`


* Install the Ambari Agent

`pdsh -w n[0-2] yum -y install ambari-agent`

* Set the Ambari Server hostname on nodes (limulus in this case)

`pdsh -w n[0-2] "sed -i 's/hostname=localhost/hostname=limulus/g' /etc/ambari-agent/conf/ambari-agent.ini"`

* Start the Ambari Agents

`pdsh -w n[0-2] "service ambari-agent start"`

* We double up the head node as a worker node, so install ambari agent and server

`yum install ambari-agent ambari-server`

* Set the Ambari host to itself

`sed -i 's/hostname=localhost/hostname=limulus/g' /etc/ambari-agent/conf/ambari-agent.ini`

* Start the local ambari agent

`service ambari-agent start`

* Set up the ambari server to use local openjdk

`ambari-server setup -j /usr/lib/jvm/java-1.7.0-openjdk.x86_64`

* Start the ambari server

`ambari-server start`

### Step 3: Go to web browser and login

`firefox http://headnode:8080/`

_*login="admin" password="admin"*_

### Step 4: If needed, Clean-up

To clean out the install use `reset`  
_*!!! It will wipe out database and require reinstall !!!*_

    ambari-server stop
    ambari-server reset

To remove RPMS from nodes:  
_*!!! Careful: May delete accounts as well as RPMS !!!*_
Often not needed if doing a reset `reinstall`

    python /usr/lib/python2.6/site-packages/ambari_agent/HostCleanup.py

### EXTRA STEP IF USING FALCON
See: https://community.hortonworks.com/articles/76537/falcon-web-ui-is-inaccessiblehttp-503-error-and-am.html

Falcon fix: (Hortonworks cannot ship this jar, so it must be downloaded separately)
Use thiese steps

    wget http://search.maven.org/remotecontent?filepath=com/sleepycat/je/5.0.73/je-5.0.73.jar -O /usr/hdp/current/falcon-server/server/webapp/falcon/WEB-INF/lib/je-5.0.73.jar
    chown falcon:hadoop /usr/hdp/current/falcon-server/server/webapp/falcon/WEB-INF/lib/je-5.0.73.jar


## Ambari is Up! Now to Install Hadoop!
Connect to port 8080 on localhost or admin node if accessing remotely

`hostname:8080` -> `hostname:8080/#/login`  

Default username: admin, password: admin

Ambari should run checks on all installs, so you can be pretty confident that
your packages will be installed as desired.

#### Step 1 - Get Started
Name your cluster and hit next

#### Step 2 - Select Version
Might as well use the latest HDP version unless you know you have legacy code
that depends on an old version. A large cluster may benefit from pulling OS
images from a local repository dude to their size and the required bandwidth
for timely  installation.

#### Step 3 - Install Options
* Enter Your Target Hosts
  * You may wish to enter Fully Qualified Domain Names (FQDN) to safety
  * You can often get away with using assigned names (i.e. limulus, n0, ...)
* Host Registration Information
  * We are using manual registration since we have the ambari agent running on
    all our nodes. This is **required** for manual registration

#### Step 4 - Confirm Hosts
Check your warnings and see that they will not cause issue for your installation.
Example: Firewall configuration

#### Step 5 - Choose Services
Pick the packages that you want to install. HDFS, Pig, Hive, Spark, etc.

#### Step 6 - Assign Masters
You can configure your service distribution based on the specifications of your
nodes. For example, you may wish to overload a node that has significantly 
higher RAM or more cores.

#### Step 7 - Assign Slaves and Clients
Which nodes are DataNodes, NFSGateways, NodeManagers. Here is our config:

| Node    | DataNodes | NFSGateway | NodeManger| Region Server | Phoenix Query Server | Flume | Livy Server | Spark Thrift Server | Livy Spark2 Server | Client |
|---------|-----------|------------|-----------|---------------|----------------------|-------|-------------|---------------------|--------------------|--------|
| limulus | yes       | no         | yes       | yes           | yes                  | yes   | yes         | yes                 | yes                | yes    |
| n0      | yes       | yes        | yes       | yes           | no                   | no    | no          | no                  | no                 | no     |
| n1      | yes       | no         | yes       | yes           | no                   | no    | no          | no                  | no                 | no     |
| n2      | yes       | no         | yes       | yes           | no                   | no    | no          | no                  | no                 | no     |

#### Step 8 - Customize Services
Some additional information is needed for the setup of some services. Ambari
will help by highlighting there services with a red number and giving addtional
information when you hover over the server. For example, the NameNode needs to
be told where to store its directories. We specified `/hadoop/hdfs/namenode/var/lib`
as the main path and `/hdfs/namenode` as a backup.

For the DataNode we specified:
```
/hdfs1/hadoop/hdfs/data/hdfs2/hadoop
/hdfs/data
```
And for secondary NameNode in Advance Options:  
`/hadoop/hdfs/namesecondary/var/hdfs/namesecondary`

We also set blockreplication to 2 since this is a small, non-critical instance.
This will save us some memory.

###### We then moved on to the YARN configuraton:  
yarn.nodemanger.local-dirs: `/hadoop/yarn/local/var/hadoop/yarn/local`  
yarn.nodemanger.log-dirs:   `/hadoop/yarn/log/var/hadoop/yarn/log`

###### Simply finish these configurations for the services

#### Step 9 - Review
Check the YAML and see that it is to your specification

#### Step 10 - Install, Start, and Test
Install can be monitored graphically in Ambari in real time.
Check warnings for any orange bars.

#### Step 11 - Summary