su yarn -c ". /etc/profile.d/java.sh;echo 'STOPPING HISTORYSERVER'; /opt/hadoop-2.8.1/sbin/mr-jobhistory-daemon.sh stop historyserver; echo 'COMPLETE';  exit"
su yarn -c ". /etc/profile.d/java.sh;echo 'STOPPING NODEMANGER'; /opt/hadoop-2.8.1/sbin/yarn-daemon.sh stop nodemanager; echo 'COMPLETE';  exit"
su yarn -c ". /etc/profile.d/java.sh;echo 'STOPPING RESOURCEMANGER'; /opt/hadoop-2.8.1/sbin/yarn-daemon.sh stop resourcemanager; echo 'COMPLETE';  exit"
su yarn -c ". /etc/profile.d/java.sh;echo 'REMAINING  DAEMONS'; jps; exit;"  

