docker-bitcoind
===============

Docker image for [Bitcoin](https://bitcoin.org) daemon.

[![](https://images.microbadger.com/badges/image/phlak/bitcoind.svg)](http://microbadger.com/#/images/phlak/bitcoind "Get your own image badge on microbadger.com")

Running the Container
---------------------

First create some named data volumes to hold the persistent data:

    docker volume create --name bitcoind-config
    docker volume create --name bitcoind-data

Now you must create your `bitcoin.conf` file. First you will need to generate an
rpcauth string:

    docker run -it --rm phlak/bitcoind rpcauth <user>

**NOTE:** Replace `<user>` with your desired username.

The output of this command will be used in your configuration file. Create the
configuration file with the following:

    docker run -it --rm -v bitcoind-config:/vol/config phlak/bitcoind vi /vol/config/bitcoin.conf

Use the following template for your configuration:

    # Username and hashed password for JSON-RPC connections.
    # Use the rpcauth string returned from the the command above.
    rpcauth=<rpcauth_string>

    # Allow JSON-RPC connections from specified source. Valid values are a
    # single IP (1.2.3.4), a network/netmask (1.2.3.4/255.255.255.0) or a
    # network/CIDR (e.g. 1.2.3.4/24). This option can be set multiple times
    rpcallowip=127.0.0.1
    rpcallowip=<ip>

    # Reduce storage requirements by enabling pruning (deleting) of old blocks.
    # This allows the pruneblockchain RPC to be called to delete specific blocks,
    # and enables automatic pruning of old blocks if a target size in MiB is
    # provided. This mode is incompatible with -txindex and -rescan.
    # Warning: Reverting this setting requires re-downloading the entire blockchain.
    # (default: 0 = disabled, 1 = allow manual pruning via RPC, >550 = automatically
    # prune block files to stay under the specified target size in MiB)
    prune=1000

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
