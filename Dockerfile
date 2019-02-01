FROM alpine:3.9
MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

# Define Bitcoin version
ARG BTC_VERSION=0.17.0.1
ARG APK_REVISION=r0

# Create non-root user
RUN adduser -Ds /sbin/nologin bitcoin

# Create Bitcoin directories
RUN mkdir -pv /vol/config /vol/data
RUN chown bitcoin:bitcoin /vol/config /vol/data

# Set rpcauth file URL
ARG RPCUSER_SCRIPT_URL=https://raw.githubusercontent.com/bitcoin/bitcoin/v${BTC_VERSION}/share/rpcauth/rpcauth.py

# Install bitcoin and dependencies
RUN apk add --update ca-certificates bitcoin=${BTC_VERSION}-${APK_REVISION} python tzdata wget \
    && wget ${RPCUSER_SCRIPT_URL} -O /usr/local/bin/rpcauth \
    && chmod +x /usr/local/bin/rpcauth \
    && apk del ca-certificates wget && rm -rf /var/cache/apk/* \
    && rm /etc/bitcoin.conf

# Expose ports
EXPOSE 8332 8333 8333/udp

# Set running user
USER bitcoin

# Create volumes
VOLUME /vol/config /vol/data

# Set command
CMD ["bitcoind", "-conf=/vol/config/bitcoin.conf", "-datadir=/vol/data", \
    "-server", "-debug", "-printtoconsole"]
