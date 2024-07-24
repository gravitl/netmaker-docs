================================
Advanced Client Installation
================================

This document tells you how to install the netclient on machines that will be a part of your Netmaker network, as well as non-compatible systems.

These steps should be run after the Netmaker server has been created and a network has been designated within Netmaker.

Introduction to Netclient
===============================

At its heart, the netclient is a simple CLI for managing access to various WireGuard-based networks. It manages WireGuard on the host system so that you don't have to. Why is this necessary?

If you are setting up a WireGuard-based virtual network, you must configure each machine with very specific settings, so that every machine can reach it, and it can reach every other machine. Any changes to the settings of any one of these machines can break those connections. Any machine that is added, removed, or modified on the network requires reconfiguring of every peer in the network. This can be very time-consuming.

The netmaker server holds configuration details about every machine in your network and how other machines should connect to it.

The netclient agent connects to the server, pushing and pulling information when the network (or its local configuration) changes. 

The netclient agent then configures WireGuard (and other network properties) locally, so that the network stays intact.

Note on MTU Settings
==================================

IPv6 requires a minimum MTU of 1280. A lot of router configurations expect a standard MTU setting. You can adjust the MTU to whatever fits your needs, but setting the MTU below the standardized 1280 may cause wireguard to have issues when setting up interfaces with some systems like "Windows" for example.

Notes on Windows
==================================

If running the netclient on Windows, you must download the netclient.exe binary and run it from Powershell as an Administrator.

Windows will by default have firewall rules that prevent inbound connections. If you wish to allow inbound connections from particular peers, use the following command:

``netsh advfirewall firewall add rule name="Allow from <peer private addr>" dir=in action=allow protocol=ANY remoteip=<peer private addr>``

If you want to allow all peers access, but do not want to configure firewall rules for all peers, you can configure access for one peer, and set it as a Relay Server(Professional Edition Feature) from Netmaker GUI. To achieve this, a netmaker pro edition is required.

Running netclient commands
----------------------------

If running the netclient manually ("netclient install", "netclient join", "netclient pull") it should be run from outside of the installed directory, which will be either:

- `C:/Program Files/netclient`
- `C:/ProgramData/netclient`

It is better to call it from a different directory.

High CPU Utilization
--------------------------

With some versions of WireGuard on Windows, high CPU utilization has been found with the netclient. This is typically due to interaction with the WireGuard GUI component (app). If you're experiencing high CPU utilization, close the WireGuard app. WireGuard will still be running, but the CPU usage should go back down to normal.

Changing network profile to private
------------------------------------

By default, the netmaker network profile is added as a public network. This is the default behaviour on Windows. To change it to private, please run the Powershell command,

- `Set-NetConnectionProfile -InterfaceAlias 'netmaker' -NetworkCategory 'Private'`

Issue after Windows sleep/hibernate
-------------------------------------

Sometimes the netclient does not work after the Windows wake up from sleep/hibernation. The root cause is not identified.  Restarting the netclient service can fix the issue.

Irregular netclient restart on Windows 2016 server
----------------------------------------------------

There is one issue reported on the Windows 2016 server.  The netclient restarted irregularly. The root cause is not identified. However, as per the feedback from the client, the issue can be fixed by disabling the ISATAP adapter and 6to4 feature.

- `Set-Net6to4configuration -state disabled`
- `Set-Netisatapconfiguration -state disabled`
- `Set-NetTeredoConfiguration -type disabled`

Event id 0 in Windows Event logs
---------------------------------
netclient service is delegated to Winsw on Windows. An issue is reported that the stop/start/restart events in Event logs show the event ID as 0 always. It does not impact any netclient functions.

Modes and System Compatibility
==================================

**Note: If you would like to connect non-Linux/Unix machines to your network such as phones and Windows desktops, please see the documentation on Remote Access Clients(previously External Clients)**

The netclient can be run in a few "modes". System compatibility depends on which modes you intend to use. These modes can be mixed and matched across a network, meaning all machines do not have to run with the same "mode."

CLI
------------

In its simplest form, the netclient can be treated as just a simple, manual, CLI tool, which a user can call to configure the machine. The CLI can be compiled from source code to run on most systems and has already been compiled for x86 and ARM architectures.

As a CLI, the netclient should function on any Linux or Unix-based system that has the wireguard utility (callable with **wg**) installed.

Daemon
----------

The netclient is intended to be run as a system daemon. This allows it to automatically retrieve and send updates. To do this, the netclient can install itself as a systemd service, or launchd/windows service for Mac or Windows.

If running the netclient on non-systemd Linux, it is recommended to manually configure the netclient as a daemon using whatever method is acceptable on the chosen operating system.

Private DNS Management
-----------------------

To manage private DNS, the netclient relies on systemd-resolved (resolvectl). Absent this, it cannot set private DNS for the machine.

A user may choose to manually set a private DNS nameserver of <netmaker server>:53. However, beware, as netmaker sets split DNS, the system must be configured properly. Otherwise, this nameserver may break your local DNS.

Prerequisites
=============

To obtain the netclient, go to the GitHub releases: https://github.com/gravitl/netclient/releases

**For netclient cli:** Linux/Unix with WireGuard installed (wg command available)

**For netclient daemon:** Systemd Linux + WireGuard

**For Private DNS management:** Resolvectl (systemd-resolved)

Please refer to the `Firewall Rules for Machines Running Netclient <https://docs.netmaker.io/install.html#firewall-rules-for-machines-running-netclient>`_ for more information.


Configuration
===============

The CLI has information about all commands and variables. This section shows the "help" output for these commands as well as some additional references.

CLI Reference
--------------------
``sudo netclient --help``

.. literalinclude:: ./examplecode/netclient-help.txt
  :language: YAML


``sudo netclient join --help``

.. literalinclude:: ./examplecode/netclient-join.txt
  :language: YAML

``sudo netclient push --help``

.. literalinclude:: ./examplecode/netclient-push.txt
  :language: YAML


Installation
======================


To install netclient and join a network, you need to use ``netclient install`` command and get an enrollment key for a particular network from netmaker.

An admin creates an enrollment key in the "Enrollment Keys" section of the UI. Upon creating a key, it can be viewed by clicking on the key from UI. Some details regarding the key will be visible:

**Key:** The enrollment key to join and authenticate to a netmaker network

**Type:** The Type of key determines the usage limitation of a particular key. Possible values are: Unlimited, Time Bound, Limited Number of Uses

**Expires at:** Shows the expiration date of the particular enrollment key

**Networks:** Shows which netmaker networks can be joined by using the particular enrollment key

**Install Command:** The CLI command to register with the server using the enrollment key, and join the networks

For first-time installations, you can run the Install Command. For additional networks, simply run ``netclient join -t <enrollment key>``.


Managing Netclient
=====================

Connect / Disconnect
----------------------

**to disconnect from a network previously joined (without leaving the network):**
  ``netclient disconnect <network>``

**to connect with a network previously disconnected:**
  ``netclient connect <network>``

Viewing Logs
---------------

**to view current networks**
  ``netclient list``

**to tail logs**
  ``journalctl -u netclient``

**to get most recent log run**
  ``systemctl status netclient``

Re-syncing netclient (basic troubleshooting)
-----------------------------------------------

If the daemon is not running correctly, try restarting the daemon, or pulling changes directly (don't do both at once)

  ``systemctl restart netclient``

  ``sudo netclient pull``


Adding/Removing Networks
---------------------------

``netclient join -t <enrollment key>``

Set any of the above flags (netclient join --help) to override settings for joining the network. 


Uninstalling
---------------

``netclient uninstall``


