FROM alpine:3.6
MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

# Define Bitcoin version
ARG BTC_VERSION=0.14.1

# Create non-root user
RUN adduser -Ds /sbin/nologin bitcoin

# Create Bitcoin directories
RUN mkdir -pv /vol/config /vol/data
RUN chown bitcoin:bitcoin /vol/config /vol/data

# Set rpcuser file URL
ARG RPCUSER_SCRIPT_URL=https://raw.githubusercontent.com/bitcoin/bitcoin/v${BTC_VERSION}/share/rpcuser/rpcuser.py

# Install bitcoin and dependencies
RUN apk add --update ca-certificates bitcoin=${BTC_VERSION}-r1 python tzdata wget \
    && wget ${RPCUSER_SCRIPT_URL} -O /usr/local/bin/rpcuser \
    && chmod +x /usr/local/bin/rpcuser \
    && apk del ca-certificates wget && rm -rf /var/cache/apk/*

# Expose ports
EXPOSE 8332 8333 8333/udp

# Set running user
USER bitcoin

# Create volumes
VOLUME /vol/config /vol/data

# Set command
CMD ["bitcoind", "-conf=/vol/config/bitcoin.conf", "-datadir=/vol/data", \
    "-server", "-debug", "-printtoconsole"]
