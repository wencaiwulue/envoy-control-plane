FROM envoyproxy/envoy:v1.21.0

RUN sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && apt-get update && apt-get install -y wget dnsutils vim curl net-tools iptables iputils-ping lsof iproute2 tcpdump

COPY envoy.yaml /etc/envoy/envoy.yaml
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
COPY iptables.sh /
RUN chmod +x /iptables.sh