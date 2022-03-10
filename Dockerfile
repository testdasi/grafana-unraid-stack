ARG FRM='testdasi/grafana-unraid-stack-base'
ARG TAG='latest'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

ENV USE_HDDTEMP no
ENV INFLUXDB_HTTP_PORT 8086
ENV INFLUXDB_RPC_PORT 58083
ENV LOKI_PORT 3100
ENV PROMTAIL_PORT 9086
ENV GRAFANA_PORT 3006

EXPOSE ${GRAFANA_PORT}/tcp \
    ${LOKI_PORT}/tcp \
    ${PROMTAIL_PORT}/tcp \
    ${INFLUXDB_HTTP_PORT}/tcp \
    ${INFLUXDB_RPC_PORT}/tcp

## build note ##
RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM}:${TAG}" >> /build.info

## install static codes ##
RUN rm -Rf /testdasi \
    && mkdir -p /temp \
    && cd /temp \
    && curl -sL "https://github.com/testdasi/static-ubuntu/archive/main.zip" -o /temp/temp.zip \
    && unzip /temp/temp.zip \
    && rm -f /temp/temp.zip \
    && mv /temp/static-ubuntu-main /testdasi \
    && rm -Rf /testdasi/deprecated

## execute execute execute ##
RUN /bin/bash /testdasi/scripts-install/install-grafana-unraid-stack.sh

## debug mode (comment to disable) ##
#RUN /bin/bash /testdasi/scripts-install/install-debug-mode.sh
#ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

## Final clean up ##
RUN rm -Rf /testdasi

## VEH ##
VOLUME ["/config"]
ENTRYPOINT ["tini", "--", "/static-ubuntu/grafana-unraid-stack/entrypoint.sh"]
HEALTHCHECK CMD /static-ubuntu/grafana-unraid-stack/healthcheck.sh
