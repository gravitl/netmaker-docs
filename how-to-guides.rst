==============
How-to-Guides
==============

.. toctree::
   :maxdepth: 1

   integrating-non-native-devices
   usage

**Egress Gateway**


Netmaker allows your clients to reach external networks via an Egress Gateway. The Egress Gateway is a netclient which has been deployed to a server or router with access to a given subnet.

In the Netmaker UI, that node is set as an "egress gateway." Range(s) are specified which this node has access to. Once created, all clients (and all new ext clients) in the network will be able to reach those ranges via the gateway.

:ref:`egress`

**Remote Access Gateway/External Clients**

Netmaker allows for "external clients" to reach into a network and access services via an Remote Access Gateway. So what is an "external client"? An external client is any machine which cannot or should not be meshed. This can include:
        - Phones
        - Laptops
        - Desktops

:ref:`remote-access`

**Access Control Lists**

By default, Netmaker creates a "full mesh," meaning every node in your network can talk to every other node. You don't always want this to be the case. Sometimes, only some connections should be valid. That's why Netmaker has ACLs. By using Netmaker's ACL feature, you can enable/disable any peer-to-peer connection in your network to remove its ability to communicate.

:ref:`acls`


**Integrating Non-native Devices**

:ref:`integrating-non-native-devices`


**Setting up Site-to-site Mesh VPN**

:ref:`site2site-mesh-vpn`


**External Guides**

:ref:`usage`
