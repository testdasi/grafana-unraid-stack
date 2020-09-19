#!/bin/bash

# replace grafana service
rm -f /etc/init.d/grafana-server \
    && cp /temp/grafana-server /etc/init.d/ \
    && chmod +x /etc/init.d/grafana-server

# replace influxdb service
rm -f /etc/init.d/influxdb \
    && cp /temp/influxdb /etc/init.d/ \
    && chmod +x /etc/init.d/influxdb

# chmod scripts
chmod +x /*.sh
