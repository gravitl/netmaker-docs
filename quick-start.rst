===============
Quick Install
===============

Important Notes
============================

1. **WE RECOMMEND USING THE NM-QUICK SCRIPT INSTEAD OF THIS GUIDE. Our docker-compose files have changed sizeably and the install script now uses a different process to obtain certificates. The script can be found** `on GitHub <https://github.com/gravitl/netmaker#get-started-in-5-minutes>`_ **(raw script** `here <https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/nm-quick.sh>`_ **). If you would like to install netmaker manually, You can use the instructions below.**

2. Due to the high volume of installations, the auto-generated domain has been rate-limited by the certificate provider. For this reason, we **strongly recommend** using your own domain. Using the auto-generated domain may lead to a failed installation due to rate limiting.

3. This guide is just a manual version of the steps performed by that script, and is therefore more prone to error.

4. You must decide if you are installing the Pro version of Netmaker or the Community version. We recommend Pro because of its substantial free limits, but it does require `an account <https://app.netmaker.io>`_.

5. If deploying to DigitalOcean, you should use the `DigitalOcean 1-Click <https://marketplace.digitalocean.com/apps/netmaker>`_, which uses the interactive script.

6. This instance will not be HA. However, it should comfortably handle 100+ concurrent clients and support the most common use cases.

7. For information about deploying more advanced configurations, see the :doc:`Advanced Installation <./server-installation>` docs. 

0. Prerequisites
==================

Server
-----------------

All components of Netmaker can be run on a single server (Virtual Machine or Bare Metal). Here some recommendations for setting up the server:

- We **highly recommend** that Netmaker be deployed in a dedicated networking environment. It should not share a local network with the clients which it will be managing. This can cause routing issues.
- The machine should have a public, static IP address 
- The machine should have at least 1GB RAM and 1 CPU (2GB RAM preferred for production installs)
- 2GB+ of storage 
- Ubuntu 21.04 Installed
  
If you do not have a host for this server, here are some recommendations:

- `DigitalOcean (preferred) <https://marketplace.digitalocean.com/apps/netmaker>`_
- `Linode <https://www.linode.com>`_
- `KeepSec <https://www.keepsec.ca>`_
- `AWS <https://aws.amazon.com>`_
- `Azure <https://azure.microsoft.com>`_
- `GCP <https://cloud.google.com>`_
- We **do not** recommend Oracle Cloud. There are known issues with their network configuration.
  
Domain
--------

Your server will host several services (netmaker server, UI, etc.) each of which requires a dedicated, public subdomain. Here are some recommendations:

- Use a publicly owned domain (e.x. example.com, mysite.biz)
- Designate a subdomain (e.g. netmaker.example.com) for netmaker's services (e.g. dashboard.netmaker.example.com) 
- Make sure you have permission and access to modify DNS records for your domain (e.x: Route53)
- **Note on Cloudflare:** Many of our users use Cloudflare for DNS. Cloudflare has limitations on subdomains you must be aware of, which can cause issues once Netmaker is deployed. Cloudflare will also proxy connections, which MQ does not like. This can be disabled in the Cloudflare dashboard. If setting up your Netmaker server using Cloudflare for DNS, be aware that the configuration of Cloudflare may cause problems with Netmaker which must be resolved, and at this point, Netmaker is not providing guidance on this setup.

1. Prepare DNS
================

Create a wildcard A record pointing to the public IP of your VM. As an example, \*.netmaker.example.com. Alternatively, create records for these specific subdomains:

- dashboard.domain

- api.domain

- broker.domain

If deploying Pro, you will also need records for the following:IsStatic

- grafana.domain

- prometheus.domain

- netmaker-exporter.domain


2. Install Dependencies
========================

.. code-block::

  ssh root@your-host
  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose 

At this point you should have all the system dependencies you need.
 
3. Open Firewall
===============================

Make sure firewall settings are set for Netmaker both on the VM and with your cloud security groups (AWS, GCP, etc). 

Make sure the following ports are open both on the VM and in the cloud security groups:

- **443, 80 (tcp):** for Caddy, which proxies the Dashboard (UI), REST API (Netmaker Server), and Broker (MQTT)  
- **51821-518XX (udp):** for WireGuard - Netmaker needs one port per network, starting with 51821, so open up a range depending on the number of networks you plan on having. For instance, 51821-51830.  
- **8085 (exporter Pro):** If you are building a Pro server, you need this port open.
- **1883, 8883 8083, 18083 (if using EMQX):** We use two different types of brokers. There is Mosquitto or EMQX. if you are setting up EMQX, these four need to be open for MQTT, SSL MQTT, web sockets, and the EMQX dashbaord/REST api.


.. code-block::

  sudo ufw allow proto tcp from any to any port 443 
  sudo ufw allow proto tcp from any to any port 80 
  sudo ufw allow proto tcp from any to any port 3479
  sudo ufw allow proto tcp from any to any port 8089 
  sudo ufw allow 51821:51830/udp
  

It is also important to make sure the server does not block forwarding traffic (it will do this by default on some providers). To ensure traffic will be forwarded:

.. code-block::

  iptables --policy FORWARD ACCEPT


**Again, based on your cloud provider, you may additionally need to set inbound security rules for your server (for instance, on AWS). This will be dependent on your cloud provider. Be sure to check before moving on:**
  - allow 443/tcp from all
  - allow 80/tcp from all
  - allow 3479/tcp from all
  - allow 8089/tcp from all
  - allow 51821-51830/udp from all
  
4. Prepare MQ
========================


You must retrieve the MQ configuration file for Mosquitto and the wait script.

.. code-block::

  wget -O /root/mosquitto.conf https://raw.githubusercontent.com/gravitl/netmaker/master/docker/mosquitto.conf
  wget -q -O /root/wait.sh https://raw.githubusercontent.com/gravitl/netmaker/master/docker/wait.sh
  chmod +x wait.sh

5. Install Netmaker
========================

Prepare Docker Compose 
------------------------

As of 0.20.0, our docker-compose and Caddyfile now contains references to a netmaker.env file. This will cut down on repetitive entries like inserting your base domain multiple times. You only insert it once in your netmaker.env file and the backend handles placing it in the right places. The EMQX and Pro docker-composes are now extensions of the regular docker-compose file, so switching to Pro or EMQX doesn't involve recreating an entire docker-compose file.

Get the base docker-compose and Caddyfile.

.. code-block::

  wget https://raw.githubusercontent.com/gravitl/netmaker/master/compose/docker-compose.yml
  wget https://raw.githubusercontent.com/gravitl/netmaker/master/docker/Caddyfile

If you plan on using a Professional server (Pro), then you will need to grab the Caddyfile-pro file instead. There will be more Pro related instructions below in "Extra Steps for Pro".

.. code-block::

  wget https://raw.githubusercontent.com/gravitl/netmaker/master/docker/Caddyfile-pro

You can grab the netmaker.env file here.

.. code-block::

  wget https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/netmaker.default.env
  cp netmaker.default.env netmaker.env

You can then use a text editor like vim or nano to go in there and fill out the fields. There is an example below to reference. You can get your ip with the command ``ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p'``. You can also generate random strings for the master key and MQ passwords with the command ``tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo ''`` or you can enter them manually if desired. For the base domain again, we advise you use your own domain, because nip.io can hit rate limiting easily from the high volume when obtaining certificates. If you do want to use nip.io, just enter ``nm.<YOUR_IP_WITH_DASHES_INSTEAD_OF_DOTS>.nip.io``.

.. code-block:: cfg

  # Email used for SSL certificates
  NM_EMAIL=example@email.com
  # The base domain of netmaker
  NM_DOMAIN=nm.123-456-789-012.nip.io 
  # Public IP of machine
  SERVER_HOST=<YOUR_IP_ADDRESS>
  # The admin master key for accessing the API. Change this in any production installation.
  MASTER_KEY=<RANDOM_STRING>
  # The username to set for MQ access
  MQ_USERNAME=<EXAMPLE_USERNAME>
  # The password to set for MQ access
  MQ_PASSWORD=<EXAMPLE_PASSWORD>
  # Specify the type of server to install. Use pro for professional and ce for community edition
  INSTALL_TYPE=ce
  # The next two are for Professional edition. You can find that info below on "Extra steps for Pro"
  NETMAKER_TENANT_ID= (for Pro version)
  LICENSE_KEY= (for Pro version)
  # The version for the netmaker and netmaker-ui servers. current version is v0.20.2. 
  # Some versions of docker may try to include quotation marks in this reference, so don't put them in.
  SERVER_IMAGE_TAG=v0.20.2
  UI_IMAGE_TAG=v0.20.2
  # used for HA - identifies this server vs other servers
  NODE_ID="netmaker-server-1"
  METRICS_EXPORTER="off" (turn on for Pro)
  PROMETHEUS="off"  (turn on for Pro)
  # Enables DNS Mode, meaning all nodes will set hosts file for private dns settings
  DNS_MODE="on"
  # Enable auto update of netclient ? ENUM:- enabled,disabled | default=enabled
  NETCLIENT_AUTO_UPDATE="enabled"
  # The HTTP API port for Netmaker. Used for API calls / communication from front end.
  # If changed, need to change port of BACKEND_URL for netmaker-ui.
  API_PORT="8081"
  EXPORTER_API_PORT="8085"
  # The "allowed origin" for API requests. Change to restrict where API requests can come from with comma-separated
  # URLs. ex:- https://dashboard.netmaker.domain1.com,https://dashboard.netmaker.domain2.com
  CORS_ALLOWED_ORIGIN="*"
  # Show keys permanently in UI (until deleted) as opposed to 1-time display.
  DISPLAY_KEYS="on"
  # Database to use - sqlite, postgres, or rqlite
  DATABASE="sqlite"
  # The address of the mq server. If running from docker compose it will be "mq". Otherwise, need to input address.
  # If using "host networking", it will find and detect the IP of the mq container.
  SERVER_BROKER_ENDPOINT="ws://mq:1883"
  # The reachable port of STUN on the server
  STUN_PORT="3478"
  # Logging verbosity level - 1, 2, or 3
  VERBOSITY="1"
  # If ON, all new clients will enable proxy by default
  # If OFF, all new clients will disable proxy by default
  # If AUTO, stick with the existing logic for NAT detection
  # This setting is no longer available from v0.20.5
  DEFAULT_PROXY_MODE="off"
  DEBUG_MODE="off"
  # Enables the REST backend (API running on API_PORT at SERVER_HTTP_HOST).
  # Change to "off" to turn off.
  REST_BACKEND="on"
  # If turned "on", Server will not set Host based on remote IP check.
  # This is already overridden if SERVER_HOST is set. Turned "off" by default.
  DISABLE_REMOTE_IP_CHECK="off"
  # Whether or not to send telemetry data to help improve Netmaker. Switch to "off" to opt out of sending telemetry.
  TELEMETRY="on"
  ###
  #
  # OAuth section
  #
  ###
  # "<azure-ad|github|google|oidc>"
  AUTH_PROVIDER=
  # "<client id of your oauth provider>"
  CLIENT_ID=
  # "<client secret of your oauth provider>"
  CLIENT_SECRET=
  # "https://dashboard.<netmaker base domain>"
  FRONTEND_URL=
  # "<only for azure, you may optionally specify the tenant for the OAuth>"
  AZURE_TENANT=
  # https://oidc.yourprovider.com - URL of oidc provider
  OIDC_ISSUER=

Extra Steps for Pro
-----------------------------------------------------------------------------------------------------

1. Visit `<https://app.netmaker.io>`_ to create your account on the Netmaker SaaS platform.
2. Create a tenant of type ``self-hosted`` to obtain a license key. more details in :doc:`Netmaker Professional setup <./pro/pro-setup>`
3. Retrieve Tenant ID and license key from the tenant's settings tab.
4. Place the licence key and tenant ID in the netmaker.env file.
5. In the netmaker.env file, change the METRICS_EXPORTER and PROMETHEUS from off to on.
6. Grab the docker-compose.pro extension file from the repo and change its name to docker-compose.override.yml.

.. code-block::

  wget https://raw.githubusercontent.com/gravitl/netmaker/master/compose/docker-compose.pro.yml


You will not need to make any changes to this file. It will reference the current netmaker.env file.


Then run 

.. code-block::

  ln -fs /root/netmaker.env /root/.env

6. Start Netmaker
==================

``sudo docker-compose -f docker-compose.yml up -d --force-recreate``

navigate to dashboard.<your base domain> to begin using Netmaker.

To troubleshoot issues, start with:

``docker logs netmaker``

Or check out the :doc:`troubleshoooting docs <./troubleshoot>`.
