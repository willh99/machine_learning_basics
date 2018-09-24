su yarn -c ". /etc/profile.d/java.sh;echo 'STARTING RESOURCEMANGER'; /opt/hadoop-2.8.1/sbin/yarn-daemon.sh start resourcemanager; echo 'COMPLETE';  exit"
su yarn -c ". /etc/profile.d/java.sh;echo 'STARTING NODEMANGER'; /opt/hadoop-2.8.1/sbin/yarn-daemon.sh start nodemanager; echo 'COMPLETE';  exit"
su yarn -c ". /etc/profile.d/java.sh;echo 'STARTING HISTORYSERVER'; /opt/hadoop-2.8.1/sbin/mr-jobhistory-daemon.sh start historyserver; echo 'COMPLETE';  exit"
su yarn -c ". /etc/profile.d/java.sh;echo 'STARTED DAEMONS'; jps; exit;"  

