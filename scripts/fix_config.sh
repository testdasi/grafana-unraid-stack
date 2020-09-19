#!/bin/bash

mkdir -p /config/influxdb \
    && cp -n /temp/influxdb.conf /config/influxdb/
echo '[info] influxdb fixed.'

mkdir -p /config/hddtemp \
    && cp -n /temp/hddtemp.db /config/hddtemp/
echo '[info] hddtemp fixed.'

mkdir -p /config/telegraf/telegraf.d \
    && echo 'telegraf.conf TBC - still need to work on this'
echo '[info] telegraf fixed.'

mkdir -p /config/grafana/data/plugins \
    && mkdir -p /config/grafana/log \
    && mkdir -p /config/grafana/provisioning/dashboards \
    && mkdir -p /config/grafana/provisioning/datasources \
    && mkdir -p /config/grafana/provisioning/notifiers \
    && mkdir -p /config/grafana/provisioning/plugins \
    && cp -n /temp/grafana.ini /config/grafana/
echo '[info] grafana fixed.'


