=========
Install
=========

Choose the install method that makes sense for you.


Prerequisites
==================

Server
-----------------

All components of Netmaker can be run on a single server (Virtual Machine or Bare Metal). Here are some recommendations for setting up the server:

- We **highly recommend** that Netmaker be deployed in a dedicated networking environment.
- The machine should have a public, static IP address 
- The machine should have at least 1GB RAM and 1 CPU (2GB RAM preferred for production installs)
- 2GB+ of storage 
- Ubuntu 24.04 Installed
  
If you do not have a host for this server, here are some recommendations:

- `DigitalOcean (preferred) <https://www.digitalocean.com>`_
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
- **Note on Cloudflare:** Many of our users use Cloudflare. Cloudflare will proxy connections, which MQ does not like. This can be disabled in the Cloudflare DNS dashboard. If setting up your Netmaker server using Cloudflare for DNS, be aware that the configuration of Cloudflare proxy may cause problems with Netmaker which must be resolved, and at this point, Netmaker is not providing guidance on this setup.



Firewall Rules for Netmaker Server
-------------------------------------

Make sure firewall settings are set for Netmaker both on the VM and with your cloud security groups (AWS, GCP, etc) or with your router/FWA. 

Make sure the following ports are open both on the VM and in the cloud security groups:

- **443, 80 (tcp):** for Caddy, which proxies the Dashboard (UI), REST API (Netmaker Server), and Broker (MQTT)  
- **51821 (udp and tcp):** for WireGuard - Install script automatically setups a netclient on the server machine with default port as 51821.  
- **8085 (exporter Pro):** If you are building a Pro server, you need this port open.
- **1883, 8883 8083, 18083 (if using EMQX):** We use two different types of brokers. There is Mosquitto or EMQX. Mosquitto is our default offering which uses ports 8883 and 1883. If you are setting up EMQX, all four ports mentioned need to be opened for MQTT, SSL MQTT, web sockets, and the EMQX dashboard/REST API.
- **53 (tcp and udp):** If you set the CoreDNS container, that comes with the Netmaker installation, to 'host' your domain name resolution needs


.. code-block::

  sudo ufw allow proto tcp from any to any port 443 
  sudo ufw allow proto tcp from any to any port 80
  sudo ufw allow 51821/udp (based on your netclient listen port on server machine)
  sudo ufw allow 51821/tcp (based on your netclient listen port on server machine)

  #optional: only when hosting DNS on the Netmaker server
  sudo ufw allow 53
  

It is also important to make sure the server does not block forwarding traffic (it will do this by default on some providers). To ensure traffic will be forwarded:

.. code-block::

  iptables --policy FORWARD ACCEPT


**Again, based on your cloud provider, you may additionally need to set inbound security rules for your server (for instance, on AWS). This will be dependent on your cloud provider. Be sure to check before moving on:**
  - allow 443/tcp from all
  - allow 80/tcp from all
  - allow 51821-51830/udp from all
  - allow 51821-51830/tcp from all
  - allow 53 from all (optional)


Firewall Rules for Machines Running Netclient
-------------------------------------------------

As we already know, Netclient manages WireGuard on client devices (nodes). As its name suggests, Netclient is a client in a mesh topology, thus it needs to communicate with the server and with the other clients as well. Netclient will detect local changes and send them to the server when necessary. A change in IP address or port will lead to a network update to keep everything in sync.
It goes without saying that in almost all cases a firewall must be up and running on any device that is connected to a network, especially the Internet. Firewalls are inherently restrictive for good reasons. And by default, it might not allow traffic that Netclient would use to function properly.

On Windows machines, it is possible to allow programs or applications through the firewall. Thus you might want to allow Netclient and, depending on your setup, WireGuard.

On Linux, these necessary ports are needed to be opened:

- UDP and TCP ports 51821-51830 for inbound and outbound (based on your client's listen port running on the machine)
- TCP port 443 for outbound
- UDP ports 19302 & 3478 for STUN outbound requests
 
For advanced use cases, you might need to view your device's firewall logs, or in the case of Netclients behind a NAT, your Firewall-Appliance/Router's firewall logs. Look for blocked traffic coming in and out having origin/destination IPs of your devices.

For example, in UFW you may do:

.. code-block::
  
  #set the firewall to log only the blocked traffic
  ufw logging low

  #clear out the current logs
  cat /dev/null | sudo tee /var/log/ufw.log

  #reload ufw
  ufw reload
  
  #filter the logs
  cat /var/log/ufw.log | grep -e <netmaker server IP> -e <other nodes' IPs> 


Quick Install
==================

1. **We recommend using the nm-quick script for self-hosted/On-Prem setup.**

.. code-block::

  sudo wget -qO /root/nm-quick.sh https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/nm-quick.sh && sudo chmod +x /root/nm-quick.sh && sudo /root/nm-quick.sh


**IMPORTANT:** Notes on Installation
- Due to the high volume of installations, the auto-generated domain has been rate-limited by the certificate provider. For this reason, we **strongly recommend** using your domain. Using the auto-generated domain may lead to a failed installation due to rate limiting.

**IMPORTANT:** From v0.22.0 the install script will install PRO version of netmaker with a 14-day free trial, for you to try out full capabilities of netmaker.

Integrating OAuth
====================

Users are also allowed to join a Netmaker server via OAuth. They can do this by clicking the "Login with SSO" button on the dashboard's login page. Check out the:doc:`integrating oauth docs <./oauth>`.

After the trial period ends:
==============================

    a. if you wish to continue using PRO:-
        i. check these steps to obtain pro license `<https://docs.netmaker.io/pro/pro-setup.html>`_
        ii. Run `/root/nm-quick.sh -u`

    b. if you wish to downgrade to the community version
    
        i. Run `/root/nm-quick.sh -d`


1. **To get started the easiest way, visit our SaaS platform to set up a netmaker server with just a few clicks** `<https://app.netmaker.io>`_

2. :doc:`check out these steps for the manual installation process for on-prem, although we don't recommend this path, instead use the install script mentioned above<./manual-install>`

3. :ref:`Highly Available Installation <HAInstall>`

4. :doc:`Advanced Install Resources <./server-installation>`
