# Get base image
FROM ubuntu:16.04

# Install Java
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean 
     
# Install needed packages
RUN apt-get install less -y
RUN apt-get -y install vim

RUN useradd -ms /bin/bash sparker
USER sparker
WORKDIR /home/sparker

# Download Spark binary distribution with Hadoop 
ENV HADOOP_VERSION 2.7.3
ENV HADOOP_HOME /home/sparker/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
RUN wget http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -O ./hadoop-$HADOOP_VERSION.tar.gz
# COPY hadoop-2.7.3.tar.gz ./hadoop-2.7.3.tar.gz
RUN tar -xvzf ./hadoop-$HADOOP_VERSION.tar.gz

# SPARK
ENV SPARK_VERSION 2.1.0 
ENV SPARK_HOME /home/sparker/spark-2.1.0-bin-hadoop2.7/
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin:${SPARK_HOME}/sbin 
# COPY spark-2.1.0-bin-hadoop2.7.tgz ./spark-2.1.0-bin-hadoop2.7.tgz
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz -q -O ./spark-2.1.0-bin-hadoop2.7.tgz  
RUN tar -xvzf ./spark-2.1.0-bin-hadoop2.7.tgz 

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/


# Copy start script 
COPY ./scripts/run_slave.sh ./run.sh
USER root 
RUN chmod +x /home/sparker/run.sh 
RUN echo "sparker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER sparker

COPY ./conf-slave/yarn-site.xml ./hadoop-$HADOOP_VERSION/etc/hadoop
COPY ./conf-slave/core-site.xml ./hadoop-$HADOOP_VERSION/etc/hadoop

ENTRYPOINT ./run.sh


# node manager ports
EXPOSE 8040 
EXPOSE 8042
EXPOSE 22
EXPOSE 8030
EXPOSE 8031
EXPOSE 8032
EXPOSE 8033
EXPOSE 8088
EXPOSE 10020
EXPOSE 19888