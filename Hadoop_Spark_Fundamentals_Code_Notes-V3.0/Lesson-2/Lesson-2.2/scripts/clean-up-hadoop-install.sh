# remove files, users, groups installed with hadoop-setup-script.sh 
userdel -r yarn
userdel -r hdfs
userdel -r mapred
groupdel hadoop
/bin/rm /etc/profile.d/java.sh /etc/profile.d/hadoop.sh
/bin/rm -r /var/data/hadoop/
/bin/rm -r /opt/hadoop-2.8.1
echo "Complete"

