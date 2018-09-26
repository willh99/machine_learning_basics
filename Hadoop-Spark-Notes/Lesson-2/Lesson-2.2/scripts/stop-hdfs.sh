su hdfs -c ". /etc/profile.d/java.sh;echo 'STOPPING NAMENODE'; /opt/hadoop-2.8.1/sbin/hadoop-daemon.sh stop namenode; echo 'COMPLETE';  exit"
su hdfs -c ". /etc/profile.d/java.sh;echo 'STOPPING SECONDARY NAMENODE';  /opt/hadoop-2.8.1/sbin/hadoop-daemon.sh stop secondarynamenode; echo 'COMPLETE';  exit"
su hdfs -c ". /etc/profile.d/java.sh;echo 'STOPPING DATANODE'; /opt/hadoop-2.8.1/sbin/hadoop-daemon.sh stop datanode; echo 'COMPLETE';  exit"
su hdfs -c ". /etc/profile.d/java.sh;echo 'REMAINING DAEMONS'; jps; exit;"  

