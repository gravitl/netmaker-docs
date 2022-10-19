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

There have been changes to the MQ after v0.16.1. You will need to make changes to the docker-compose.yml and get the new mosquitto.conf files. We recommend upgrading your server first before any clients.

Start by shutting down your server with ``docker-compose down``

You then need to get the updated mosquitto.conf file. You will also need to get the wait.sh file and make sure it is executable.

.. code-block::

    wget -O /root/mosquitto.conf https://raw.githubusercontent.com/gravitl/netmaker/master/docker/mosquitto.conf
    wget -q -O /root/wait.sh https://raw.githubusercontent.com/gravitl/netmaker/develop/docker/wait.sh
    chmod +x wait.sh

Then make the following changes to the docker-compose.yml file.

1. change image tags in netmaker and netmaker-ui service sections to ``gravitl/netmaker:v.0.16.1``.

2. In your netmaker service section:
    a. In the volumes section, change ``- shared_certs:/etc/netmaker`` to ``- mosquitto_data:/etc/netmaker``

    b. In the environment section, add ``MQ_ADMIN_PASSWORD: "<CHOOSE_A_PASSWORD_YOU_WOULD_LIKE_TO_USE>"``


3. In the mq service section:
    a. Add ``command: ["/mosquitto/config/wait.sh"]``

    b. Add an environment section and add ``NETMAKER_SERVER_HOST: "https://api.NETMAKER_BASE_DOMAIN"``

    c. In the volumes, add ``- /root/wait.sh:/mosquitto/config/wait.sh``

    d. You need to make some changes to the labels. a few of them just need ``mqtts`` to be ``mqtt``. The labels should look like this:

    .. code-block::

        - traefik.enable=true
        - traefik.tcp.routers.mqtt.rule=HostSNI(`broker.NETMAKER_BASE_DOMAIN`)
        - traefik.tcp.routers.mqtt.tls.certresolver=http
      	- traefik.tcp.services.mqtt.loadbalancer.server.port=8883
      	- traefik.tcp.routers.mqtt.entrypoints=websecure

Your MQ section should look like this after the changes.

.. code-block:: yaml

    mq:
    container_name: mq
    image: eclipse-mosquitto:2.0.11-openssl
    depends_on:
      - netmaker
    restart: unless-stopped
    command: ["/mosquitto/config/wait.sh"]
    environment:
      NETMAKER_SERVER_HOST: "https://api.NETMAKER_BASE_DOMAIN"
    volumes:
      - /root/mosquitto.conf:/mosquitto/config/mosquitto.conf
      - /root/wait.sh:/mosquitto/config/wait.sh
      - mosquitto_data:/mosquitto/data
      - mosquitto_logs:/mosquitto/log
    expose:
      - "8883"
    labels:
      - traefik.enable=true
      - traefik.tcp.routers.mqtt.rule=HostSNI(`broker.NETMAKER_BASE_DOMAIN`)
      - traefik.tcp.routers.mqtt.tls.certresolver=http
      - traefik.tcp.services.mqtt.loadbalancer.server.port=8883
      - traefik.tcp.routers.mqtt.entrypoints=websecure

      
You should be all set to ``docker-compose up -d`` 

Note: Your clients will show in warning until they are also upgraded. The upgrade for clients is the regular upgrade, then do a ``netclient pull``

Your ``docker logs mq`` should be showing logs like this:

.. code-block::


	Waiting for netmaker server to startup

	Waiting for netmaker server to startup

	Waiting for netmaker server to startup

	Waiting for netmaker server to startup

	Waiting for netmaker server to startup

	Waiting for netmaker server to startup

	Waiting for netmaker server to startup

	Starting MQ...

	1665067766: mosquitto version 2.0.11 starting

	1665067766: Config loaded from /mosquitto/config/mosquitto.conf.

	1665067766: Loading plugin: /usr/lib/mosquitto_dynamic_security.so

	1665067766: Opening ipv4 listen socket on port 8883.

	1665067766: Opening ipv6 listen socket on port 8883.

	1665067766: Opening ipv4 listen socket on port 1883.

	1665067766: Opening ipv6 listen socket on port 1883.

	1665067766: mosquitto version 2.0.11 running

	1665067769: New connection from 172.21.0.2:34004 on port 1883.

	1665067769: New client connected from 172.21.0.2:34004 as L0vUDgN0IZFru9VaS6HoRL5 (p2, c1, k60, u'Netmaker-Admin').

	1665067769: New connection from 172.21.0.2:34006 on port 1883.

	1665067769: New client connected from 172.21.0.2:34006 as ydmOjmIcw9nNaT1GB1q97Se (p2, c1, k60, u'Netmaker-Server').

If you see mq logs about waiting for netmaker server to startup after longer period than usual, check if your traefik certs are generated correctly. You can try to resolve with ``docker restart traefik``


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