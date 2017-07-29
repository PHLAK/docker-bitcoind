docker-bitcoind
===============

Docker image for [Bitcoin](https://bitcoin.org) daemon.

[![](https://images.microbadger.com/badges/image/phlak/bitcoind.svg)](http://microbadger.com/#/images/phlak/bitcoind "Get your own image badge on microbadger.com")

Running the Container
---------------------

First create some named data volumes to hold the persistent data:

    docker volume create --name bitcoind-config
    docker volume create --name bitcoind-data

Next you must create your `bitcoin.conf` file:

    docker run -it --rm -v bitcoind-config:/vol/config phlak/bitcoind vi /vol/config/bitcoin.conf

Use the following template for your configuration:

    # Username for JSON-RPC connections
    rpcuser=<user>

    # Password for JSON-RPC connections
    rpcpassword=<pass>

    # Allow JSON-RPC connections from specified source. Valid values are a
    # single IP (1.2.3.4), a network/netmask (1.2.3.4/255.255.255.0) or a
    # network/CIDR (e.g. 1.2.3.4/24). This option can be set multiple times
    rpcallowip=127.0.0.1
    rpcallowip=<ip>

Then run the Bitcoin daemon:

    docker run -d -p 8332:8332 -p 8333:8333 -p 8333:8333/udp -v bitcoind-config:/vol/config -v bitcoind-data:/vol/data --name bitcoind phlak/bitcoind

#### Optional arguments

`-e TZ=America/Phoenix` - Set the timezone for your server. You can find your timezone in this
                          [list of timezones](https://goo.gl/uy1J6q). Use the (case sensitive)
                          value from the `TZ` column. If left unset, timezone will be UTC.

`--restart unless-stopped` - Always restart the container regardless of the exit status, but do not
                             start it on daemon startup if the container has been put to a stopped
                             state before. See the Docker [restart policies](https://goo.gl/OI87rA)
                             for additional details.

Troubleshooting
---------------

Please report bugs to the [GitHub Issue Tracker](https://github.com/PHLAK/docker-bitcoind/issues).

Copyright
---------

This project is licensed under the [MIT License](https://github.com/PHLAK/docker-bitcoind/blob/master/LICENSE).
