# Stage 0: Build
FROM debian:9-slim

RUN apt-get update
RUN apt-get install -y \
    git curl build-essential libssl-dev zlib1g-dev
ENV COMMIT=2c942119c4ee340c80922ba11d14fb3b10d5e654
RUN git clone https://github.com/TelegramMessenger/MTProxy
RUN cd MTProxy && git checkout $COMMIT && make && cd objs/bin

# Stage 1: Runtime
FROM debian:9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl ca-certificates iproute2 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt

COPY --from=0 /MTProxy/objs/bin/mtproto-proxy /bin

COPY run.sh /
RUN chmod +x /run.sh
RUN chmod +x /bin/mtproto-proxy

EXPOSE 443 8888
VOLUME /data
WORKDIR /data
ENTRYPOINT /run.sh

#CMD /run.sh
