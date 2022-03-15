=====================================
Access Control Lists
=====================================

Introduction
===============

.. image:: images/acls-3.png
   :width: 80%
   :alt: ACLs
   :align: center

By default, Netmaker creates a "full mesh," meaning every node in your network can talk to every other node. You don't always want this to be the case. Sometimes, only some connections should be valid. That's why Netmaker has ACLs. By using Netmaker's ACL feature, you can enable/disable any peer-to-peer connection in your network to remove its ability to communicate.


Configuring ACLs
==================================

The ACL feature can be accessed by either clicking on "ACLs" in the sidebar, or by clicking on a Node in either the Node List or in the Graph view.

ACL Screen
--------------

If you are on the ACLs tab (pictured above), you will have a full list of all ACLs for the whole network. You can simply click on any one of these to enable or disable a pair of connections. You will note that when you "disable" the connection from any one node, it will automatically "disable" the matching connection on the other node. An update is sent to the nodes over MQ, telling them to remove the connection locally.

In the upper right-hand corner of the screen you will also notice an "Allow All" button and a "Block All" button. "Allow All" will enable all connections, and "Block All" will block all connections. If you block all connections, no nodes will be able to talk to each other.

For more information, see the :doc:`UI reference. <./ui-reference>`

Node ACL Screen
---------------------

Alternatively, you can reach the individual node ACLs by clicking on a Node in either the Node List or the Graph view. This will give you the ACLs for just this individual node, making it easier to enable/disable peers at an individual level.

.. image:: images/acls-2.png
   :width: 80%
   :alt: ACLs
   :align: center


Important Note about UDP Hole Punching
-------------------------------------------

As of 0.12.0, we allow you to disable any p2p connection, including a node's connection to the server (e.g. netmaker-1). **If you disable this connection and you use UDP Hole Punching, your network will break.** Why? The netmaker server collects the endpoints/ports necessary to reach every node, and then sends this information to the network. If this connection is disabled, the server will not know how to reach the given node.

As an alternative, you can turn off UDP Hole Punching on the individual node, if you do not wish for it to communicate with the server.