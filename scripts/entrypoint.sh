#!/bin/bash

### Fixing config files ###
echo ''
echo '[info] Fixing configs'
source /fix_config.sh
echo '[info] All configs fixed'

### Influxdb ###
echo ''
echo "[info] Run influxdb as service on port $INFLUXDB_HTTP_PORT"
service influxdb start

### Loki ###
echo ''
echo "[info] Run loki as daemon on port $LOKI_PORT"
start-stop-daemon --start -b --exec /usr/sbin/loki -- -config.file=/config/loki/loki-local-config.yaml

### HDDTemp ###
echo ''
echo "[info] Run hddtemp in background on port $HDDTEMP_PORT"
hddtemp --quiet --daemon --file=/config/hddtemp/hddtemp.db --listen='127.0.0.1' --port=$HDDTEMP_PORT /rootfs/dev/disk/by-id/ata*

### Telegraf ###
echo ''
echo "[info] Run telegraf as service"
service telegraf start

### HDDTemp ###
echo ''
echo "[info] Run promtail in background on port $PROMTAIL_PORT"
start-stop-daemon --start -b --exec /usr/sbin/promtail -- -config.file=/config/promtail/promtail.yml

### Grafana ###
echo ''
echo "[info] Run grafana as service on port $GRAFANA_PORT"
service grafana-server start

### Infinite loop to stop docker from stopping ###
while true
do
    echo 'All your base are belong to us...'
    sleep 3600s
done
