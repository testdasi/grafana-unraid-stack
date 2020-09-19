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
    echo 'Running...'
    sleep 3600s
done
