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

### HDDTemp if USE_HDDTEMP is yes ###
if [[ $USE_HDDTEMP =~ "yes" ]]
then
    echo ''
    echo "[info] Running hddtemp as daemon due to USE_HDDTEMP set to $USE_HDDTEMP"
    hddtemp --quiet --daemon --file=/config/hddtemp/hddtemp.db --listen='127.0.0.1' --port=7634 /rootfs/dev/disk/by-id/ata*
else
    echo "[info] Skip running hddtemp due to USE_HDDTEMP set to $USE_HDDTEMP"
fi

### Telegraf ###
echo ''
echo "[info] Run telegraf as service"
service telegraf start

### Promtail ###
echo ''
echo "[info] Run promtail as daemon on port $PROMTAIL_PORT"
start-stop-daemon --start -b --exec /usr/sbin/promtail -- -config.file=/config/promtail/promtail.yml

### Grafana ###
echo ''
echo "[info] Run grafana as service on port $GRAFANA_PORT"
service grafana-server start

### Infinite loop to stop docker from stopping ###
sleep_time=10
crashed=0
while true
do
    echo ''
    echo "[info] Wait $sleep_time seconds before next healthcheck..."
    sleep $sleep_time
    
    pidlist=$(pidof influxd)
    if [ -z "$pidlist" ]
    then
        echo '[warn] influxdb crashed, restarting'
        crashed=$(( $crashed + 1 ))
        service influxdb start
    else
        echo "[info] influxdb PID: $pidlist"
    fi
    
    pidlist=$(pidof loki)
    if [ -z "$pidlist" ]
    then
        echo '[warn] loki crashed, restarting'
        crashed=$(( $crashed + 1 ))
        start-stop-daemon --start -b --exec /usr/sbin/loki -- -config.file=/config/loki/loki-local-config.yaml
    else
        echo "[info] loki PID: $pidlist"
    fi
    if [[ $USE_HDDTEMP =~ "yes" ]]
    then
        pidlist=$(pidof hddtemp)
        if [ -z "$pidlist" ]
        then
            echo '[warn] hddtemp crashed, restarting'
            crashed=$(( $crashed + 1 ))
            hddtemp --quiet --daemon --file=/config/hddtemp/hddtemp.db --listen='127.0.0.1' --port=7634 /rootfs/dev/disk/by-id/ata*
        else
            echo "[info] hddtemp PID: $pidlist"
        fi
    else
        echo "[info] Skip hddtemp healthcheck due to USE_HDDTEMP set to $USE_HDDTEMP"
    fi
    
    pidlist=$(pidof telegraf)
    if [ -z "$pidlist" ]
    then
        echo '[warn] telegraf crashed, restarting'
        crashed=$(( $crashed + 1 ))
        service telegraf start
    else
        echo "[info] telegraf PID: $pidlist"
    fi
    
    pidlist=$(pidof promtail)
    if [ -z "$pidlist" ]
    then
        echo '[warn] promtail crashed, restarting'
        crashed=$(( $crashed + 1 ))
        start-stop-daemon --start -b --exec /usr/sbin/promtail -- -config.file=/config/promtail/promtail.yml
    else
        echo "[info] promtail PID: $pidlist"
    fi
    
    pidlist=$(pidof grafana-server)
    if [ -z "$pidlist" ]
    then
        echo '[warn] grafana crashed, restarting'
        crashed=$(( $crashed + 1 ))
        service grafana-server start
    else
        echo "[info] grafana PID: $pidlist"
    fi
    
    # reset wait time if something crashed, otherwise double the wait time till next healthcheck
    if (( $crashed > 0 ))
    then
        sleep_time=$(( $crashed * 10 ))
        crashed=0
    else
        sleep_time=$(( $sleep_time * 2 ))
        # restrict wait time to within 3600s i.e. 1hr
        if (( $sleep_time > 3600 ))
        then
            sleep_time=3600
        fi
    fi
done
