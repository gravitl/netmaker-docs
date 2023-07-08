=====================================
Turn Servers
=====================================

Introduction
===============



A TURN (Traversal Using Relays around NAT) server is a type of server used in peer-to-peer communication protocols to facilitate communication between devices that are located behind a network address translator (NAT).

NAT is commonly used in home and office networks to allow multiple devices to share a single public IP address. While this can be an effective way to conserve IP addresses, it can cause problems for certain types of communication protocols, including peer-to-peer communication protocols such as Voice over IP (VoIP) and video conferencing.

When two devices behind different NATs want to communicate directly, they often cannot establish a direct connection due to the NATs blocking incoming connections. A TURN server can act as a relay between the two devices, allowing them to establish a communication channel through the server.

TURN servers work by relaying data between two devices. When a device behind a NAT wants to communicate with a device on the public Internet, it sends its data to the TURN server. The TURN server then relays the data to the other device, and the other device sends its response back through the TURN server to the first device. This allows the two devices to communicate without needing to establish a direct connection.

While TURN servers can be useful for facilitating peer-to-peer communication between devices behind NATs, they can also introduce latency and increase bandwidth usage. It's important to carefully consider the use of TURN servers in any communication protocol to ensure that they are used effectively and efficiently.

Implementing the Netmaker TURN server
=====================================

If you are starting out making a new netmaker server, you can just folow the installation instructions. :doc:`Quick Install<./quick-start>`

If You have an existing installation and would like to add a TURN server, You will need to make some changes to your docker-compose.yml and Caddyfile. These changes work with both Community edition and Enterprise edition. There is also an option to turn the TURN server on and off, so if you decide not to use it anymore, you can just switch it off.

You should probably backup your docker-compose file at this point. That way, if you need to start over or want to revert the changes, you can just copy the backup.

Start with your docker-compose.yml file. In the netmaker section you will need to add the following to the environment variables.

.. code-block:: yaml

    TURN_SERVER_HOST: "turn.NETMAKER_BASE_DOMAIN"
    TURN_SERVER_API_HOST: "https://turnapi.NETMAKER_BASE_DOMAIN"
    TURN_PORT: "3479"
    TURN_USERNAME: "REPLACE_TURN_USERNAME"
    TURN_PASSWORD: "REPLACE_TURN_PASSWORD"
    USE_TURN: "true"

In the caddy section of the docker-compose.yml file, add the following below ``restart: unless-stopped``

.. code-block:: yaml

    extra_hosts:
      - "host.docker.internal:host-gateway"

You will also need to add a turn section to your compose file. place the following above the volumes:

.. code-block:: yaml

    turn:
      container_name: turn
      image: gravitl/turnserver:v1.0.0
      network_mode: "host"
      volumes:
        - turn_server:/etc/config
      environment:
        DEBUG_MODE: "off"
        VERBOSITY: "1"
        TURN_PORT: "3479"
        TURN_API_PORT: "8089"
        CORS_ALLOWED_ORIGIN: "*"
        TURN_SERVER_HOST: "turn.NETMAKER_BASE_DOMAIN"
        USERNAME: "REPLACE_TURN_USERNAME"
        PASSWORD: "REPLACE_TURN_PASSWORD"

Replace the ``NETMAKER_BASE_DOMAIN`` with your domain and ``REPLACE_TURN_USERNAME`` and ``REPLACE_TURN_PASSWORD`` with your desired username and password. make sure that they match in the netmaker section and the turn section.

The final part in your docker-compose.yml file will be adding a volume. in the volumes section at the bottom of the file, add the following:

.. code-block:: yaml

    turn_server: {}


You will then need to make the following additions to your Caddyfile:

.. code-block:: cfg 
    
    # TURN
    https://turn.NETMAKER_BASE_DOMAIN {
	    reverse_proxy host.docker.internal:3479
    }

    #TURN API
    https://turnapi.NETMAKER_BASE_DOMAIN {
        reverse_proxy http://host.docker.internal:8089
    }

You can then ``docker-compose down && docker-compose up -d``

You can verify the working turn server with ``docker logs turn``. You should see an output similar to this:

.. code-block:: cfg 

    [turnserver] 2023-05-07 20:19:03 Netmaker Turn Version (v1.0.0) 
    [turnserver] 2023-05-07 20:19:03 REST Server (Version: v1.0.0) successfully started on port (8089)  
    2023/05/07 20:19:03 Server 0 listening on [::]:3479
    2023/05/07 20:19:03 Server 1 listening on [::]:3479
    2023/05/07 20:19:03 Server 2 listening on [::]:3479
    2023/05/07 20:19:03 Server 3 listening on [::]:3479
    2023/05/07 20:19:03 Server 4 listening on [::]:3479

Your turn server should be up and running at this point. You should be able to see a connection in difficult setups like a double NAT or asymetrical NAT. As mentioned before You should expect a bit of latency with the extra hop from peer to TURN to peer.

