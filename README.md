# Grafana-Unraid-Stack
Meet Gus! He has everything you need to start monitoring Unraid (Grafana - Influxdb - Telegraf - Loki - Promtail).

A sleek made-for-Unraid dashboard is pre-installed.
![Preview](https://raw.githubusercontent.com/testdasi/grafana-unraid-stack-base/master/grafana-unraid-stack-screen.png)

## High-level instructions
* Decide whether you want hddtemp or S.M.A.R.T (smartmontools) and set USE_HDDTEMP variable accordingly
* Install docker with host network
* Go to ip:3006 to access grafana, login with admin/admin and make changes to the default dashboard.

## Key features
1. Grafana server. Include a default made-for-Unraid dashboard just waiting for your customisation.
1. Influxdb
1. Telegraf with hddtemp or smartmontools (and ipmitool pre-installed)
1. Loki + Promtail (so you can now watch your Unraid syslog in the dashboard)

## Bits and bobs
* Use port 3006 because grafana default port 3000 is rather popular among other apps
* I highly recommend you don't change the port variables unless you know how to deal with various config files. Things are rather tightly integrated.
* Should be run on "Host" network for max exposure to the server network metrics. You can use bridge if you don't care too much about host network reporting (but remember to map port 3006)
* Data is separated from config so, for example, you can have the data in RAM so it gets reset after reboot.

## Usage
    docker run -d \
        --name=<container name> \
        --net='host' \
        -v <host path for config>:/config \
        -v <host path for data>:/data \
        -e USE_HDDTEMP=no \
        -e INFLUXDB_HTTP_PORT=8086 \
        -e LOKI_PORT=3100 \
        -e PROMTAIL_PORT=9086 \
        -e GRAFANA_PORT=3006 \
        -v /var/run/utmp:/var/run/utmp \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /:/rootfs \
        -v /sys:/rootfs/sys \
        -v /etc:/rootfs/etc \
        -v /proc:/rootfs/proc \
        -e HOST_PROC=/rootfs/proc \
        -e HOST_SYS=/rootfs/sys \
        -e HOST_ETC=/rootfs/etc \
        -e HOST_MOUNT_PREFIX=/rootfs \
        testdasi/grafana-unraid-stack:<tag>

## Unraid example
    docker run -d \
        --name='OpenVPN-HyDeSa' \
        --net='bridge' \
        --cap-add=NET_ADMIN \
        -v '/mnt/user/appdata/openvpn-hyrosa':'/config':'rw' \
        -v '/mnt/user/downloads/':'/data':'rw' \
        -e 'DNS_SERVERS'='127.2.2.2' \
        -e 'HOST_NETWORK'='192.168.1.0/24' \
        -e 'SERVER_IP'='192.168.1.2' \
        -p '8000:8000/tcp' \
        -p '8153:53/tcp' \
        -p '8153:53/udp' \
        -p '9118:9118/tcp' \
        -p '8118:8118/tcp' \
        -p '8080:8080/tcp' \
        -p '8090:8090/tcp' \
        -p '3000:3000/tcp' \
        -p '5076:5076/tcp' \
        -e 'LAUNCHER_GUI_PORT'='8000' \
        -e 'DNS_SERVER_PORT'='53' \
        -e 'SOCKS_PROXY_PORT'='9118' \
        -e 'HTTP_PROXY_PORT'='8118' \
        -e 'USENET_HTTP_PORT'='8080' \
        -e 'USENET_HTTPS_PORT'='8090' \
        -e 'TORRENT_GUI_PORT'='3000' \
        -e 'SEARCHER_GUI_PORT'='5076' \
        -e 'LANG'='en_GB.UTF-8' \
        -e TZ="Europe/London" \
        -e HOST_OS="Unraid" \
        'testdasi/openvpn-hyrosa:stable-amd64' 

## Notes
* I code for fun and my personal uses; hence, these niche functionalties that nobody asks for. ;)
* If you like my work, [a donation to my burger fund](https://paypal.me/mersenne) is very much appreciated.

[![Donate](https://raw.githubusercontent.com/testdasi/testdasi-unraid-repo/master/donate-button-small.png)](https://paypal.me/mersenne). 
