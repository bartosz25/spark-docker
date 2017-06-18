# spark-docker-yarn
This repository contains Docker images for Spark executed on Hadoop YARN. The purpose of them is to allow programmers to test Spark applications deployed on YARN easier. **It was not designed to be deployed in production environments**. The project was tested on Ubuntu 16. 

# Building the cluster
The cluster is built with `build_cluster.sh` script. The script accepts 2 parameters: 
```
./build_cluster.sh [number of workers] [recreate]
```
Where:
* `[number of workers]` - number of workers to deploy
* `[recreate]` - if set to `recreate`, previously built images will be destroyed and rebuild

For example, to build a cluster with 3 slaves, the following command must be used:
```
./build_cluster.sh 3
```

To build a cluster with 3 slaves and rebuild Docker images, this command must be executed:
```
./build_cluster.sh 3 recreate
```


# Spark and YARN UIs
Spark and YARN expose web UI used to track the execution of the applications:
* http://spark-master:8088 - YARN UI's address
* http://spark-master:18080 - Spark history UI's address

# Repository structure
* conf-master: stores master's configuration files are stored there
* conf-slave: stores slave's configuration files are stored there 
* master: contains master's Dockerfile and building script
* slave: contains slave's Dockerfile and building script
* shared-master: this repository is shared between master's Docker container (/home/sparker/shared) and host. 
* shared-slave: this repository is shared between slave Docker containers (/home/sparker/shared) and host

Shared repositories can be used to, for example, put the JAR executed with spark-submit inside.

# Tests
To verify that the cluster was correctly installed, launch _SparkPi_ example:
```
spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster --driver-memory 1g --executor-memory 1g --executor-cores 1 ~/spark-2.1.0-bin-hadoop2.7/examples/jars/spark-examples*.jar 1000
```