# syntax=docker/dockerfile:1
FROM python:3.12-alpine
RUN apk add --no-cache bash busybox-suid openrc && \
    rc-update add crond && \
    mkdir -p /opt/netbox-zabbix
COPY . /opt/netbox-zabbix
WORKDIR /opt/netbox-zabbix
COPY run_program.sh /opt/netbox-zabbix/run_program.sh
COPY crontab.txt /etc/crontabs/root
RUN chmod +x /opt/netbox-zabbix/run_program.sh
RUN if ! [ -f ./config.py ]; then cp ./config.py.example ./config.py; fi
RUN pip install -r ./requirements.txt
CMD crond -f