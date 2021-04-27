#!/usr/bin/env sh
# we need "external" private instance IP as elasticsearch field
IP_ADDRESS=$(curl -qs http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IPV4=$(curl -qs http://169.254.169.254/latest/meta-data/public-ipv4)
EC2_INSTANCE_ID=$(curl -qs http://169.254.169.254/latest/meta-data/instance-id)
EC2_INSTANCE_TYPE=$(curl -qs http://169.254.169.254/latest/meta-data/instance-type)
if  ! [[ ${IP_ADDRESS} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then
  IP_ADDRESS="0.0.0.0"
fi

FILEBEAT_VERSION="6.8.1"

if [ -z "$ES_INDEX_PREFIX" ];then  # default elasticsearch index prefix
  ES_INDEX_PREFIX="filebeat"
fi

if [ -z "$ES_SSHD_INDEX_PREFIX" ];then  # default sshd index prefix
  ES_SSHD_INDEX_PREFIX="sshd"
fi

if [ "$ES_INDEX_PREFIX" = "filebeat" ];then  # add filebeat version to index prefix
  ES_INDEX_PREFIX="filebeat-${FILEBEAT_VERSION}"
fi

export IP_ADDRESS=${IP_ADDRESS}
export PUBLIC_IPV4=${PUBLIC_IPV4}
export EC2_INSTANCE_ID=${EC2_INSTANCE_ID}
export EC2_INSTANCE_TYPE=${EC2_INSTANCE_TYPE}
export ES_INDEX_PREFIX=${ES_INDEX_PREFIX}
export ES_SSHD_INDEX_PREFIX=${ES_SSHD_INDEX_PREFIX}
export FILEBEAT_VERSION=${FILEBEAT_VERSION}

echo EC2_INSTANCE_ID $EC2_INSTANCE_ID EC2_INSTANCE_TYPE $EC2_INSTANCE_TYPE IP_ADDRESS ${IP_ADDRESS} PUBLIC_IPV4 ${PUBLIC_IPV4} ES_INDEX_PREFIX ${ES_INDEX_PREFIX} FILEBEAT_VERSION ${FILEBEAT_VERSION}
envsubst < /filebeat.yml > /usr/share/filebeat/filebeat.yml
/usr/share/filebeat/filebeat -e -c /usr/share/filebeat/filebeat.yml
