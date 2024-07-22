.. Netmaker documentation master file, created by
   sphinx-quickstart on Fri May 14 08:51:40 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

=====================
Netmaker Professional
=====================

.. toctree::
   :maxdepth: 1

   pro-setup
   pro-users
   ../oauth
   pro-relay-server
   pro-metrics
   pro-branding
   rac
   pro-failovers
   internet-gateways


.. image:: ../images/netmaker.png
   :width: 100%
   :alt: Netmaker WireGuard
   :align: center

Netmaker Professional is our advanced Netmaker offering for business use cases. It offers all the features of community edition plus:

- **Metrics:** Nodes collect networking metrics such as latency, transfer, and connectivity status. These are displayed in the Netmaker UI, and also exported to Grafana via Prometheus.

- **Users:** On community you can only create admin users, where as on PRO it gives ability to create non-admin users which you can pair with remote-access gateway to segment users on different networks.

- **OAuth:** By integrating with an OAuth provider, Netmaker users can log in via the provider, rather than the default simple auth.

- **Remote Access Client:** Netmaker Professional comes with a remote access client that allows you to connect to your network from anywhere. This is a great way to connect to your network from a laptop or mobile device (soon).

- **FailOvers:** FailOvers are made to help two peers communicate where they cannot talk directly due to their firewall restrictions, in which case their connection falls back through a failover node set by the user in the network.

- **Relays:** All traffic routing to and from in a network for a relayed machine will go through the relay machine.

- **Internet Gateways:** These work similar to traditional VPNs, and can work with netclients (hosts in the mesh network) as well as with remote devices connected to the network via client configs.

