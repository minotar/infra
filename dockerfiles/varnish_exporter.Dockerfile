FROM alpine:3.14

RUN apk add --no-cache libc6-compat

ENV EXPORTER_VERSION=1.6.1

RUN addgroup -g 101 -S varnish && \
    adduser -u 101 -S varnish -G varnish
RUN mkdir /exporter && \
    chown varnish:varnish /exporter

ADD https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/${EXPORTER_VERSION}/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz /tmp

RUN tar -C /tmp -xzf /tmp/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz && \
    mv /tmp/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64/prometheus_varnish_exporter /exporter/prometheus_varnish_exporter && \
    chown varnish /exporter/prometheus_varnish_exporter && \
    rm -Rf /tmp/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64

ENTRYPOINT ["/exporter/prometheus_varnish_exporter"]
