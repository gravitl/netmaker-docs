================================
NMCTL
================================

NMCTL is a CLI tool for interacting with the Netmaker API.

******************
Quick Start
******************

Start with getting the latest nmctl binary specific to your operating system from the link below:

.. code-block::

  https://github.com/gravitl/netmaker/releases/latest

Make sure the binary is executable with ``chmod +x nmctl`` and then move it into your /usr/sbin folder.

If everything is setup ok, you should be able to type ``nmctl`` and see the following:

.. code-block::

  CLI for interacting with Netmaker Server

  Usage:
    nmctl [command]

  Available Commands:
    acl             Manage Access Control Lists (ACLs)
    completion      Generate the autocompletion script for the specified shell
    context         Manage various netmaker server configurations
    dns             Manage DNS entries associated with a network
    enrollment_key  Manage Enrollment Keys
    ext_client      Manage External Clients
    help            Help about any command
    host            Manage hosts
    logs            Retrieve server logs
    metrics         Fetch metrics of nodes/networks
    network         Manage Netmaker Networks
    network_user    Manage Network Users
    node            Manage nodes associated with a network
    server          Get netmaker server information
    user            Manage users and permissions
    usergroup       Manage User Groups

  Flags:
    -h, --help   help for nmctl

  Use "nmctl [command] --help" for more information about a command.

Your CLI should be ready to go at this point.


Context
=============

Before running any commands, a context has to be set which stores the API endpoint information. This allows the CLI to know which server to communicate with, and the user account to use.

NMCLI supports connecting to both standalone (self-hosted) and SaaS(managed) tenants. This is specified with a flag. More details below.


Connecting to standalone (self-hosted) tenants
----------------------------------------------

Assuming your tenant is hosted at `https://api.netmaker.example.com`

You can use your `username` and `password` that you use to sign in to the dashboard UI to set the context. Then you can set the CLI to use that context.

.. code-block::

  nmctl context set <context name> --endpoint=https://api.netmaker.example.com  --username=<username> --password=<password>  # create the context
  nmctl context use <context name>  # apply the created context

You can also authenticate via OAuth with the following:

.. code-block::

  nmctl context set <context name> --endpoint=https://api.netmaker.example.com  --sso  # create the context for OAuth (Social Sign On)
  nmctl context use <context name>  # apply the created context


Connecting to SaaS (managed) tenants
------------------------------------

You can also authenticate with a managed (SaaS) tenant with the following commands:

.. code-block::

  nmctl context set <context name> --saas --tenant_id=<tenant ID> --username=<username> --password=<password>  # create the context
  nmctl context use <context name>  # apply the created context

You can also authenticate via OAuth with the following:

.. code-block::

  nmctl context set <context name> --saas --sso --tenant_id=<tenant ID>  # create the context for OAuth (Social Sign On)
  nmctl context use <context name>  # apply the created context


List and switch between contexts
--------------------------------

You can see a list of all your contexts that you have created with the following:

.. code-block::

  nmctl context list

That list also tells you what context/tenant is currently selected.

You can switch to a different context by using the `use` subcommand:

.. code-block:: 

  nmctl context use <context name>


Delete contexts
---------------

You can delete a context with the following:

.. code-block::

  nmctl context delete <context name>


Network
=============

Create a network with the name `test_net` and CIDR `10.11.13.0/24`.

.. code-block::

  nmctl network create --name="test_net" --ipv4_addr="10.11.13.0/24"

Fetch details of the created network.

.. code-block::

  nmctl network list
  +----------+----------------------+----------------------+---------------------------+---------------------------+
  |  NETID   | ADDRESS RANGE (IPV4) | ADDRESS RANGE (IPV6) |   NETWORK LAST MODIFIED   |    NODES LAST MODIFIED    |
  +----------+----------------------+----------------------+---------------------------+---------------------------+
  | test_net | 10.11.13.0/24        |                      | 2022-12-14T13:08:47+05:30 | 2022-12-14T13:08:47+05:30 |
  +----------+----------------------+----------------------+---------------------------+---------------------------+

Access Key
=============

Create an access key for the created network with 100 uses. This key shall be used by nodes to join the network `test_net`.

.. code-block::

  nmctl keys create test_net 100
  {
    "name": "key-818a4ac3fe85a9d0",
    "value": "f0edf9ef08fa2b1a",
    "accessstring": "eyJhcZljb25uc3RyaW5nIjoiYXBpLm5ldG1ha2VyLmV6ZmxvLmluOjQ0MyIsIm5ldHdvcmsiOiJ0ZXN0X25ldCIsImtleSI6ImYwZWRmOWVmMDhmYTJiMWEiLCJsb2NhbHJhbmdlIjoiIn0=",
    "uses": 100,
    "expiration": null
  }

Nodes
=============

Connect a node to the network using :doc:`netclient <./netclient>` and the access key created above. Use the `accessstring` as token.

.. code-block::

  netclient join -t <token>

List all nodes. This displays information about each node such as the address assigned, id, name etc

.. code-block::

  nmctl node list
  +--------------+---------------------------+---------+----------+--------+---------+-------+--------------------------------------+
  |     NAME     |         ADDRESSES         | VERSION | NETWORK  | EGRESS | INGRESS | RELAY |                  ID                  |
  +--------------+---------------------------+---------+----------+--------+---------+-------+--------------------------------------+
  | test_node    | 10.11.13.254              | v0.17.0 | test_net | no     | no      | no    | 938d7861-55fc-40a9-970d-6d70acfc3a80 |
  +--------------+---------------------------+---------+----------+--------+---------+-------+--------------------------------------+

Using nmctl, we can turn the node into egress, ingress or a relay. Lets turn the node into an ingress by supplying the network name and node id as parameters.

.. code-block::

  nmctl node create_ingress test_net 938d7861-55fc-40a9-970d-6d70acfc3a80

Fetching the node list once again we can see that our node has been turned into an ingress.

.. code-block::

  nmctl node list
  +--------------+---------------------------+---------+----------+--------+---------+-------+--------------------------------------+
  |     NAME     |         ADDRESSES         | VERSION | NETWORK  | EGRESS | INGRESS | RELAY |                  ID                  |
  +--------------+---------------------------+---------+----------+--------+---------+-------+--------------------------------------+
  | test_node    | 10.11.13.254              | v0.17.0 | test_net | no     | yes     | no    | 938d7861-55fc-40a9-970d-6d70acfc3a80 |
  +--------------+---------------------------+---------+----------+--------+---------+-------+--------------------------------------+


External Clients
==================

Adding an :doc:`external client <./external-clients>` to the network is just as easy. Requires the `network name` and `node id` as input parameters.

.. code-block::

  nmctl ext_client create test_net 938d7861-55fc-40a9-970d-6d70acfc3a80
  Success

List all available external clients.

.. code-block::

  nmctl ext_client list
  +--------------+---------+--------------+--------------+---------+-------------------------------+
  |  CLIENT ID   | NETWORK | IPV4 ADDRESS | IPV6 ADDRESS | ENABLED |         LAST MODIFIED         |
  +--------------+---------+--------------+--------------+---------+-------------------------------+
  | limp-chicken |test_net | 10.11.13.2   |              | true    | 2022-11-23 18:28:57 +0530 IST |
  +--------------+---------+--------------+--------------+---------+-------------------------------+

The wireguard config of an external client can also be fetched with the `network name` and `external client id`.

.. code-block::

  nmctl ext_client config test_net limp-chicken

  [Interface]
  Address = 10.11.13.2/32
  PrivateKey = 4Ojhsn/uLcH6xta6zqokQ+GiRuZwesdzE2hDSa6vYWc=
  MTU = 1280


  [Peer]
  PublicKey = h96G9R8qqHIm6OfFgIZNBlRE5uCumkSZv4Pwn2DVXEs=
  AllowedIPs = 10.11.13.0/24
  Endpoint = 138.209.145.214:51824
  PersistentKeepalive = 20


ACLs
=====

Access Control between hosts can be managed via the NMCTL CLI. These settings allow the network admin to specify which hosts are allowed to communicate between each other.

List
----

To list all access control settings for a network:

.. code-block:: 

  nmctl acl list <network>

Allow/Deny
----------

To allow communication between two hosts on a network:

.. code-block:: 

  nmctl acl allow <network> <host 1 ID> <host 2 ID>

To deny communication between two hosts:

.. code-block:: 

  nmctl acl deny <network> <host 1 ID> <host 2 ID>

Host IDs can be retrieved with the `nmctl node list` command.

The global `--output` flag can be used to format how a network's ACLs are outputted.


Help
=======

Further information about any subcommand is available using the **--help** flag

.. code-block::

  nmctl subcommand --help

Example:-

.. code-block::

  nmctl node --help
  Manage nodes associated with a network

  Usage:
    nmctl node [command]

  Available Commands:
    create_egress  Turn a Node into a Egress
    create_ingress Turn a Node into a Ingress
    create_relay   Turn a Node into a Relay
    delete         Delete a Node
    delete_egress  Delete Egress role from a Node
    delete_ingress Delete Ingress role from a Node
    delete_relay   Delete Relay role from a Node
    get            Get a node by ID
    list           List all nodes
    uncordon       Get a node by ID
    update         Update a Node

  Flags:
    -h, --help     help for node

  Use "nmctl node [command] --help" for more information about a command.