ARG FRM='testdasi/grafana-unraid-stack-base'
ARG TAG='latest'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

ENV USE_HDDTEMP yes
ENV GRAFANA_PORT 3006
ENV LOKI_PORT 3106
ENV PROMTAIL_PORT 9086
ENV INFLUXDB_HTTP_PORT 8086
# ENV HDDTEMP_PORT 7634
# Telegraf does not expose any port

EXPOSE ${GRAFANA_PORT}/tcp \
    ${LOKI_PORT}/tcp \
    ${PROMTAIL_PORT}/tcp \
    ${INFLUXDB_HTTP_PORT}/tcp

# EXPOSE ${HDDTEMP_PORT}/tcp \

ADD config /temp
ADD scripts /

RUN /bin/bash /install.sh \
    && rm -f /install.sh

VOLUME ["/config"]

ENTRYPOINT ["/entrypoint.sh"]

RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info
