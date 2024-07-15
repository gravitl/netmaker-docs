=========
Install
=========

Choose the install method that makes sense for you.


Prerequisites
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


Quick Install
==================

1. **We recommend using the nm-quick script for self-hosted/On-Prem setup.**

.. code-block::

  sudo wget -qO /root/nm-quick.sh https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/nm-quick.sh && sudo chmod +x /root/nm-quick.sh && sudo /root/nm-quick.sh


**IMPORTANT:** Notes on Installation
- Due to the high volume of installations, the auto-generated domain has been rate-limited by the certificate provider. For this reason, we **strongly recommend** using your own domain. Using the auto-generated domain may lead to a failed installation due to rate limiting.

**IMPORTANT:** From v0.22.0 the install script will install PRO version of netmaker with a 30-day free trial, for you to try out full capabilities of netmaker.

Integrating OAuth
====================

Users are also allowed to join a Netmaker server via OAuth. They can do this by clicking the "Login with SSO" button on the dashboard's login page. Check out the :doc:`integrating oauth docs <./oauth>`.

After trial period ends:
=========================

    a. if you wish to continue using PRO :-

        i. check these steps to obtain pro license `<https://docs.netmaker.io/quick-start.html#extra-steps-for-pro>`_
        ii. Run `/root/nm-quick.sh -u`

    b. if you wish to downgrade to community version
    
        i. Run `/root/nm-quick.sh -d`


1. **To get started the easiest way, visit our SaaS platform to set up a netmaker server with just a few clicks** `<https://app.netmaker.io>`_

2. :doc:`check out these steps for manual installation process for on-prem, although we don't recommend this path, instead use the install script mentioned above<./manual-install>`

3. :ref:`Highly Available Installation <HAInstall>`

4. :doc:`Advanced Install Resources <./server-installation>`
