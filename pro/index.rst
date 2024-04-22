.. Netmaker documentation master file, created by
   sphinx-quickstart on Fri May 14 08:51:40 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.


.. image:: ../images/netmaker.png
   :width: 100%
   :alt: Netmaker WireGuard
   :align: center

Netmaker Professional
======================

Netmaker Professional is our advanced Netmaker offering for business use cases. It offers all the features of community edition plus:

- **Metrics:** Nodes collect networking metrics such as latency, transfer, and connectivity status. These are displayed in the Netmaker UI, and also exported to Grafana via Prometheus.

- **Users:** On community you can only create admin users, where as on PRO it gives ability to create non-admin users which you can pair with remote-access gateway to segment users on different networks.

- **Remote Access Client:** Netmaker Professional comes with a remote access client that allows you to connect to your network from anywhere. This is a great way to connect to your network from a laptop or mobile device (soon).

- **FailOvers:** FailOvers are made to help two peers communicate where they cannot talk directly due to their firewall restrictions, in which case their connection falls back through a failover node set by the user in the network.

- **Relays:** All traffic routing to and from in a network for a relayed machine will go through the relay machine.

- **Internet Gateways:** These work similar to traditional VPNs, and can work with netclients (hosts in the mesh network) as well as with remote devices connected to the network via client configs.


Setup
--------

How to set up Netmaker Professional

.. toctree::
   :maxdepth: 2

   pro-setup

Users
---------------

.. toctree::
   :maxdepth: 2
   
   pro-users

Relays
---------------

.. toctree::
   :maxdepth: 2
   
   pro-relay-server

Metrics
------------------------------------

How to view network metrics in Netmaker Professional


.. toctree::
   :maxdepth: 2

   pro-metrics

Branding
------------

.. toctree::
   :maxdepth: 2

   pro-branding

Remote Access Client
-----------------------

.. toctree::
   :maxdepth: 2

   rac

FailOvers
-----------------------

.. toctree::
   :maxdepth: 2

   pro-failovers

Internet Gateways
-----------------------

.. toctree::
   :maxdepth: 2

   internet-gateways
