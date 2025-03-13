# syntax=docker/dockerfile:1
FROM python:3.12-alpine

# Installer cron et autres dépendances nécessaires
RUN apk add --no-cache bash openrc

# Copier les fichiers nécessaires dans le conteneur
COPY . /opt/netbox-zabbix
WORKDIR /opt/netbox-zabbix

# Copier le script et le fichier crontab
COPY run_program.sh /opt/netbox-zabbix/run_program.sh
COPY crontab.txt /etc/crontabs/root

# Donner les permissions d'exécution au script
RUN chmod +x /opt/netbox-zabbix/run_program.sh

# Installer les dépendances Python
RUN if ! [ -f ./config.py ]; then cp ./config.py.example ./config.py; fi
RUN pip install -r ./requirements.txt

# Démarrer cron et garder le conteneur en cours d'exécution
CMD ["sh", "-c", "crond -f && tail -f /dev/null"]