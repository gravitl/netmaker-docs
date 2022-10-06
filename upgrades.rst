=====================================
Upgrades
=====================================

Introduction
===============

As of 0.13.0, upgrading Netmaker is a manual process. This is expected to be automated in the future, but for now, is still a relatively straightforward process. 

Critical Notes for 0.13.X
================================

If upgrading from 0.12 to 0.13, refer to this gist: https://gist.github.com/afeiszli/f53f34eb4c5654d4e16da2919540d0eb



Critical Notes for 0.10.0
=============================================

At the time of this writing, an upgrade process has not been defined for 0.10.0. DO NOT follow this documentation to upgrade from a prior version to 0.10.0. An upgrade process will be defined shortly. For now, if you seek to upgrade to 0.10.0, you must clear your server entirely (docker-compose down --volumes), uninstall your netclients, and re-install netmaker + netclients.

Upgrade the Server (prior to 0.10.0)
======================================

To upgrade the server, you only need to change the docker image versions:

1. `ssh root@my-server-ip`
2. `docker-compose down`
3. `vi docker-compose.yml`
4. Change gravitl/netmaker:<version> and gravitl/netmaker-ui:<version> to the new version.
5. Save and close the file
6. `docker-compose up -d`

Upgrade the server after v0.16.1
=================================

There have been changes to the MQ after v0.16.1. You will need to grab a new version of the docker-compose.yml and mosquitto.conf files.

Remember to save your master key so you can apply it to the new compose. You will also need to add a Mosquitto password to the file.

.. code-block::

    wget -O docker-compose.yml https://raw.githubusercontent.com/gravitl/netmaker/master/compose/docker-compose.yml
    wget -O /root/mosquitto.conf https://raw.githubusercontent.com/gravitl/netmaker/master/docker/mosquitto.conf
    sed -i 's/NETMAKER_BASE_DOMAIN/<your base domain>/g' docker-compose.yml
    sed -i 's/SERVER_PUBLIC_IP/<your server ip>/g' docker-compose.yml
    sed -i 's/YOUR_EMAIL/<your email>/g' docker-compose.yml
    sed -i 's/REPLACE_MASTER_KEY/<your generated key>/g' docker-compose.yml
    sed -i "s/REPLACE_MQ_ADMIN_PASSWORD/$MQ_ADMIN_PASSWORD/g" /root/docker-compose.yml

You will also need to get the wait.sh file and make sure it is executable

.. code-block::

    wget -q -O /root/wait.sh https://raw.githubusercontent.com/gravitl/netmaker/develop/docker/wait.sh
    chmod +x wait.sh

You should be all set to ``docker-compose down && docker-compose up -d`` 

Note: Your clients will show in warning until they are also upgraded.

Upgrade the Clients (prior to 0.10.0)
======================================

To upgrade the client, you must get the new client binary and place it in /etc/netclient. Depending on the new vs. old version, there may be minor incompatibilities (discussed below).

1. Visit https://github.com/gravitl/netmaker/releases/
2. Find the appropriate binary for your machine.
3. Download. E.x.: `wget https://github.com/gravitl/netmaker/releases/download/vX.X.X/netclient-myversion`
4. Rename binary to `netclient` and move to folder. E.x.: `mv netclient-myversion /etc/netclient/netclient`
5. `netclient --version` (confirm it's the correct version)
6. `netclient pull`

This last step helps ensure any newly added fields are now present. You may run into a "panic" based on missing fields and your version mismatch. In such cases, you can either:

1. Add the missing field to /etc/netclient/config/netconfig-yournetwork and then run "netclient checkin"

or

2. Leave and rejoin the network