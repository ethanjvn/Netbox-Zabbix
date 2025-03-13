# syntax=docker/dockerfile:1
FROM python:3.12-alpine
RUN apk add --no-cache bash curl dcron
RUN mkdir -p /opt/netbox-zabbix
COPY . /opt/netbox-zabbix
WORKDIR /opt/netbox-zabbix
RUN if ! [ -f ./config.py ]; then cp ./config.py.example ./config.py; fi
RUN pip install -r ./requirements.txt
ENTRYPOINT ["python"]
RUN echo "* * * * * python /opt/netbox-zabbix/netbox_zabbix_sync.py -v >> /var/log/cron.log 2>&1" > /etc/crontabs/root
CMD crond && tail -f /var/log/cron.log
