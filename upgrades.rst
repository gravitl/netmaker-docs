=====================================
Upgrades
=====================================

Introduction
===============

These steps will help you upgrade to the latest version of Netmaker. Note that all instructions here assume you have installed using docker-compose. You may need to modify these steps depending on your setup. 

As of v0.20+, the server configuration is stable, meaning you should only need to:

1. Change the associated docker image tags for the Netmaker server and Netmaker UI  
2. Restart the server and UI using the new image (e.g. "docker-compose up -d")  

For migrating from v0.17.1, you can use the migration steps listed below under `Upgrade from v0.17.1 to Latest <https://docs.netmaker.io/upgrades.html#upgrade-from-v0-17-1-to-latest>`_  

For older versions of Netmaker (pre-v0.17.1), you must first manually upgrade to v0.17.1 before running the migration script.


Client Upgrades (General)
========================================

As of v0.20.5, the Netclient should automatically upgrade itself when it detects a change in the server version. For prior versions of the netclient (or if this fails), you will need to manually upgrade the client. 

**For Linux and Freebsd:** Download the netclient for your target version, OS, and arch, from  `the fileserver <https://fileserver.netmaker.io/releases/download>`_. Then run "./netclient install" from the downloaded executable in your terminal.  

**For Mac and Windows:** Download and run the installer (.MSI for Windows, .PKG for Mac) for your target version, OS, and arch, from `the fileserver <https://fileserver.netmaker.io/releases/download>`_. Then, run the installer.  

Server Upgrades (v0.20.0+)
========================================

Unless otherwise noted, for newer versions of Netmaker: 

1. SSH to the server hosting Netmaker  
2. Open the "netmaker.env" file using a text editor  
3. Change UI_IMAGE_TAG and SERVER_IMAGE_TAG to the latest version  
4. Run "docker-compose up -d"

  a. For versions prior to v0.20.5, follow the `Client Upgrades <https://docs.netmaker.io/upgrades.html##client-upgrades-general>`_ instructions to upgrade your netclients. 
  b. For v0.20.5 or later, check in the UI to confirm that all hosts have successfully upgraded to the new version.

test line 

Upgrade to latest from v0.17.1
================================

These steps assume you have already upgraded your server and netclients to v0.17.1.

General Notes
-----------------

1. The server should be upgraded before any clients.  
2. Relays will need to be recreated after the server and all clients are upgraded. Relays are now only available on Pro.
3. If upgrading to Pro, a new license key and tennet id must be obtained from https://app.netmaker.io
4. As each netclient is updated, a new host, nodes, and gateways (if applicable) will be visible in the netmaker UI.
5. Extclient config files may have to be regenerated after the upgrade.

Steps
--------

1. Download the nm-upgrade.sh script from https://fileserver.netmaker.io/upgrade/nm-upgrade.sh
2. Make the script executable and run it. 
3. After the upgrade, you should see only one host in the Netmaker UI. It will have the same name as the hostname of your server, rather than netmaker-1.
4. Upgrade your netclients
   *do not use packages to upgrade on window/darwin, use the netclient binary to update*

  a. Linux/Freebsd/Darwin: On each client download `the latest version <https://fileserver.netmaker.io/latest>`_ of netclient and run the `netclient install` command 
  b. Windows: On each client download `the latest version <https://fileserver.netmaker.io/latest>`_ of netclient-windows-amd64.exe 
      open Powershell window as Administrator and run the following commands: 
      ``net stop netclient``
      ``c:\\Users\User\Downloads\netclient-windows-amd64.exe install``

5. As each netclient is updated, check that a new host, nodes, and gateways (if applicable) are visible in the Netmaker UI.
6. If upgrading to Pro, recreate any relay gateways
7. Verify extcient config files are correct. Delete and regenerate if incorrect. For each peer in config file:

  a. the peer's public key should be the same as the peer's public key in the netmaker UI

  b. the peer's endpoint should be the same as the peer's endpoint in the netmaker UI

  c. the peer's allowed ips should be the same as the peer's allowed ips in the netmaker UI

Your Netmaker server and clients should all now be running the latest version of Netmaker.

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

Upgrade the server to use 0.17.0 after Upgrading for 0.16.3
============================================================

Version 0.17.0 uses Caddy instead of traefik.

Open a Terminal window (shell prompt).  To set up Caddy you'll need to configure the Caddyfile as follows.

If you are using the Community Edition of Netmaker use this command:

.. code-block::

	wget -O /root/Caddyfile "https://raw.githubusercontent.com/gravitl/netmaker/master/docker/Caddyfile"


If you are using the Professional Edition of Netmaker use this command:

.. code-block::

	wget -O /root/Caddyfile "https://raw.githubusercontent.com/gravitl/netmaker/master/docker/Caddyfile-pro"



Once you have a Caddyfile you'll need to run these two commands:

.. code-block::

  sed -i "s/NETMAKER_BASE_DOMAIN/$NETMAKER_BASE_DOMAIN/g" /root/Caddyfile
  sed -i "s/YOUR_EMAIL/$EMAIL/g" /root/Caddyfile

Where $NETMAKER_BASE_DOMAIN is the base domain you used for your Netmaker setup (the part after "dashboard." in your Dockerfile) and $YOUR_EMAIL is your email address.

If users still want to keep using Traefik as the reverse-proxy instead of Caddy for v0.17.0 and above, refer to this docker-compose file https://gist.github.com/alphadose/1602e5dcba500f75ab0b873d4441236b

Edit the above docker-compose file

.. code-block::

  sed -i 's/NETMAKER_BASE_DOMAIN/<your base domain>/g' docker-compose.yml
  sed -i 's/SERVER_PUBLIC_IP/<your server ip>/g' docker-compose.yml
  sed -i 's/REPLACE_MASTER_KEY/<your generated key>/g' docker-compose.yml
  sed -i "s/REPLACE_MQ_ADMIN_PASSWORD/<your generated password>/g" docker-compose.yml

After that finally start the netmaker server

.. code-block::

  sudo docker-compose up -d

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
