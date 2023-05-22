=====================================
Ingress + External Clients
=====================================

Introduction
===============

.. image:: images/ingress1.png
   :width: 50%
   :alt: Gateway
   :align: center

Netmaker allows for "external clients" to reach into a network and access services via an Ingress Gateway. So what is an "external client"? An external client is any machine which cannot or should not be meshed. This can include:
        - Phones
        - Laptops
        - Desktops

An external client is not "managed," meaning it does not automatically pull the latest network configuration or push changes to its configuration. Instead, it uses a generated WireGuard config file to access the designated **Ingress Gateway**, which **is** a managed server (running netclient). This server then forwards traffic to the appropriate endpoint, acting as a middle-man/relay.

By using this method, you can hook any machine into a netmaker network that can run WireGuard.

It is recommended to run the netclient where compatible, but for all other cases, a machine can be configured as an external client.

Important to note, that an external client is not **reachable** by the network, meaning the client can establish connections to other machines, but those machines cannot independently establish a connection back. The External Client method should only be used in use cases where one wishes to access resources running on the virtual network and **not** for use cases where one wishes to make a resource accessible on the network. For that, use netclient.

Configuring an Ingress Gateway
==================================

External Clients must attach to an Ingress Gateway. By default, your network will not have an ingress gateway. To configure an ingress gateway, navigate to the network name and go to the clients tab.

.. image:: images/extclient1.png
   :width: 80%
   :alt: Gateway
   :align: center

After clicking the create client button, a modal window will pop up asking you which host you would like to use as an ingress gateway. You can use any host in your network, but it should have a public IP address (not behind a NAT). Your Netmaker server can be an ingress gateway and makes for a good default choice if you are unsure of which node to select.

.. image:: images/extclient2.png
   :width: 80%
   :alt: Gateway
   :align: center

Adding Clients to a Gateway
=============================

Once you have figured out your gateway, You can fill in any other info you need for your client. You can give it a name. You can use your own public key if you like. You can set a default DNS for the client, and any specific addresses you would need for the client. You can also leave these fields blank and the name, address, and public key will be automatically configured for you. Clients will be able to access other nodes in the network just as the gateway node does.

.. image:: images/extclient3.png
   :width: 80%
   :alt: Edit External Client Name
   :align: center

After clicking create, your external client will be ready for your device.

.. image:: images/extclient4.png
   :width: 80%
   :alt: ext client pop up
   :align: center

Then, you can either download the configuration file directly or scan the QR code from your phone (assuming you have the WireGuard app installed). It will accept the configuration just as it would accept a typical WireGuard configuration file.

.. image:: images/extclient5.png
   :width: 80%
   :alt: Gateway
   :align: center


Example config file: 

.. literalinclude:: ./examplecode/myclient.conf

Your client should now be able to access the network! A client can be invalidated at any time by simply deleting it from the UI.

Disabling External Clients
==========================

To (temporarily) disable an external client's access to the Netmaker network that it belongs to, click the switch below "Enabled" on the line with the Client ID that you would like to disable.  Click "Accept" when asked "Are you sure you want to disable access to this Ext. Client?"

.. image:: images/extclient-disable.png
   :width: 80%
   :alt: Disable an External Client
   :align: center

After you click the switch and click Accept the ext client will no longer be reachable and the switch will be turned off.

.. image:: images/extclient-disabled.png
   :width: 80%
   :alt: Disabled External Client
   :align: center

To re-enable the client click the switch again and accept.  It will turn on again and the client will be re-enabled.
