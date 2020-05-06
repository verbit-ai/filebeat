#!/usr/bin/env sh
# we need "external" private instance IP as elasticsearch field
IP_ADDRESS=$(curl -qs http://169.254.169.254/latest/meta-data/local-ipv4)
EC2_INSTANCE_ID=$(curl -qs http://169.254.169.254/latest/meta-data/instance-id)
if  ! [[ ${IP_ADDRESS} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then
  IP_ADDRESS="0.0.0.0"
fi

FILEBEAT_VERSION="6.8.1"
if [ -z "$ES_INDEX_PREFIX" ];then
  # default elasticsearch index prefix
  ES_INDEX_PREFIX="filebeat"
fi

# check if provided filebeat config exists or not
if [ ! -f "/${FILEBEAT_YML}" ];then
  echo "Provided filebeat config /${FILEBEAT_YML} does not exists, switching to default one!"
  # default filebeat.yml
  FILEBEAT_YML="filebeat.yml"
fi

export IP_ADDRESS=${IP_ADDRESS}
export EC2_INSTANCE_ID=${EC2_INSTANCE_ID}
export ES_INDEX_PREFIX=${ES_INDEX_PREFIX}
export FILEBEAT_VERSION=${FILEBEAT_VERSION}

echo EC2_INSTANCE_ID $EC2_INSTANCE_ID IP_ADDRESS ${IP_ADDRESS} ES_INDEX_PREFIX ${ES_INDEX_PREFIX} FILEBEAT_VERSION ${FILEBEAT_VERSION} FILEBEAT_YML ${FILEBEAT_YML}
envsubst < /${FILEBEAT_YML} > /usr/share/filebeat/filebeat.yml
/usr/share/filebeat/filebeat -e -c /usr/share/filebeat/filebeat.yml
