#!/bin/bash

# replace grafana service
rm -f /etc/init.d/grafana-server \
    && cp /temp/grafana-server /etc/init.d/ \
    && chmod +x /etc/init.d/grafana-server

# chmod scripts
chmod +x /*.sh
