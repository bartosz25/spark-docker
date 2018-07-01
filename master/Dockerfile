# Get base image
FROM spark_base_image:latest

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
