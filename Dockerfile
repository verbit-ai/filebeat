FROM docker.elastic.co/beats/filebeat:6.8.1
USER root
COPY filebeat.yml root.pem /
RUN yum install -y gettext
CMD envsubst < /filebeat.yml > /usr/share/filebeat/filebeat.yml; /usr/share/filebeat/filebeat -e -c /usr/share/filebeat/filebeat.yml
