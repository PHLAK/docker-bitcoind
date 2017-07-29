FROM alpine:3.6
MAINTAINER Chris Kankiewicz <Chris@ChrisKankiewicz.com>

# Define Bitcoin version
ARG BTC_VERSION=0.14.1-r1

# Create non-root user
RUN adduser -Ds /sbin/nologin bitcoin

# Create Bitcoin directories
RUN mkdir -pv /vol/config /vol/data
RUN chown bitcoin:bitcoin /vol/config /vol/data

# Install bitcoin and dependencies
RUN apk add --update curl bitcoin=${BTC_VERSION} tzdata \
    && rm -rf /var/cache/apk/*

# Expose ports
EXPOSE 8332 8333 8333/udp

# Set running user
USER bitcoin

# Create volumes
VOLUME /vol/config /vol/data

# Set command
CMD ["bitcoind", "-conf=/vol/config/bitcoin.conf", "-datadir=/vol/data", \
    "-server", "-debug", "-printtoconsole"]
