        export yarnroot=/opt/yarn/hadoop-2.1.0-beta

        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$yarnroot/lib/native
        export PATH=$PATH:$yarnroot/bin
        export HADOOP_HOME=$yarnroot
        export HADOOP_MAPRED_HOME=$yarnroot
        export HADOOP_COMMON_HOME=$yarnroot
        export HADOOP_HDFS_HOME=$yarnroot
        export YARN_HOME=$yarnroot
        export HADOOP_CONF_DIR=$yarnroot/etc/hadoop
        export YARN_CONF_DIR=$yarnroot/etc/hadoop

        export YARN_EXAMPLES=$yarnroot/share/hadoop/mapreduce
