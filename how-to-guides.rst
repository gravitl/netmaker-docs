==============
How-to-Guides
==============


Egress Gateway
===============


Netmaker allows your clients to reach external networks via an Egress Gateway. The Egress Gateway is a netclient which has been deployed to a server or router with access to a given subnet.

In the Netmaker UI, that node is set as an "egress gateway." Range(s) are specified which this node has access to. Once created, all clients (and all new ext clients) in the network will be able to reach those ranges via the gateway.

.. toctree::
   :maxdepth: 2

   egress-gateway

Ingress Gateway/External Clients
=================================

Netmaker allows for "external clients" to reach into a network and access services via an Ingress Gateway. So what is an "external client"? An external client is any machine which cannot or should not be meshed. This can include:
        - Phones
        - Laptops
        - Desktops

.. toctree::
   :maxdepth: 2

   external-clients

Access Control Lists
======================
By default, Netmaker creates a "full mesh," meaning every node in your network can talk to every other node. You don't always want this to be the case. Sometimes, only some connections should be valid. That's why Netmaker has ACLs. By using Netmaker's ACL feature, you can enable/disable any peer-to-peer connection in your network to remove its ability to communicate.

.. toctree::
   :maxdepth: 2

   acls

Netmaker Professional
======================

Netmaker Professional is our advanced Netmaker offering for business use cases. It offers all the features of community edition plus:
  
- **Metrics:** Nodes collect networking metrics such as latency, transfer, and connectivity status. These are displayed in the Netmaker UI, and also exported to Grafana via Prometheus.  
  
- **Users:** Community netmaker has rudimentary users, but Professional gives you the ability to create access levels to control network access, and even create groups to organize users. This allows users to log into the dashboard who can only manage ext clients for themselves, or nodes.

- **Remote Access Client:** Netmaker Professional comes with a remote access client that allows you to connect to your network from anywhere. This is a great way to connect to your network from a laptop or mobile device (soon).

- **Rely:** Netmaker Professional enables a node to be designated as a relay and to identify which node(s) it should relay.  All traffic to/from relayed node(s) will transverse via the relay. 

.. toctree::
   :maxdepth: 1

   pro/index

External Guides
================

.. toctree::
   :maxdepth: 2

   usage
