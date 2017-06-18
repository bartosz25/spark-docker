#!/bin/bash
echo "Initializing SSH"
sudo service ssh start
# Start Spark master
echo "Starting Spark slave..."
exec start-slave.sh -p 7177 -c 1 -m 1G -h spark-slave  spark://spark-master:7077 &


# sparker@spark-slave:~/hadoop-2.7.3/sbin$ ./yarn-daemon.sh start nodemanager
exec ~/hadoop-2.7.3/sbin/yarn-daemon.sh start nodemanager &

# exec bash

while true; do sleep 1000; done