#!/bin/bash

# The instructions to create this script were found at
# https://www.howtoforge.com/tutorial/how-to-install-prometheus-and-node-exporter-on-centos-7/
# Variables.
TMP=/tmp
SYSTEMD=/etc/systemd/system

#Check if sudo

if [ $(id -u) -eq 0 ]; then


# Configuring Prometheus
#useradd -m -s /bin/bash prometheus
#su - prometheus
	mv $TMP/prometheus-2.29.1.linux-amd64 /home/prometheus/prometheus
	touch $SYSTEMD/prometheus.service
	cat $TMP/sysconfig > $SYSTEMD/prometheus.service
	systemctl daemon-reload
	systemctl start prometheus
	systemctl enable prometheus
	firewall-cmd --add-port=9090/tcp --permanent
	firewall-cmd --reload

# Configuring node exporter.
	mv $TMP/node_exporter-1.2.2.linux-amd64 /home/prometheus/prometheus/node_exporter
	touch $SYSTEMD/node_exporter.service
	cat $TMP/node_exporter.service > $SYSTEMD/node_exporter.service
	systemctl daemon-reload
	systemctl start node_exporter
	systemctl enable node_exporter
	firewall-cmd --add-port=9100/tcp --permanent
	firewall-cmd --reload

# Configuring scraping tool.

	cat $TMP/scrape_config >> /home/prometheus/prometheus/prometheus.yml
	systemctl restart prometheus

else
	echo 'You must run this script with sudo privileges!'
	exit 1
fi
