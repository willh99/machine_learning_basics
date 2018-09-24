su hdfs -c ". /etc/profile.d/java.sh;echo 'STARTING NAMENODE'; /opt/hadoop-2.8.1/sbin/hadoop-daemon.sh start namenode; echo 'COMPLETE';  exit"
su hdfs -c ". /etc/profile.d/java.sh;echo 'STARTING SECONDARY NAMENODE';  /opt/hadoop-2.8.1/sbin/hadoop-daemon.sh start secondarynamenode; echo 'COMPLETE';  exit"
su hdfs -c ". /etc/profile.d/java.sh;echo 'STARTING DATANODE'; /opt/hadoop-2.8.1/sbin/hadoop-daemon.sh start datanode; echo 'COMPLETE';  exit"
su hdfs -c ". /etc/profile.d/java.sh;echo 'STARTED DAEMONS'; jps; exit;"  

