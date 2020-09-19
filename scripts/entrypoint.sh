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

### HDDTemp ###
echo ''
echo "[info] Run hddtemp in background on port $HDDTEMP_PORT"
hddtemp --quiet --daemon --file=/config/hddtemp/hddtemp.db --listen='127.0.0.1' --port=$HDDTEMP_PORT /rootfs/dev/disk/by-id/ata*

### Telegraf ###
echo ''
echo "[info] Run telegraf as service"
service telegraf start

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
