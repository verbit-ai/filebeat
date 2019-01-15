FROM docker.elastic.co/beats/filebeat:6.5.4
USER root
COPY filebeat.yml root.pem /
RUN yum install -y gettext
CMD envsubst < /filebeat.yml > /usr/share/filebeat/filebeat.yml; /usr/share/filebeat/filebeat -c /usr/share/filebeat/filebeat.yml
