===============
Quick Install
===============

Important Notes
============================

1. **WE RECCOMMEND USING THE NM-QUICK-INTERACTIVE SCRIPT INSTEAD OF THIS GUIDE. It can be found** `on GitHub <https://github.com/gravitl/netmaker#get-started-in-5-minutes>`_ **(raw script** `here <https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/nm-quick-interactive.sh>`_ **).**

2. This guide is just a manual version of the steps perfomed by that script, and is therefore more prone to error.

3. You must decide if you are installing the EE version of Netmaker or the Community version. We reccommend EE because of its substantial free tier, but it does require `an account <https://dashboard.license.netmaker.io>`_.

4. If deploying to DigitalOcean, you should use the `DigitalOcean 1-Click <https://marketplace.digitalocean.com/apps/netmaker>`_, which uses the interactive script.

5. This instance will not be HA. However, it should comfortably handle 100+ concurrent clients and support the most common use cases.

6. For information about deploying more advanced configurations, see the :doc:`Advanced Installation <./server-installation>` docs. 

0. Prerequisites
==================
-  **Virtual Machine**
   
   - Preferably from a cloud provider (e.x: DigitalOcean, Linode, AWS, GCP, etc.)
   
   - We **highly recommend** that Netmaker be deployed in a dedicated networking environment. It should not share a local network with the clients which it will be managing. This can cause routing issues.

   - We do not recommend Oracle Cloud, as VM's here have been known to cause network interference.

   - The machine should have a public, static IP address 
   
   - The machine should have at least 1GB RAM and 1 CPU (2GB RAM preferred for production installs)
   
   - 2GB+ of storage 
   
   - Ubuntu 21.04 Installed

- **Domain**

  - A publicly owned domain (e.x. example.com, mysite.biz) 
  - Permission and access to modify DNS records via DNS service (e.x: Route53)
  - **Note on Cloudflare:** Many of our users use Cloudflare for DNS. Cloudflare has limitations on subdomains you must be aware of, which can cause issues once Netmaker is deployed. Cloudflare will also proxy connections, which MQ does not like. This can be disabled in the Cloudflare dashboard. If setting up your Netmaker server using Cloudflare for DNS, be aware that the configuration of Cloudflare may cause problems with Netmaker which must be resolved, and at this point, Netmaker is not providing guidance on this setup.

1. Prepare DNS
================

Create a wildcard A record pointing to the public IP of your VM. As an example, \*.netmaker.example.com. Alternatively, create records for these specific subdomains:

- dashboard.domain

- api.domain

- broker.domain

If deploying EE, you will also need records for the following:

- grafana.domain

- prometheus.domain

- netmaker-exporter.domain


2. Install Dependencies
========================

.. code-block::

  ssh root@your-host
  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose wireguard

At this point you should have all the system dependencies you need.
 
3. Open Firewall
===============================

Make sure firewall settings are set for Netmaker both on the VM and with your cloud security groups (AWS, GCP, etc). 

Make sure the following ports are open both on the VM and in the cloud security groups:

- **443, 80 (tcp):** for Caddy, which proxies the Dashboard (UI), REST API (Netmaker Server), and Broker (MQTT)  
- **51821-518XX (udp):** for WireGuard - Netmaker needs one port per network, starting with 51821, so open up a range depending on the number of networks you plan on having. For instance, 51821-51830.  

.. code-block::

  sudo ufw allow proto tcp from any to any port 443 && sudo ufw allow proto tcp from any to any port 80 && sudo ufw allow 51821:51830/udp

It is also important to make sure the server does not block forwarding traffic (it will do this by default on some providers). To ensure traffic will be forwarded:

.. code-block::

  iptables --policy FORWARD ACCEPT


**Again, based on your cloud provider, you may additionally need to set inbound security rules for your server (for instance, on AWS). This will be dependent on your cloud provider. Be sure to check before moving on:**
  - allow 443/tcp from all
  - allow 80/tcp from all
  - allow 51821-51830/udp from all
  
4. Prepare MQ
========================


You must retrieve the MQ configuration file for Mosquitto and the wait script.

.. code-block::

  wget -O /root/mosquitto.conf https://raw.githubusercontent.com/gravitl/netmaker/master/docker/mosquitto.conf
  wget -q -O /root/wait.sh https://raw.githubusercontent.com/gravitl/netmaker/develop/docker/wait.sh
  chmod +x wait.sh

5. Install Netmaker
========================

Prepare Docker Compose 
------------------------

Get The public IP (server ip).

.. code-block::

  ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p'


Now, insert the values for your base (wildcard) domain, public ip.

.. code-block::

  wget -O docker-compose.yml https://raw.githubusercontent.com/gravitl/netmaker/master/compose/docker-compose.yml
  # (if installing the EE version) wget -O docker-compose.yml https://raw.githubusercontent.com/gravitl/netmaker/master/compose/docker-compose.ee.yml

  wget -O Caddyfile https://raw.githubusercontent.com/gravitl/netmaker/master/docker/Caddyfile
  # (if installing the EE version) wget -O Caddyfile https://raw.githubusercontent.com/gravitl/netmaker/master/docker/Caddyfile-EE

  sed -i 's/NETMAKER_BASE_DOMAIN/<your base domain>/g' docker-compose.yml
  sed -i "s/NETMAKER_BASE_DOMAIN/<your base domain>/g" /root/Caddyfile
  sed -i 's/SERVER_PUBLIC_IP/<your server ip>/g' docker-compose.yml
  sed -i 's/YOUR_EMAIL/<your email>/g' Caddyfile

Generate a unique master key and insert it:

.. code-block::

  tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo ''
  sed -i 's/REPLACE_MASTER_KEY/<your generated key>/g' docker-compose.yml

You will also need to set an admin password for MQ, which may also be generated randomly.

.. code-block::

  tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo ''
  sed -i "s/REPLACE_MQ_ADMIN_PASSWORD/<your generated password>/g" docker-compose.yml

Extre Steps for EE (note: there is a substantial free tier for EE, so this is often worthwhile)
-----------------------------------------------------------------------------------------------------

1. Log into https://dashboard.license.netmaker.io"
2. Copy License Key Value: https://dashboard.license.netmaker.io/license-keys"
3. Retrieve Account ID: https://dashboard.license.netmaker.io/user"

.. code-block::

	sed -i "s~YOUR_LICENSE_KEY~<your license key value>~g" docker-compose.yml 
	sed -i "s/YOUR_ACCOUNT_ID/<your account ID>/g" docker-compose.yml 

Start Netmaker
----------------

``sudo docker-compose up -d``

navigate to dashboard.<your base domain> to begin using Netmaker.

To troubleshoot issues, start with:

``docker logs netmaker``

Or check out the :doc:`troubleshoooting docs <./troubleshoot>`.
