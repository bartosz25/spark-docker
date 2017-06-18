#!/bin/bash

function print_title {
  echo -e "\e[1;47;30m${1}\e[0m"
}

function print_build_step {
  echo -e "** \e[1m${1}\e[0m"
}

function print_execution_step { 
  echo "  >>>>>>>>>> ${1}"
}

# First, resolve IPs of slaves
SLAVES_NUMBER=$1
print_title "Configuring ${SLAVES_NUMBER} slave(s)"
slave_start_ip=21  
declare -a slaves=()
for (( index=1; index<=$SLAVES_NUMBER; index++ ))
do
  slave_host="spark-slave-${index}"
  slaves=("${slaves[@]}" "${slave_host}:172.18.0.${slave_start_ip}")  
  ((slave_start_ip++))
done

# Now, if rebuild is expected, recreate images for master and slaves
NEED_RECREATE=$2
MASTER_IMAGE_NAME="spark_yarn_master_image"
MASTER_CONTAINER_NAME="spark_yarn_master"
SLAVE_IMAGE_NAME="spark_yarn_slave_image"
if [ "$NEED_RECREATE" = "recreate" ]
then
  print_build_step "Recreating master and slave images"
  print_execution_step "Master:"
  source ./master/build_image.sh "$MASTER_IMAGE_NAME" "${PWD}/master" #> master_recreation.output
  print_execution_step "Slave:"
  source ./slave/build_image.sh "$SLAVE_IMAGE_NAME"  "${PWD}/slave" #> slave_recreation.output
fi

# Now, start all images
print_build_step "Starting master and slave images"
print_execution_step "Master:"
slaves_hosts=$(printf ",%s" "${slaves[@]}")
slaves_hosts=${slaves_hosts:1}
ADD_HOSTS_COMMAND=""
for slave in "${slaves[@]}"
do
  ADD_HOSTS_COMMAND="${ADD_HOSTS_COMMAND} --add-host=${slave}"
done

docker stop "$MASTER_CONTAINER_NAME";
docker rm "$MASTER_CONTAINER_NAME";
docker create -p 127.0.0.1:7077:7077 -p 127.0.0.1:8088:8088 -p 127.0.0.1:4040:4040 -p 127.0.0.1:18080:18080 --net spark-network --hostname spark-master --ip 172.18.0.20 -v "${PWD}"/shared-master:/home/sparker/shared $ADD_HOSTS_COMMAND --name "$MASTER_CONTAINER_NAME" "$MASTER_IMAGE_NAME" 

print_execution_step "Starting container ${MASTER_CONTAINER_NAME}"
docker start "$MASTER_CONTAINER_NAME"  

print_execution_step "Slaves:"
SLAVE_CONTAINER_BASE_NAME="spark_yarn_slave"
counter=0
for slave in "${slaves[@]}"
do
  counter=$((counter+1))
  public_ip=$((counter+7177))
  print_execution_step "Starting slave ${slave}"
  IFS=':' read -ra slave_config <<< $slave 
  SLAVE_CONTAINER_NAME="${SLAVE_CONTAINER_BASE_NAME}_${slave_config[0]}"
  docker stop "$SLAVE_CONTAINER_NAME";
  docker rm "$SLAVE_CONTAINER_NAME";
  docker create --hostname "${slave_config[0]}" -p "$public_ip":7177 --net spark-network --ip "${slave_config[1]}" --add-host="spark-master:172.18.0.20" $ADD_HOSTS_COMMAND  -v "${PWD}"/shared-slave:/home/sparker/shared --name "$SLAVE_CONTAINER_NAME" "$SLAVE_IMAGE_NAME"  
  docker start "$SLAVE_CONTAINER_NAME"
done