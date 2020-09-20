#!/bin/bash

mkdir -p /config/influxdb \
    && mkdir -p /data/influxdb/data \
    && mkdir -p /data/influxdb/meta \
    && mkdir -p /data/influxdb/wal \
    && rm -f /config/influxdb/influxd.pid \
    && cp -n /temp/influxdb.conf /config/influxdb/
echo '[info] influxdb fixed.'

mkdir -p /config/loki \
    && mkdir -p /data/loki/chunks \
    && mkdir -p /data/loki/index \
    && cp -n /temp/loki-local-config.yaml /config/loki/
echo '[info] loki fixed.'

mkdir -p /config/hddtemp \
    && cp -n /temp/hddtemp.db /config/hddtemp/
echo '[info] hddtemp fixed.'

mkdir -p /config/telegraf/telegraf.d \
    && rm -f /config/telegraf/telegraf.pid \
    && cp -n /temp/telegraf.conf /config/telegraf/
echo '[info] telegraf fixed.'

mkdir -p /config/promtail \
    && mkdir -p /data/promtail \
    && cp -n /temp/promtail.yml /config/promtail/
echo '[info] promtail fixed.'

mkdir -p /config/grafana/data/plugins \
    && mkdir -p /config/grafana/log \
    && mkdir -p /config/grafana/provisioning/dashboards \
    && mkdir -p /config/grafana/provisioning/datasources \
    && mkdir -p /config/grafana/provisioning/notifiers \
    && mkdir -p /config/grafana/provisioning/plugins \
    && rm -f /config/grafana/grafana-server.pid \
    && cp -n /temp/grafana.ini /config/grafana/
echo '[info] grafana fixed.'
