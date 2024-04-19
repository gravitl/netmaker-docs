=========
Features
=========

User Management
===============

:ref:`user-management'


Egress Gateway
===============

Allows clients (nodes and ext clients) to reach external networks.

:ref:`egress`


Remote Access Gateways & Clients
=================================

A remote access gateway enables "external" clients to connect to the network. External clients refer to clients that are not part of the mesh network, but need to connect to it. This could be a laptop, mobile device, or even a server that is not part of the network.

:ref:`remote-access`



Access Control Lists
======================

ACLs control communications between nodes on a network

:ref:`acls`


Netmaker Professional
======================

Netmaker Professional is our advanced Netmaker offering for business use cases. It offers all the features of community edition plus:
  
- **Metrics:** Nodes collect networking metrics such as latency, transfer, and connectivity status. These are displayed in the Netmaker UI, and also exported to Grafana via Prometheus.  
  
- **Users:** On community you can only create admin users, where as on PRO it gives ability to create non-admin users which you can pair with remote-access gateway to segment users on different networks.

- **Remote Access Client:** Netmaker Professional comes with a remote access client that allows you to connect to your network from anywhere. This is a great way to connect to your network from a laptop or mobile device (soon).

- **FailOvers:** FailOvers are made to help two peers communicate where they cannot talk directly due to their firewall restrictions, in which case their connection falls back through a failover node set by the user in the network.

- **Relays:** All traffic routing to and from in a network for a relayed machine will go through the relay machine.

- **Internet Gateways:** These work similar to traditional VPNs, and can work with netclients (hosts in the mesh network) as well as with remote devices connected to the network via client configs.

.. toctree::
   :maxdepth: 1

   pro/index
