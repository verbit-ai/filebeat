#!/usr/bin/env sh
# we need "external" private instance IP as elasticsearch field
IP_ADDRESS=$(curl -qs http://169.254.169.254/latest/meta-data/local-ipv4)
EC2_INSTANCE_ID=$(curl -qs http://169.254.169.254/latest/meta-data/instance-id)
if  ! [[ ${IP_ADDRESS} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then
  IP_ADDRESS="0.0.0.0"
fi
export IP_ADDRESS=${IP_ADDRESS}
export EC2_INSTANCE_ID=${EC2_INSTANCE_ID}
echo EC2_INSTANCE_ID $EC2_INSTANCE_ID IP_ADDRESS ${IP_ADDRESS}
envsubst < /filebeat.yml > /usr/share/filebeat/filebeat.yml
/usr/share/filebeat/filebeat -e -c /usr/share/filebeat/filebeat.yml
