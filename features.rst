=========
Features
=========


Egress Gateway
===============

Allows clients (nodes and ext clients) to reach external networks.

:ref:`egress`


Ingress Gateway/External Clients
=================================

An ingress gateway enables external clients to connect to the network

:ref:`ingress`



Access Control Lists
======================

ACLs control communications between nodes on a network

:ref:`acls`


TURN
======
TURN (Traversal Using Relays around NAT) facilitates communication between devices that are located behind a network address translator (NAT).

:ref:`turn`


Netmaker Professional
======================

Netmaker Professional is our advanced Netmaker offering for business use cases. It offers all the features of community edition plus:
  
- **Metrics:** Nodes collect networking metrics such as latency, transfer, and connectivity status. These are displayed in the Netmaker UI, and also exported to Grafana via Prometheus.  
  
- **Users:** Community netmaker has rudimentary users, but Professional gives you the ability to create access levels to control network access, and even create groups to organize users. This allows users to log into the dashboard who can only manage ext clients for themselves, or nodes.

- **Remote Access Client:** Netmaker Professional comes with a remote access client that allows you to connect to your network from anywhere. This is a great way to connect to your network from a laptop or mobile device (soon).

.. toctree::
   :maxdepth: 1

   pro/index
