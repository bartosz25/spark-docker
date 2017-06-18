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
RUN apt-get -y install ssh
RUN apt-get -y install openssh-server
RUN apt-get -y install openssh-client
RUN apt-get -y install rsync
RUN apt-get update && \
      apt-get -y install sudo 

# Define new user
RUN useradd -ms /bin/bash sparker && echo "sparker:sparker" | chpasswd && adduser sparker sudo
USER sparker
WORKDIR /home/sparker

# Download Spark binary distribution with Hadoop
ENV HADOOP_VERSION 2.7.3
ENV HADOOP_HOME /home/sparker/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
RUN wget http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz  -q -O ./hadoop-$HADOOP_VERSION.tar.gz
# COPY hadoop-2.7.3.tar.gz ./hadoop-2.7.3.tar.gz
RUN tar -xvzf ./hadoop-$HADOOP_VERSION.tar.gz 
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" >> /home/sparker/hadoop-$HADOOP_VERSION/etc/hadoop/hadoop-env.sh 

# SPARK
ENV SPARK_VERSION 2.1.0 
ENV SPARK_HOME /home/sparker/spark-2.1.0-bin-hadoop2.7/
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin:${SPARK_HOME}/sbin 
# COPY spark-2.1.0-bin-hadoop2.7.tgz ./spark-2.1.0-bin-hadoop2.7.tgz
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz -q -O ./spark-2.1.0-bin-hadoop2.7.tgz  
RUN tar -xvzf ./spark-2.1.0-bin-hadoop2.7.tgz 
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/

# set the IP address Spark binds to on this node
RUN SPARK_LOCAL_IP="$(hostname --ip-address)"

# Copy start script 
COPY ./scripts/run_master.sh ./run.sh
USER root 
RUN chmod +x /home/sparker/run.sh 

RUN echo "sparker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER sparker

# Create SSH key for passwordless access
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys

COPY ./conf-master/core-site.xml ./hadoop-$HADOOP_VERSION/etc/hadoop
COPY ./conf-master/yarn-site.xml ./hadoop-$HADOOP_VERSION/etc/hadoop
COPY ./conf-master/spark-defaults.conf ./spark-2.1.0-bin-hadoop2.7/conf
RUN $HADOOP_HOME/bin/hdfs namenode -format

 
ENTRYPOINT ./run.sh 

# ssh
EXPOSE 22 
# YARN ports
EXPOSE 8030
EXPOSE 8031
EXPOSE 8032
EXPOSE 8033
EXPOSE 8088
EXPOSE 10020
EXPOSE 19888
