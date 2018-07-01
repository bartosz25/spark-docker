# Get base image
FROM spark_base_image:latest

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
