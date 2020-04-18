FROM docker.elastic.co/beats/filebeat:6.8.1
USER root
RUN yum install -y gettext
COPY filebeat.yml root.pem *.sh /
CMD [ "/docker-entrypoint.sh" ]
