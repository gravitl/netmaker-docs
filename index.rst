.. Netmaker documentation master file, created by
   sphinx-quickstart on Fri May 14 08:51:40 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.


.. image:: images/netmaker.png
   :width: 100%
   :alt: Netmaker WireGuard
   :align: center

=======================================
Welcome to the Netmaker Documentation
=======================================


Netmaker is a platform for creating fast and secure virtual networks with WireGuard.

This documentation covers Netmaker's :doc:`installation <./server-installation>`, :doc:`usage <./usage>`, and :doc:`troubleshooting <./support>`. It also contains reference documentation for the :doc:`API <./api>`, :doc:`UI <./ui-reference>` and :doc:`Netclient <./advanced-client-install>` configuration. All of the `source code <https://github.com/gravitl/netmaker>`_ for Netmaker is on GitHub.

**For Kubernetes-specific guidance, please see the** `Netmaker Kubernetes Documentation. <https://k8s.netmaker.org>`_

About
--------

High-level information about what Netmaker is and how it works.

.. toctree::
   :maxdepth: 2

   about
   
   architecture

Getting Started
------------------------------------

How to install Netmaker and set up your first network.

.. toctree::
   :maxdepth: 2

   install

   quick-start

   getting-started

Netclient
------------------------------------

Client-side instructions for joining a network and managing a machine locally.

.. toctree::
   :maxdepth: 2

   netclient

Ingress, Egress, and Relays
------------------------------

How to give machines outside of the Netmaker network access to network resources via an Ingress Gateway:

.. toctree::
   :maxdepth: 2
   
   external-clients

How to give machines inside the Netmaker network access to external network resources via an Egress Gateway:


.. toctree::
   :maxdepth: 2
   
   egress-gateway

How to make machines inside the network reachable if they are blocked by NAT/Firewall:



.. toctree::
   :maxdepth: 2
   
   turn-server

Access Control and Zero Trust
------------------------------

Fine-grained control of your networks. Enable or disable any peer-to-peer connection to decide which machines can talk to which other machines.

.. toctree::
   :maxdepth: 2
   
   acls

Kubernetes Documentation
---------------------------

.. toctree::

   Kubernetes <https://k8s.netmaker.org>
   
`Netmaker Kubernetes Documentation <https://k8s.netmaker.org>`_


Professional Documentation
---------------------------

.. toctree::
   :maxdepth: 2
   
   pro/index


Advanced Server Installation
-------------------------------

A detailed guide to installing the Netmaker server (API, DB, UI, DNS), and configuration options.

.. toctree::
   :maxdepth: 2
   
   server-installation

Advanced Client Installation
--------------------------------

A detailed guide to installing the Netmaker agent (netclient) on devices and configuration options.

.. toctree::
   :maxdepth: 2
   
   advanced-client-install


Oauth Configuration
--------------------

A simple guide to configuring OAuth for Netmaker.

.. toctree::
   :maxdepth: 2
   
   oauth


External Guides
----------------

A handful of guides for use cases including site-to-site, Kubernetes, private DNS, and more.

.. toctree::
   :maxdepth: 2
   
   usage

UI Reference
---------------

A reference document for the Netmaker Server UI, with annotated screenshot detailing each field.

.. toctree::
   :maxdepth: 2

   ui-reference

API Reference
---------------

A reference document for the Netmaker Server API, and example API calls for various use cases.

.. toctree::
   :maxdepth: 1

   api

Upgrades
----------------

Upgrading the Netmaker server and clients.

.. toctree::
   :maxdepth: 1

   upgrades

NMCTL
----------------

A reference document for the Netmaker CLI tool nmctl.

.. toctree::
   :maxdepth: 1

   nmctl.rst

Troubleshooting
----------------

Help with common Netmaker/netclient issues.

.. toctree::
   :maxdepth: 2

   troubleshoot


Support
----------------

Where to go for help, and a FAQ.

.. toctree::
   :maxdepth: 2

   support

Code of Conduct
-----------------

A statement on our expectations and pledge to the community.

.. toctree:: 

        conduct.rst

Licensing
---------------

A link to the Netmaker license.

.. toctree:: 

        license.rst
