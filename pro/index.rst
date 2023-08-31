.. Netmaker documentation master file, created by
   sphinx-quickstart on Fri May 14 08:51:40 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.


.. image:: ../images/netmaker.png
   :width: 100%
   :alt: Netmaker WireGuard
   :align: center

===================================================
Netmaker Enterprise Documentation
===================================================

Netmaker Enterprise is our advanced Netmaker offering for business use cases. It offers all the features of community edition plus:  
  
- **Metrics:** Nodes collect networking metrics such as latency, transfer, and connectivity status. These are displayed in the Netmaker UI, and also exported to Grafana via Prometheus.  
  
- **Users:** Community netmaker has rudimentary users, but Enterprise gives you the ability to create access levels to control network access, and even create groups to organize users. This allows users to log into the dashboard who can only manage ext clients for themselves, or nodes.  
  
- **HA Networking (coming soon):** This feature has not been released yet, but allows you to set automated failover for network routes using "auto relays," meaning nodes will relay and p2p connections that aren't working on their own.   
  
Setup
--------

How to set up Netmaker Enterprise

.. toctree::
   :maxdepth: 2

   pro-setup

Relays
---------------

.. toctree::
   :maxdepth: 2
   
   pro-relay-server

Metrics
------------------------------------

How to view network metrics in Netmaker Enterprise

.. toctree::
   :maxdepth: 2

   pro-metrics

Branding
------------

.. toctree::
   :maxdepth: 2

   pro-branding