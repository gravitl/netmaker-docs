This page contains annotated screenshots of most UI components, detailing the configuration options of each field across Nodes, Networks, DNS, Ext Clients, Users, and more.


`Here is an arcade showing a walkthrough of our new UI. <https://app.arcade.software/share/Jdl7PnnqIbot3IkqvIaf>`_


Authentication
=================

Signup
--------

When you start Netmaker for the first time, you will be prompted to create a superadmin account from the UI like below

.. image:: images/ui-signup.png
   :width: 80%
   :alt: sign up
   :align: center

(1) **Username:** Enter a unique username for the admin user.
(2) **Password:** Enter a secure password for your new user.
(3) **Password Confirmation:** Repeat the password for verification.

Login
--------

.. image:: images/ui-login.png
   :width: 80%
   :alt: log in
   :align: center

(1) **Username:** Enter your username.
(2) **Password:** Enter your password.
(3) **Login:** Button to login.

**Signup/Login with OAuth:** Users have the option to sign in or sign up via OAuth. New users however will require apporval from a server admin to gain access.

Dashboard
=================

.. image:: images/ui-1.jpg
   :width: 80%
   :alt: dashboard
   :align: center

Networks
=================

Create
--------

.. image:: images/ui-2.png
   :width: 80%
   :alt: create network
   :align: center

.. code-block::

(1) **Autofill:** Provides sensible defaults for network details and makes up a name.
(2) **Network Name:** The name of the network. Character limited, as this translates to the interface name on hosts (nm-<network name>)
(3) **Address Range:** The CIDR of the network. Must be a valid IPv4 Subnet and should be a private address range.
(4) **Default Access Control:** Indicates the default ACL value for a node when it joins in respect to it's peers (enabled or disabled).

Hosts
======

In simple terms, a host is a computer or machine running the netclient software. Netmaker UI allows an admin to conviniently view and configure some host settings remotely.

Host List
---------

.. image:: images/hosts-list.png
   :width: 80%
   :alt: hosts list
   :align: center

(1) **Host Name:** Friendly name of the host. Clicking it opens a view to allow admins manage hosts.
(2) **Endpoint:** The public IP address of the host.
(3) **Public Port:** Public port of the host.
(4) **Version:** Indicates the version of netclient the host is running.
(5) **Health Status:** Indicates the connectivity of the host.
(6) **Sync:** Synchronise the host with the server; this triggers the host to pull latest network/server state.
(7) **Actions:** Quick actions that can be performed on the host.


Host Create
-----------

A host is automatically created on a server once a netclient (a machine running netclient) joins any network on the server.

Host Details
------------

.. image:: images/host-details.png
   :width: 80%
   :alt: host details
   :align: center

The following information is present under the host details tab:

(1) **ID:** Unique identifier for the host
(2) **Name:** Name of the host. Defaults to the machine's name.
(3) **Version:** Version of netclient the host is running.
(4) **Operating System:** Operating system (OS) the machine is running.
(5) **Public Key:** Public key of the host. distributed to other hosts.
(6) **MTU:** Maximum Transmission Unit (MTU) of the host
(7) **Listen Port:** The wiregaurd listen port.
(8) **Proxy Listen Port:** The netclient proxy listen port. this is used if `Proxy Enabled` is set to `true`. (No longer available from v0.20.5)
(9) **Verbosity:** Log verbosity (ranges from 1-4). Indicates level of detail the host (netclient) will output to logs.
(10) **Default Interface:** Default network interface used by the host.
(11) **MAC Address:** Media Access Control (MAC) address of the host machine.
(12) **Is Default:** Indicates whether the host is a default node. Hosts that are default nodes will automatically join any created network.
(13) **Debug:** Flag to enable additional logging on client.
(14) **Proxy Enabled:** Indicates whether a host is running netclient proxy. (No longer available from v0.20.5)
(15) **Is Static:** Indicaates whether the host's endpoint is static or not.
(16) **Interfaces:** Lists the available network interface for the host.

A host can be deleted from the UI. All associated nodes must be manually removed however, before deleting a host.


.. image:: images/host-nets.png
   :width: 80%
   :alt: host details
   :align: center

Nodes
========

Node List
-------------

.. image:: images/nodes-1.png
   :width: 80%
   :alt: nodes list
   :align: center

(1) **Search Hosts:** Look up a host by name.
(2) **Host Name:** Name of host. By default set to hostname of machine.
(3) **Private Addresses:** Private IPs of host within network.
(4) **Public Address:** Public IP of host.
(5) **Status:** Indicates how recently the host checked into the server. Displays "Warning" after 5 minutes and "Error" after 30 minutes without a check in. Does **not** explicitly indicate the health of the node's virtual network connections; however a healthy host will check-in regularly.
(6) **Actions:** Dropdown list of actions that can be performed on a host, including disconnecting and deleting the host.

A node pending deletion will be grayed out.

Create Egress
---------------

.. image:: images/ui-6.png
   :width: 80%
   :alt: dashboard
   :align: center

(1) **Egress Gateway Ranges:** A comma-separated list of the subnets for which the gateway will route traffic. For instance, with Kubernetes this could be both the Service Network and Pod Network. For a standard VPN, Netmaker can use a list of the public CIDR's (see the docs). Typically, this will be something like a data center network, VPC, or home network.
(2) **Interface:** The interface on the machine used to access the provided egress gateway ranges. For instance, on a typical linux machine, the interface for public traffic would be "eth0". Usually you will need to check on the machine first to find the right interface. For instance, on Linux, you can find the interface by running this: ip route get <address in subnet>.


Create Relay
-------------

Check host section on hosts_. A relay can be created under host settings.

Edit Node / Node Details
--------------------------

.. image:: images/ui-5.jpg
   :width: 80%
   :alt: dashboard
   :align: center

.. image:: images/ui-5-5.png
   :width: 80%
   :alt: dashboard
   :align: center


(1) **Edit** Edit the node's details
(2) **ACLs** View the node's Access Control List (ACL)
(3) **Metrics** View the node's metrics
(4) **Host** View the node's associated host
(5) **Delete** Delete the node
(6) **Endpoint:** The (typically public) IP of the machine, which peers will use to reach it, in combination with the port. If changing this value, make sure Roaming is turned off, since otherwise, the node will check to see if there is a change in the public IP regularly and update it.
(7) **Dynamic Endpoint:** The endpoint may be changed automatically. Switching this off (indicating static endpoint) means the endpoint will stay the same until you change it. This can be good to set if the machine is a server sitting in a location that is not expected to change. It is also good to have this switched off for Remote Access gateway, Egress, and Relay Servers, since they should be in a reliable location.
(8) **Listen Port:** The port used by the node locally. **This value is ignored if UDP Hole Punching is on,** because port is set dynamically every time interface is created. If UDP Hole Punching is off, the port can be set to any reasonable (and available) value you'd like for the local machine.
(9) **IP Address:** The primary private IP address of the node. Assigned automatically by Netmaker but can be changed to whatever you want within the Network CIDR.
(10) **IPv6 Address:** (Only if running dual stack) the primary private IPv6 address of the node. Assigned automatically by Netmaker but can be changed to whatever you want within the Network CIDR.
(11) **Local Address:** The "locally reachable" address of the node. Other nodes will take note of this to see if this node is on the same network. If so, they will use this address instead of the public "Endpoint." If running a few nodes inside of a VPC, home network, or similar, make sure the local address is populated correctly for faster and more secure inter-node communication.
(12) **Node Name:** The name of the node within the network. Hostname by default but can be anything (within the character limits).
(13) **Public Key:** (Uneditable) The public key of the node, distributed to other peers in the network.
(14) **Persistent Keepalive:** How often packets are sent to keep connections open with other peers.
(15) **Last Modified:** Timestamp of the last time the node config was changed.
(16) **Node Expiration Datetime:** If a node should become invalid after a length of time, you can set it in this field, after which time, it will lose access to the network and will not populate to other nodes. Useful for scenarios where temporary access is granted to 3rd parties.
(17) **Last Checkin:** Unix timestamp of the last time the node checked in with the server. Used to determine generic health of node.
(18) **MAC Address:** The hardware Media Access Control (MAC) address of the machine. Used to be used as the unique ID, but is being depreciated.
(19) **Egress Gateway Ranges:** If Egress is enabled, the gateway ranges that this machine routes to.
(20) **Local Range:** If IsLocal has been enabled on the network, this is the local range in which the node will look for a private address from it's local interfaces, to use as an endpoint.
(21) **Node Operating System:** The OS of the machine.
(22) **MTU:** The MTU that the node will use on the interface. If "wg show" displays a valid handshake but pings are not working, many times the issue is MTU. Making this value lower can solve this issue. Some typical values are 1024, 1280, and 1420.
(23) **Network:** The network this node belongs to.
(24) **Node ACL Rule** The current ACL rule for this node in the network
(25) **Is DNS On:** DNS is solely handled by resolvectl at the moment, which is on many Linux distributions. For anything else, this value should remain off. If you wish to configure DNS for non-compatible systems, you must do so manually.
(26) **Is Local:** If on, will only communicate over the local address (Assumes IsLocal tuned to 'yes' on the network level.)
(27) **Connected** Indicates whether the node has is connected to the network


Remote Access
=============

.. image:: images/ui-8.jpg
   :width: 80%
   :alt: dashboard
   :align: center

(1) **Gateway Name / IP Address:** Information about which Node is the Remote Access Gateway.
(2) **Add Client Config:** Button to generate a new Remote Access Client configuration file.
(3) **Client ID:** The randomly-generated name of the client. Click on the ID to change the name to something sensible. 
(4) **IP Address:** The private ip address of the ext client.
(5) **QR Code:** If joining form iOS or Android, open the WireGuard app and scan the QR code to join the network.
(6) **Download Client Configuration:** If joining from a laptop/desktop, download the config file and run "wg-quick up /path/to/config"
(7) **Delete:** Delete the ext client and remove its network access.

DNS
===========

.. image:: images/ui-10.jpg
   :width: 80%
   :alt: dashboard
   :align: center

(1) **DNS Name:** The private DNS entry. Must end in ".<network name>" (added automatically). This avoids conflicts between networks.
(2) **IP Address:** The IP address of the entry. Can be anything (public addresses too!) but typically a node IP.
(3) **Select Node Address:** Select a node name to populate its IP address automatically.

Create / Edit Users
=====================

.. image:: images/ui-11.jpg
   :width: 80%
   :alt: dashboard
   :align: center

(1) **Username:** Specify Username.
(2) **Password:** Specify password.
(3) **Confirm Password:** Confirm password.
(4) **Make Admin:** Make into a server admin or "super admin", which has access to all networks and server-level settings.
(5) **Networks:** If not made into an "admin", select the networks which this user has access to. The user will be a "network admin" of these networks, but other networks will be invisible/unaccessible.


Node Graph
=====================

.. image:: images/node-graph-1.png
   :width: 80%
   :alt: dashboard
   :align: center

View all nodes in your network, zoom in, zoom out, and search for node names.
**hover:** Hover over a node to see its direct connections.



Access Control Lists
=====================


.. image:: images/acls-3.png
   :width: 80%
   :alt: ACLs
   :align: center

(1) **Reset:** Reset your changes without submitting.
(2) **Allow All:** Enable all p2p connections
(3) **Block All:** Disable all p2p connections. Makes building up a Zero Trust network easier.
(4) **(allowed):** Click to switch a connection to "deny." Note that node names are higlighted on the side and top to track location.
(5) **(blocked):** Click to switch a connection to "allow."
(6) **Submit Changes:** Click once you are ready to submit. Will send message to update relevant nodes in network.


User Management
=====================

Netmaker v0.25.0 comes with a revamped user management, for easy onboarding of users (including bulk onboarding) and fine-grained permissioning.

Under the **User Management** section, available for *super admins* and *admins* only, you will see all active users, groups (Pro), roles (Pro), invites and pending users. Ypu can manage users from this section of the dashboard.

.. image:: ./images/users.png
   :width: 80%
   :alt: Users
   :align: center

All active users are listed here. You can search for a user by name or email. You can also see the different groups the user belongs to and their platform access level.

You can view and update a user's details by clicking on the user's name.
From this modal, you can change user details including: password, groups, network roles, and platform access level.

.. image:: images/user-details.png
   :width: 80%
   :align: center
   :alt: User details of a user. You can update the user's details, change their password, ...


Create User
------------

Creating a new user is easy. Click on the **Add a User** button at the top right to begin the process.

There are two ways to create a user:
1. **Basic Auth:** Fill in the user's details and click **Create User**.
2. **User Invite:** Enter the different email addresses of the users you want to invite. They will receive an email with a link to create their account (Ensure you have set up the SMTP client for emailing).


Basic Auth
------------

.. image:: images/create-user-modal-groups.png
   :width: 80%
   :alt: Create User Basic Auth
   :align: center

.. image:: images/create-user-modal-custom-roles.png
   :width: 80%
   :alt: Create User Basic Auth
   :align: center

(1) **Username:** Enter a unique username of the user.
(2) **Password:** Choose a password for the user. User's are advised to change their password after logging in.
(3) **Confirm Password:** Confirm the password for the user.
(4) **Platform Access Level:** Select the platform access level for the user. The platform access level determines the user's access to the platform as a whole, rather than a specific network. Admin/Superadmins are able to access all networks and server-level settings. Platform users are able to access a limited set of the dasboard. Service users are not able to access the dashboard: they are only able to access networks via our RAC app.
(5) **Groups:** Select the groups the user will belong to.
(6) **Additional Roles Per Network:** Select the network roles the user will have per network.


User Invite
------------

.. image:: images/invite-user.png
   :width: 80%
   :alt: Invite Users
   :align: center

(1) **Email Address(es):** Enter the email addresses of the users you want to invite. Separate multiple email addresses with a comma. **No spaces**
(2) **Platform Access Level:** Select the platform access level for the user. The platform access level determines the user's access to the platform as a whole, rather than a specific network.
(3) **Groups:** Select the groups the users will belong to.
(4) **Additional Roles Per Network:** Select the network roles the users will have per network.


After inviting a user, they will receive an email with a link to create their account. The user will be prompted to create a password or continue via OAuth, and will be able to access the platform with the permissions you have set. See screenshots below:

.. image:: images/continue-invite-basic-auth.png
   :width: 80%
   :alt: Invite Email
   :align: center

.. image:: images/continue-invite-sso.png
   :width: 80%
   :alt: Invite Email
   :align: center


User Roles
============

Netmaker v0.25.0 introduces user roles, which allow you to assign specific permissions to users on a per-network basis. This feature is available for Pro users only.

Under the **User Management** section, you will see the **Roles** tab. Here, you can create, edit, and delete roles.

.. image:: images/network-roles.png
   :width: 80%
   :alt: Network Roles
   :align: center


Create Network Role
---------------------

To create a new role, click on the **Create Network Role** button at the top right.

.. image:: images/create-network-role.png
   :width: 80%
   :alt: Create Network Role
   :align: center

(1) **Role Name:** Enter a unique name for the role.
(2) **Network:** Select the network the role will apply to.
(3) **Assign Admin Access To Network:** Check this box to give the user admin access to the network. This will make any user with this role a "network administrator" for the selected network.
(4) **Permissions (VPN Access):** Select the different RAGs (gateways) a user with this role will be able to connect to.
(5) **Create Role:** Click to create the role.

A created network role can be viewed and edited by clicking on the role name in the roles list.
It can also be deleted from the list/table view.


User Groups
============

Netmaker v0.25.0 re-introduces user groups, which allow you to group users together and assign permissions to the group. This feature is available for Pro users only.
A group, in theory, is simply a collection or network roles. A group can have multiple users (members) and multiple roles.

Under the **User Management** section, you will see the **Groups** tab. Here, you can create, edit, and delete groups.

.. image:: images/groups.png
   :width: 80%
   :alt: Groups
   :align: center


Create Group
----------------

To create a new group, click on the **Create Group** button at the top right.

.. image:: images/create-group.png
   :width: 80%
   :alt: Create Group
   :align: center

(1) **Group Name:** Enter a unique name for the group.
(2) **Description:** Enter a description for the group.
(3) **Associated Network Roles:** Select the roles the group will have, for each network. A group can have multiple roles.
(4) **Group Members:** Select the users that will be members of the group.
(5) **Create Group:** Click to create the group.

A created group can be viewed and edited by clicking on the group name in the groups list.
It can also be deleted from the list/table view.


User Invites
===============

Under the **User Management** section, you will see the **Invites** tab. Here, you can view all invites and send new invites.

.. image:: images/invites.png
   :width: 80%
   :alt: Invites
   :align: center

Each invite has a unique magic link that can be used to create an account. This link can be sent to the invitee via email or other means.

You can clear all invites by clicking on the **Clear All Invites** button at the top right, or delete individual invites by clicking on the **Delete** button next to the invite.


Pending Users
===============

Under the **User Management** section, you will see the **Pending Users** tab. Here, you can view all pending users and approve or reject them.

.. image:: images/pending-users.png
   :width: 80%
   :alt: Pending Users
   :align: center

Pending users automatically join the platform as *service users* by default. This means they can only access networks via the RAC app.
Their permissions can be changed by an admin or superadmin after approval.

You can approve or reject pending users by clicking on the **Approve** or **Reject** button next to the user.
You can also deny all pending users by clicking on the **Deny All Users** button at the top right.
