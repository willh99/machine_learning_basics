# Apache Hadoop and Spark Fundamentals (Third Edition)

# LESSON 8.3 APACHE FLUME

OS: Linux  
Platform: RHEL 6.3  
Hadoop Version: 2.4  
Hadoop Version: Hortonworks HDP 2.1 (Hadoop version 2.4)  
Flume Version: 1.4.0  
Reference: https://flume.apache.org/FlumeUserGuide.html  

### Step 1: Download Install Apache Flume

* assumes HDP repository for yum

  `yum install flume flume-agent`

* need telent for example

 ` yum install telnet`


### Step 2: Simple Test

* Agent only needed on nodes that generate data 

`flume-ng agent --conf conf --conf-file simple-example.conf --name simple_agent -Dflume.root.logger=INFO,console`

* In another window
```
telnet localhost 44444

  Trying ::1...
  telnet: connect to address ::1: Connection refused
  Trying 127.0.0.1...
  Connected to localhost.
  Escape character is '^]'.
  testing  1 2 3
  OK
```

* Flume agent shows

`14/08/14 16:20:58 INFO sink.LoggerSink: Event: { headers:{} body: 74 65 73 74 69 6E 67 20 20 31 20 32 20 33 0D    testing  1 2 3. } `

### Step 3: Web Log Example
Record the weblogs from the local machine. If no web log is available, you can use any file under /var/log that grows.
Two files are needed:
```
  web-server-target-agent.conf - the target flume agent that writes the data to HDFS
  web-server-source-agent.conf - the source flume agent that captures the web log data
```

#### The Source Web Server

Flume can work with any log file. A web server log offers plenty of data.
A Flume agent started using the  "web-server-source-agent.conf" will capture
and send the data. Because this is system data, the Flume agent must be started by root.
The important lines in the "web-server-source-agent.conf"  are:

* Defines the log to capture:

`  source_agent.sources.apache_server.command = tail -f /etc/httpd/logs/access_log`

* Defines the "sink" location and port Change this IP top suite your needs.
```
  source_agent.sinks.avro_sink.hostname =  192.168.93.56
  source_agent.sinks.avro_sink.port = 4545
```
* Consult the Flume documentation for other options and description of the entire file

#### The Target HDFS Server

A Flume agent started using the  "web-server-target-agent.conf" will wait for data from
the source agent and write it to both HDFS and /var. The user running the target agent
must have permission to write to HDFS.
The important lines in the "web-server-source-agent.conf"  are:

* listen on port 4545 from any source
```
  collector.sources.AvroIn.bind = 0.0.0.0
  collector.sources.AvroIn.port = 4545
```

* make a copy in `/var/log/flume-hdfs`

  `collector.sinks.LocalOut.sink.directory = /var/log/flume-hdfs`

* write the data to HDFS (change deadline to appropriate user name)

  `collector.sinks.HadoopOut.hdfs.path = /user/deadline/flume-channel/%{log_type}/%y%m%d`

* Consult the Flume documentation for other options and description of the entire file

#### Run the Example (Source and Target on Same Server)

* First, as root make local log directory to echo the web log
```
  mkdir /var/log/flume-hdfs
  chown deadline:hadoop /var/log/flume-hdfs/
```
* Next, as user hdfs make a flume data directory in HDFS
(change deadline to appropriate user name)

`  hdfs dfs -mkdir /user/deadline/flume-channel/`

Start flume target agent as user deadline (writes data to HDFS)
This agent should be started before the source agent.
*Note: with HDP flume can be started as a service when the system boots*
*e.g `service start flume` The `/etc/flume/conf/{flume.conf,flume-env.sh.template}`*
*files need to be configured. For this example*
*`/etc/flume/conf/flume.conf` would be the same as `web-server-target.conf`*

`  flume-ng agent  -f conf/web-server-target-agent.conf -n collector`

* *as root*, start the source agent to feed the target agent
(needs root to read the web logs)

`  su -c "flume-ng agent  -f conf/web-server-source-agent.conf -n source_agent"`

* check to see if working (assuming no errors from flume-ng agents)
  * inspect local log, as user hdfs (file name will vary)

  `tail -f /var/log/flume-hdfs/1408126765449-1`

* inspect data in HDFS (filename will vary)

`  hdfs dfs -tail flume-channel/apache_access_combined/140815/FlumeData.1408126868576`

#### More Information 
* see the flume website for more information (including plugins)
``` 
  https://flume.apache.org/FlumeUserGuide.html
  http://www.rittmanmead.com/2014/05/trickle-feeding-webserver-log-files-to-hdfs-using-apache-flume/
```