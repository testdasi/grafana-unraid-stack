#!/bin/bash

### Fixing config files ###
echo ''
echo '[info] Fixing configs'
source /fix_config.sh
echo '[info] All configs fixed'

### Grafana ###
echo ''
echo "[info] Run grafana in background on port $GRAFANA_PORT"
service grafana-server start

### Infinite loop to stop docker from stopping ###
while true
do
    echo 'Running...'
    sleep 3600s
done
