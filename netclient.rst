================================
Netclient Setup
================================

The Netclient manages WireGuard on client devices (nodes). This document walks through setting up the netclient on machines, including install, management, and uninstall.

The Netclient is supported on the following operating systems:
- Linux (most distributions)
- Windows
- Mac
- FreeBSD

For unsupported devices, please use the external client, which is just a static, vanilla, WireGuard configuration file, which can be added to any device that supports WireGuard.

******************
Installation
******************


Before adding the machine to a network, the netclient must be installed. A successful installation sets up the netclient executable on the machine and adds it as a system daemon. The daemon will listen for changes for any network it joins.

The client install **does not** add the client as a member of any network. Once the client is installed, you must run:

.. code-block::

  netclient join -t <token>

The following are install instructions for most operating systems.

Linux
=============

Debian Distros (debian/ubuntu/mint/pop-os)
------------------------------------------------------

.. code-block::

  curl -sL 'https://apt.netmaker.org/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/netclient.asc
  curl -sL 'https://apt.netmaker.org/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/netclient.list
  sudo apt update
  sudo apt install netclient


Red Hat Distros (fedora/redhat/centos/rocky)
---------------------------------------------------------------------

.. code-block::

  curl -sL 'https://rpm.netmaker.org/gpg.key' | sudo tee /tmp/gpg.key
  curl -sL 'https://rpm.netmaker.org/netclient-repo' | sudo tee /etc/yum.repos.d/netclient.repo
  sudo rpm --import /tmp/gpg.key
  sudo dnf check-update
  sudo dnf install netclient

Arch Distros (arch/manjaro/endeavouros)
------------------------------------------------

.. code-block::

  yay -S netclient

Windows
===============

PowerShell script
------------------

.. code-block::

  . { iwr -useb  https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/netclient-install.ps1 } | iex; Netclient-Install -version "<your netmaker version>"

MSI Installer
--------------

Download Link: https://fileserver.netmaker.org/latest/windows/netclient_x86.msi 

Mac
============

Brew Install
---------------

.. code-block::

  brew tap gravitl/netclient
  (optional) brew audit netclient
  brew install netclient

GUI Installer
---------------

Download Link: https://fileserver.netmaker.org/latest/darwin/Netclient.pkg

FreeBSD
=============

A FreeBSD package is coming soon. In the meantime, please use this install script:

.. code-block::

  curl -sfL https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/netclient-install.sh | VERSION="<your netmaker version>" sh -

Docker
=============

You can run Netclient using Docker instead of installing it on your local machine.  To ensure that the correct commands are present in order to use Docker use these steps:

.. code-block::

  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose 

After that you can proceed to join the network using the docker command from the access key for the network you wish to join.  The docker command is available from the access key view in the Netmaker UI.  To have the netclient docker container restart (eg after the system reboots) you'll want to use the following option when running docker run:

.. code-block::

  --restart=always


If you prefer (e.g., when specifying a lot of environment variables), you can use a docker-compose.yml file such as the following instead of the docker run command:

.. code-block::

  version: "3.4"

  services:
      netclient:
          network_mode: host
          privileged: true
          restart: always
          environment:
              - TOKEN=<networktoken>
          volumes:
              - '/etc/netclient:/etc/netclient'
          container_name: netclient
          image: 'gravitl/netclient:v0.16.3'

where <networktoken> is the Access Token available from the "Viewing your Access Key Details" window in the Netmaker UI.




Environment Variables
===================================

In order to provide additional options to Netclient you can use the following environment variables in lieu of the listed command-line option (these options are provided by running 

.. code-block::

  netclient <command> --help 
  
where <command> is a command such as join.

===========================================                 =======================                                     ==================================================================================================================================================             
Command-line option                                         Environment Variable                                        Description                                                                                                                                                            
===========================================                 =======================                                     ==================================================================================================================================================             
--network value, -n value                                   NETCLIENT_NETWORK                                           Network to perform specified action against. (default: "all")                                                                                                          
--password value, -p value                                  NETCLIENT_PASSWORD                                          Password for authenticating with netmaker.                                                                                                                             
--endpoint value, -e value                                  NETCLIENT_ENDPOINT                                          Reachable (usually public) address for WireGuard (not the private WG address).                                                                                         
--macaddress value, -m value                                NETCLIENT_MACADDRESS                                        Mac Address for this machine. Used as a unique identifier within Netmaker network.                                                                                     
--publickey value, --pubkey value                           NETCLIENT_PUBLICKEY                                         Public Key for WireGuard Interface.                                                                                                                                    
--privatekey value, --privkey value                         NETCLIENT_PRIVATEKEY                                        Private Key for WireGuard Interface.                                                                                                                                   
--port value                                                NETCLIENT_PORT                                              Port for WireGuard Interface.                                                                                                                                          
--keepalive value                                           NETCLIENT_KEEPALIVE                                         Default PersistentKeepAlive for Peers in WireGuard Interface. (default: 0)                                                                                             
--operatingsystem value, --os value                         NETCLIENT_OS                                                Identifiable name for machine within Netmaker network.                                                                                                                 
--publicipservice value, --ip-service value                 NETCLIENT_IP_SERVICE                                        The service to call to obtain the public IP of the machine that is running netclient.                                                                                  
--name value                                                NETCLIENT_NAME                                              Identifiable name for machine within Netmaker network. (default: "do-docs-netclient")                                                                                  
--localaddress value                                        NETCLIENT_LOCALADDRESS                                      Local address for machine. Can be used in place of Endpoint for machines on the same LAN.                                                                              
--isstatic value, --st value                                NETCLIENT_IS_STATIC                                         Indicates if client is static by default (will not change addresses automatically).                                                                                    
--address value, -a value                                   NETCLIENT_ADDRESS                                           WireGuard address for machine within Netmaker network.                                                                                                                 
--addressIPv6 value, --a6 value                             NETCLIENT_ADDRESSIPV6                                       WireGuard address for machine within Netmaker network.                                                                                                                 
--interface value, -i value                                 NETCLIENT_INTERFACE                                         WireGuard local network interface name.                                                                                                                                
--apiserver value                                           NETCLIENT_API_SERVER                                        Address + API Port (e.g. 1.2.3.4:8081) of Netmaker server.                                                                                                             
--key value, -k value                                       NETCLIENT_ACCESSKEY                                         Access Key for signing up machine with Netmaker server during initial 'add'.                                                                                           
--token value, -t value                                     NETCLIENT_ACCESSTOKEN                                       Access Token for signing up machine with Netmaker server during initial 'add'.                                                                                         
--server value, -s value                                    HOST_SERVER                                                 Host server (domain of API) [Example: api.example.com]. Do not include "http(s)://" use it for the Single Sign-on along with the network parameter                     
--user value, -u value                                      USER_NAME                                                   User name provided upon joins if joining over basic auth is desired.                                                                                                   
--localrange value                                          NETCLIENT_LOCALRANGE                                        Local Range if network is local, for instance 192.168.1.0/24.                                                                                                          
--dnson value                                               NETCLIENT_DNS                                               Sets private dns if 'yes'. Ignores if 'no'. Will retrieve from network if unset. (default: "yes")                                                                      
--islocal value                                             NETCLIENT_IS_LOCAL                                          Sets endpoint to local address if 'yes'. Ignores if 'no'. Will retrieve from network if unset.                                                                         
--udpholepunch value                                        NETCLIENT_UDP_HOLEPUNCH                                     Turns on udp holepunching if 'yes'. Ignores if 'no'. Will retrieve from network if unset.                                                                              
--ipforwarding value                                        NETCLIENT_IPFORWARDING                                      Sets ip forwarding on if 'on'. Ignores if 'off'. On by default. (default: "on")                                                                                        
--postup value                                              NETCLIENT_POSTUP                                            Sets PostUp command for WireGuard.                                                                                                                                     
--postdown value                                            NETCLIENT_POSTDOWN                                          Sets PostDown command for WireGuard.                                                                                                                                   
--daemon value                                              NETCLIENT_DAEMON                                            Installs daemon if 'on'. Ignores if 'off'. On by default. (default: "on")                                                                                              
--roaming value                                             NETCLIENT_ROAMING                                           Checks for IP changes if 'yes'. Ignores if 'no'. Yes by default. (default: "yes")                                                                                      
--verbosity-level-1, -v                                     VERBOSITY=1                                                 Netclient Verbosity level 1. (default: false)                                                                                                                          
--verbosity-level-2, --vv                                   VERBOSITY=2                                                 Netclient Verbosity level 2. (default: false)                                                                                                                          
--verbosity-level-3, --vvv                                  VERBOSITY=3                                                 Netclient Verbosity level 3. (default: false)                                                                                                                          
--verbosity-level-4, --vvvv                                 VERBOSITY=4                                                 Netclient Verbosity level 4. (default: false)                                                                                                                          
===========================================                 =======================                                     ==================================================================================================================================================             


******************
Joining a Network
******************

With a token:

.. code-block::

  netclient join -t <token>

With username/password:

.. code-block::

  netclient join -n <net name> -u <username> -s api.<netmaker domain>
  (example: netclient join -n mynet -u admin -s api.nm.example-domain.io)

With SSO (oauth must be configured):

.. code-block::

  netclient join -n <net name> -s api.<netmaker domain>


Use the -vvv flag if installation fails and report logs.

With docker:

.. code-block::

  docker run -d --network host  --privileged -e TOKEN=<TOKEN> -v /etc/netclient:/etc/netclient --name netclient gravitl/netclient:<CURRENT_VERSION>

*********************
Managing Netclient
*********************

Connecting/Disconnecting from a network:

.. code-block::

  netclient connect -n network
  netclient disconnect -n network

You can also disconnect and reconnect from the UI. Click on the node you want to disconnect/reconnect and click on edit.

On the bottom, you should see a switch labeled connected like this one. toggle the switch to what you like, and hit submit. That client will connect or disconnect accordingly

.. image:: images/disconnect.png
  :width: 80%
  :alt: connect/disconnect button
  :align: center

If you disconnected from the CLI, This switch should be off.

Leave a network:

.. code-block::

  netclient leave -n network

List Networks:

.. code-block::

  netclient list | jq


******************
Uninstalling
******************

Leave a network:

Uninstall from CLI:

.. code-block::

  netclient uninstall

Uninstall using package manager (use equivalent command for your OS):

.. code-block::

  apt remove netclient
