.. _integrating-non-native:

=======
Integrating Non-native Devices
=======

Introduction
===============

Netmaker manages Wireguard configurations through the Netclient and the Remote Access Client (RAC) installed on the hosts and on the external clients repectively. Basically Netmaker makes Wireguard configurations, which are inherently static, dynamic. As you setup and change your network, Netmaker propagates these changes in the configuration to the affected machines installed with either Netclient or RAC.

However in some cases, it might not be ideal or even possible to install Netclient or RAC on your machine/device. In these cases Netmaker will rely on your intervention to manually set and change Wireguard configurations on these machines/devices when necessary.  


Generating a Wireguard configuration file on Remote Access gateway
==================================

For instructions on how to create a node as a Remote Access Gateway and on how to create/generate and get VPN configuration files, please refer to the "Ingress Gateway/External Clients" section under the "How-to-Guides".

You can also get the Wireguard VPN configuration by following these steps:

1. Navigate to your network's Remote Access tab. You should see the Gateways table to the left-hand side and then the VPN Config Files table to the right-hand side of the page

2. If you have multiple gateways, select the specific one by clicking on it if it hasn't been selected already

3. If necessary, find the VPN configuration by inputting its name in the Search box

4. Once you've located the configuration file, hover over or click on its 'kebab' icon to the right-hand side corner of the row. A context menu should show up similar to the screenshot below


.. image:: images/integration-get-config.jpg
   :width: 80%
   :alt: Get Client Config
   :align: center

5. Now you can view and copy the configuration file by clicking on the 'View Config' option. Or you can click on the 'Download' option to get a copy of the configuration file


.. image:: images/integration-sample-config.jpg
   :width: 80%
   :alt: Sample Client Config
   :align: center


Once you have the configuration information or the configuration file, you can now stick it to your router, IoT, or other edge devices.


Routers and Firewall Appliances (Virtual or Bare metal)
============

While Netclient can be installed in some routers and firewall appliances and then configure them as egress gateways, it is generally ideal to use these devices' built-in VPN feature for seamless integration. Since most modern routers and firewalls today support Wireguard, they can connect to a Netmaker network as an external client and then responsibly expose the resources behind them by inputting their IP address ranges in the 'Additional Addresses' field.


.. image:: images/integration-config-additional-addresses.jpg
   :width: 80%
   :alt: Client additional IP addresses range
   :align: center


The general guidelines for integrating routers and firewall appliances to Netmaker are the following:

   - Before doing any further configuration, take note of your current firmware version and back up the current configuration settings
   - Upgrade your firmware if necessary
   - Install Wireguard via your router's or FWA's Package Manager. Usually this can be done from its web interface (GUI) instead of from its shell (CLI)
   - Input the VPN configuration information from Netmaker; or upload the configuration file if your device supports it
   - If necessary, create a routing entry for the Wireguard interface
   - Create tight and specific firewall rules for traffic going in and out between the VPN interface and your LAN [or depending on your use case your specific device, interface/port, VLAN, DMZ, WAN, etc.]


1) pfSense (in progress)
-------------------

Please refer to these documentation links for more details:

   - Wireguard installation: https://docs.netgate.com/pfsense/en/latest/packages/manager.html

.. image:: images/integration-sample-config.jpg
   :width: 80%
   :alt: Sample Client Config
   :align: center

   - Wireguard configuration: https://docs.netgate.com/pfsense/en/latest/vpn/wireguard/index.html
   
.. image:: images/integration-sample-config.jpg
   :width: 80%
   :alt: Sample Client Config
   :align: center



2) OPNsense
-------------------

A Test 


3) MikroTik
-------------------

A Test 


4) OpenWrt
-------------------

A Test 




IoT / edge devices
======================

Todo


Others
======================

Todo