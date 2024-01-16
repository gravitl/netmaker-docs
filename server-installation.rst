=================================
Advanced Server Installation
=================================

This section outlines installing the Netmaker server, including Netmaker, Netmaker UI, rqlite, and CoreDNS.

System Compatibility
====================

Netmaker requires elevated privileges on the host machine to perform network operations. Netmaker must be able to modify interfaces and set firewall rules using iptables. 

Typically, Netmaker is run inside of containers, using Docker or Kubernetes. 

Netmaker can be run without containers, but this is not recommended. You must run the Netmaker binary, CoreDNS binary, database, and a web server directly on the host.

Each of these components has its own individual requirements and the management complexity increases exponentially by running outside of containers.

For first-time installs, we recommend the quick install guide. The following documents are meant for more advanced installation environments and are not recommended for most users. However, these documents can be helpful in customizing or troubleshooting your own installation. 

.. _server-configuration-reference:

Server Configuration Reference
==========================================

Netmaker sets its configuration in the following order of precedence:  

1. **Environment Variables:** Typically values set in the Docker Compose. This is the most common way of setting server values.
2. **Config File:** Values set in the ``config/environments/*.yaml`` file.
3. **Defaults:** Default values set on the server if no value is provided in configuration.  

In most situations, if you wish to modify a server setting, set it in the netmaker.env file, then run "docker kill netmaker" and "docker-compose up -d".

Variable Description
----------------------

SERVER_NAME
    **Default:** ""

    **Description:**  MUST SET THIS VALUE. This is the public, resolvable DNS name of the MQ Broker. For instance: broker.netmaker.example.com.

SERVER_HOST
    **Default:** (Server detects the public IP address of machine)

    **Description:** The public IP of the server where the machine is running. 

SERVER_API_CONN_STRING
    **Default:** ""

    **Description:**  MUST SET THIS VALUE. This is the public, resolvable address of the API, including the port. For instance: api.netmaker.example.com:443.

COREDNS_ADDR
    **Default:** ""

    **Description:** The public IP of the CoreDNS server. Will typically be the same as the server where Netmaker is running (same as SERVER_HOST).


SERVER_HTTP_HOST
    **Default:** Equals SERVER_HOST if set, "127.0.0.1" if SERVER_HOST is unset.
    
    **Description:** Should be the same as SERVER_API_CONN_STRING minus the port.

API_PORT:
    **Default:** 8081 

    **Description:** Should be the same as the port on SERVER_API_CONN_STRING in most cases. Sets the port for the API on the server.

MASTER_KEY:  
    **Default:** "secretkey" 

    **Description:** The admin master key for accessing the API. Change this in any production installation.

CORS_ALLOWED_ORIGIN:  
    **Default:** "*"

    **Description:** The "allowed origin" for API requests. Change to restrict where API requests can come from.

REST_BACKEND:  
    **Default:** "on" 

    **Description:** Enables the REST backend (API running on API_PORT at SERVER_HTTP_HOST). Change to "off" to turn off.

DNS_MODE:  
    **Default:** "off"

    **Description:** Enables DNS Mode, meaning config files will be generated for CoreDNS.

DATABASE:  
    **Default:** "sqlite"

    **Description:** Specify db type to connect with. Currently, options include "sqlite", "rqlite", and "postgres".

SQL_CONN:
    **Default:** "http://"

    **Description:** Specify the necessary string to connect with your local or remote sql database.

SQL_HOST:
    **Default:** "localhost"

    **Description:** Host where postgres is running.

SQL_PORT:
    **Default:** "5432"

    **Description:** port postgres is running.

SQL_DB:
    **Default:** "netmaker"

    **Description:** DB to use in postgres.

SQL_USER:
    **Default:** "postgres"

    **Description:** User for postgres.

SQL_PASS:
    **Default:** "nopass"

    **Description:** Password for postgres.

RCE:  
    **Default:** "off"

    **Description:** The server enables you to set PostUp and PostDown commands for nodes, which is standard for WireGuard with wg-quick, but is also **Remote Code Execution**, which is a critical vulnerability if the server is exploited. Because of this, it's turned off by default, but if turned on, PostUp and PostDown become editable.

DISPLAY_KEYS
    **Default:** "on"

    **Description:** If "on", will allow you to always show the key values of "access keys". This could be considered a vulnerability, so if turned "off", will only display key values once, and it is up to the users to store the key values locally.

NODE_ID
    **Default:** <system mac addres>

    **Description:** This setting is used for HA configurations of the server, to identify between different servers. Nodes are given ID's like netmaker-1, netmaker-2, and netmaker-3. If the server is not HA, there is no reason to set this field.

TELEMETRY
    **Default:** "on"

    **Description:** If "on", the server will send anonymous telemetry data once daily, which is used to improve the product. Data sent includes counts (integer values) for the number of nodes, types of nodes, users, and networks. It also sends the version of the server.

MQ_HOST 
    **Default:** (public IP of server)

    **Description:** The address of the mq server. If running from docker compose it will be "mq". If using "host networking", it will find and detect the IP of the mq container. Otherwise, need to input address. If not set, it will use the public IP of the server. The port 1883 will be appended automatically. This is the expected reachable port for MQ and cannot be changed at this time.

HOST_NETWORK: 
    **Default:** "off"

    **Description:** Whether or not host networking is turned on. Only turn on if configured for host networking (see docker-compose.hostnetwork.yml). Will set host-level settings like iptables and forwarding for MQ.

MANAGE_IPTABLES: 
    **Default:** "on"

    **Description:** # Allows netmaker to manage iptables locally to set forwarding rules. Largely for DNS or SSH forwarding (see below). It will also set a default "allow forwarding" policy on the host. It's better to leave this on unless you know what you're doing.

PORT_FORWARD_SERVICES: 
    **Default:** ""

    **Description:** Comma-separated list of services for which to configure port forwarding on the machine. Options include "mq,dns,ssh". MQ IS DEPRECIATED, DO NOT SET THIS.'ssh' forwards port 22 over WireGuard, enabling ssh to server over WireGuard. However, if you set the Netmaker server as an Remote Access Gateway (ingress), this will break SSH on Remote Access Clients, so be careful. DNS enables private DNS over WireGuard. If you would like to use private DNS with ext clients, turn this on.

VERBOSITY:
    **Default:** 0

    **Description:** Specify the level of logging you would like on the server. Goes up to 3 for debugging. If you run into issues, up the verbosity.


Config File Reference
-----------------------
A config file may be placed under config/environments/<env-name>.yml. To read this file at runtime, provide the environment variable NETMAKER_ENV at runtime. For instance, dev.yml paired with ENV=dev. Netmaker will load the specified Config file. This allows you to store and manage configurations for different environments. Below is a reference Config File you may use.

.. literalinclude:: ./examplecode/dev.yaml
  :language: YAML

Compose File - Annotated
--------------------------------------

All environment variables and options are enabled in this file. It is the equivalent to running the "full install" from the above section. However, all environment variables are included and are set to the default values provided by Netmaker (if the environment variable was left unset, it would not change the installation). Comments are added to each option to show how you might use it to modify your installation.

As of v0.18.0, netmaker now uses a stun server (Session Traversal Utilities for NAT). This provides a tool for communications protocols to detect and traverse NATs that are located in the path between two endpoints. By default, netmaker uses publicly available STUN servers.  You are free to set up your own stun severs and use those to augment/replace the public STUN servers. Update the STUN_LIST to list the STUN servers you wish to use. Two resources for installing your own STUN server are:

https://ourcodeworld.com/articles/read/1175/how-to-create-and-configure-your-own-stun-turn-server-with-coturn-in-ubuntu-18-04

https://cloudkul.com/blog/how-to-install-turn-stun-server-on-aws-ubuntu-20-04/


There are also some environment variables that have been changed, or removed. Your updated docker-compose and .env files should look like this.

.. literalinclude:: ./examplecode/docker-compose.v0.20.3.yml
  :language: YAML

.. literalinclude:: ./examplecode/netmaker.default.env
  :language: YAML   

Our Caddy file has gone through some minor changes as well. There needs to be a block for the TURN server. The file should look like this.

.. code-block:: cfg

    {
       
        email YOUR_EMAIL
    }

    # Dashboard
    https://dashboard.NETMAKER_BASE_DOMAIN {
        # Apply basic security headers
        header {
                # Enable cross origin access to *.NETMAKER_BASE_DOMAIN
                Access-Control-Allow-Origin *.NETMAKER_BASE_DOMAIN
                # Enable HTTP Strict Transport Security (HSTS)
                Strict-Transport-Security "max-age=31536000;"
                # Enable cross-site filter (XSS) and tell browser to block detected attacks
                X-XSS-Protection "1; mode=block"
                # Disallow the site to be rendered within a frame on a foreign domain (clickjacking protection)
                X-Frame-Options "SAMEORIGIN"
                # Prevent search engines from indexing
                X-Robots-Tag "none"
                # Remove the server name
                -Server
        }

        reverse_proxy http://netmaker-ui
    }

    # API
    https://api.NETMAKER_BASE_DOMAIN {
            reverse_proxy http://netmaker:8081
    }
    
    # TURN
    https://turn.NETMAKER_BASE_DOMAIN {
        reverse_proxy host.docker.internal:3479
    }

    #TURN API
    https://turnapi.NETMAKER_BASE_DOMAIN {
            reverse_proxy http://host.docker.internal:8089
    }

    # MQ
    wss://broker.NETMAKER_BASE_DOMAIN {
            reverse_proxy ws://mq:8883
    }

Available docker-compose files
---------------------------------

The default options for docker-compose can be found here: https://github.com/gravitl/netmaker/tree/master/compose

The following is a brief description of each:

- `docker-compose.yml <https://github.com/gravitl/netmaker/blob/master/compose/docker-compose.yml>`_ -= This maintains the most recommended setup at the moment, using the caddy proxy.

- `docker-compose.pro.yml <https://github.com/gravitl/netmaker/blob/master/compose/docker-compose.pro.yml>`_ -= This is the compose file needed for Netmaker Professional. You will need a licence and tenant id from `Netmaker's licence dashboard <https://account.netmaker.io/>`_ .



.. _Emqx:

EMQX
=====

Netmaker offers an EMQX option as a broker for your server. The main configuration changes between mosquitto and EMQX is going to take place in the docker-compose.yml, netmaker.env and the Caddyfile.

You can find the EMQX docker-compose file `in the netmaker repo <https://github.com/gravitl/netmaker/blob/master/compose/docker-compose-emqx.yml>`_.

You should not need to make any changes to the docker-compose-emqx.yml file. Just download this file using the command provided below on the same directory as netmaker.env file. It will grab information from the netmaker.env file.

.. code-block::

    wget https://raw.githubusercontent.com/gravitl/netmaker/master/compose/docker-compose-emqx.yml

In your Caddyfile, the only change you need to make is in the mq block.

.. code-block:: cfg
    
    # MQ
    wss://broker.{$NM_DOMAIN} {
        reverse_proxy ws://mq:8083
    }

basically just replace the port number on line ``reverse_proxy ws://mq:8883`` with ``8083`` emqx websocket port number.

In your netmaker.env file, just replace the line ``SERVER_BROKER_ENDPOINT="ws://mq:1883"`` with ``SERVER_BROKER_ENDPOINT=ws://mq:8083/mqtt``. Basically just change the port to 8083 and add /mqtt after that.

In your docker-compose.yml file, add ``/mqtt`` at the end of this line ``BROKER_ENDPOINT=wss://broker.${NM_DOMAIN}`` which results in ``BROKER_ENDPOINT=wss://broker.${NM_DOMAIN}/mqtt``.

.. code-block:: yaml
    
    - BROKER_ENDPOINT=wss://broker.${NM_DOMAIN}/mqtt
    - BROKER_TYPE=emqx
    - EMQX_REST_ENDPOINT=http://mq:18083

Then two new lines ``- BROKER_TYPE=emqx`` and ``- EMQX_REST_ENDPOINT=http://mq:18083`` needs to be added after the line ``- BROKER_ENDPOINT=wss://broker.${NM_DOMAIN}/mqtt`` as shown above.

If you are using a professional server, you will need to make changes to your netmaker-exporter section in your docker-compose.override.yml file.

.. code-block:: yaml

    netmaker-exporter:
        container_name: netmaker-exporter
        image: gravitl/netmaker-exporter:latest
        restart: always
        depends_on:
            - netmaker
        environment:
            SERVER_BROKER_ENDPOINT: "ws://mq:8083/mqtt"
            BROKER_ENDPOINT: "wss://broker.nm.${NM_DOMAIN}/mqtt"
            PROMETHEUS_HOST: "https://prometheus.${NM_DOMAIN}"


At this point you should be able to ``docker-compose down && docker-compose up -d && docker-compose -f docker-compose-emqx.yml up -d``. Your ``docker logs mq`` should look something like this.

.. code-block:: cfg

    Listener ssl:default on 0.0.0.0:8883 started.
    Listener tcp:default on 0.0.0.0:1883 started.
    Listener ws:default on 0.0.0.0:8083 started.
    Listener wss:default on 0.0.0.0:8084 started.
    Listener http:dashboard on :18083 started.
    EMQX 5.0.9 is running now!

Your server is now running on an EMQX broker. you can view your EMQX dashboard with ``http://<serverip>:18083/``. The signin credentials are the EMQX_DASHBOARD__DEFAULT_USERNAME and EMQX_DASHBOARD__DEFAULT_PASSWORD located in your netmaker.env file. This dashboard will give you all the information about your mq activity going on in your netmaker server.

.. _NoDocker:

Linux Install without Docker
=============================

Most systems support Docker, but some do not. In such environments, there are many options for installing Netmaker. Netmaker is available as a binary file, and there is a zip file of the Netmaker UI static HTML on GitHub. Beyond the UI and Server, you may want to optionally install a database (SQLite is embedded, rqlite or postgres are supported) and CoreDNS (also optional). 

Once this is enabled and configured for a domain, you can continue with the below. The recommended server runs Ubuntu 20.04.

Database Setup (optional)
--------------------------

You can run the netmaker binary standalone and it will run an embedded SQLite server. Data goes in the data/ directory. Optionally, you can run PostgreSQL or rqlite. Instructions for rqlite are below.

1. Install rqlite on your server: https://github.com/rqlite/rqlite
2. Run rqlite: rqlited -node-id 1 ~/node.1

If using rqlite or postgres, you must change the DATABASE environment/config variable and enter connection details.

Server Setup (using sqlite)
---------------------------

1. Get the binary. ``wget -O /etc/netmaker/netmaker https://github.com/gravitl/netmaker/releases/download/$VERSION/netmaker``
2. Move the binary to /usr/sbin and make it executable.
3. create a config file. /etc/netmaker/netmaker.yml

.. code-block:: yaml

    server:
      server: "<YOUR_BASE_DOMAIN>"
      broker: wss://broker.<YOUR_BASE_DOMAIN>
      apiport: "8081"
      apiconn: "api.<YOUR_BASE_DOMAIN>:443"
      masterkey: "<SECRET_KEY>"
      mqpassword: "<YOUR_PASSWORD>"
      mqusername: "<YOUR_USERNAME>"
      turn_username: "<YOUR_USERNAME>"
      turn_password: "<YOUR_PASSWORD>"
      turn_server: "turn.<YOUR_BASE_DOMAIN>"
      turn_api_server: "https://turnapi.<YOUR_BASE_DOMAIN>"
      turn_port: "3479"
      use_turn: "true"
      serverbrokerendpoint: "ws://mq:1883"



4. Update YOUR_BASE_DOMAIN and SECRET_KEY as well as username and passwords for mq and turn.
5. create your netmaker.service file /etc/systemd/system/netmaker.service

.. code-block:: cfg

    [Unit]
    Description=Netmaker Server
    After=network.target

    [Service]
    Type=simple
    Restart=on-failure

    ExecStart=/usr/sbin/netmaker -c /etc/netmaker/netmaker.yml

    [Install]
    WantedBy=multi-user.target

6. ``systemctl daemon-reload``
7. Check status:  ``sudo journalctl -u netmaker``
8. If any settings are incorrect such as host or sql credentials, change them under /etc/netmaker/netmaker.yml and then run ``sudo systemctl restart netmaker``

UI Setup
---------

The following uses Caddy as a file server/proxy.

1. Download and Unzip UI asset files from https://github.com/gravitl/netmaker-ui/releases and put them in /var/www/netmaker
    ``sudo wget -O /tmp/netmaker-ui.zip https://github.com/gravitl/netmaker-ui/releases/download/latest/netmaker-ui.zip``
    ``sudo unzip /tmp/netmaker-ui.zip -d /var/www/netmaker``

2. Create config.js in /var/www/netmaker
    ``window.REACT_APP_BACKEND='https://api.<YOUR_BASE_DOMAIN>'``

Proxy / Http server
------------------------

Caddy
-----

1. Install Caddy
2. You should have a Caddy file from installing caddy. Replace the contents of that file with this configuration.

.. code-block:: cfg

    {
        # ZeroSSL account
        acme_ca https://acme.zerossl.com/v2/DV90
        email <YOUR_EMAIL>
    }

    # Dashboard
    https://dashboard.<YOUR_BASE_DOMAIN> {
        header {
            Access-Control-Allow-Origin *.<YOUR_BASE_DOMAIN>
            Strict-Transport-Security "max-age=31536000;"
            X-XSS-Protection "1; mode=block"
            X-Frame-Options "SAMEORIGIN"
            X-Robots-Tag "none"
            -Server
        }
        root * /var/www/netmaker
        file_server 
    }

    # API
    https://api.<YOUR_BASE_DOMAIN> {
        reverse_proxy http://127.0.0.1:8081
    }

3. start Caddy

MQ
----

You will need an MQTT broker on the host. We recommend Mosquitto. In addition, it must use the mosquitto.conf file. Depending on The version, you will use one of the two files.

.. code-block:: cfg

    # use this config for versions earlier than v0.16.1

    per_listener_settings true

    listener 8883
    allow_anonymous false
    require_certificate true
    use_identity_as_username false
    cafile /etc/mosquitto/certs/root.pem
    certfile /etc/mosquitto/certs/server.pem
    keyfile /etc/mosquitto/certs/server.key

    listener 1883
    allow_anonymous true

Start netmaker
Copy root.pem, server.pem, and server.key from /etc/netmaker to /etc/mosquitto/certs/

.. code-block::

    #use this config file for v0.16.1 and later.
    per_listener_settings false
    listener 8883
    allow_anonymous false

    listener 1883
    allow_anonymous false

    plugin /usr/lib/x86_64-linux-gnu/mosquitto_dynamic_security.so
    plugin_opt_config_file /etc/mosquitto/data/dynamic-security.json

Copy dynamic-security.json from etc/netmaker to /etc/mosquitto/data.
Restart netmaker.
Restart mosquitto.
You can check the status of caddy, mosquitto, and netmaker with ``journalctl -fu <ONE_OF_THOSE_THREE>`` to make sure everything is working.



.. _KubeInstall:

Kubernetes Install
=======================

Server Install
--------------------------

This template assumes your cluster uses Nginx for ingress with valid wildcard certificates. If using an ingress controller other than Nginx (ex: Traefik), you will need to manually modify the Ingress entries in this template to match your environment.

This template also requires RWX storage. Please change references to storageClassName in this template to your cluster's Storage Class.

``wget https://raw.githubusercontent.com/gravitl/netmaker/master/kube/netmaker-template.yaml``

Replace the NETMAKER_BASE_DOMAIN references to the base domain you would like for your Netmaker services (ui,api,grpc). Typically this will be something like **netmaker.yourwildcard.com**.

``sed -i ‘s/NETMAKER_BASE_DOMAIN/<your base domain>/g’ netmaker-template.yaml``

Now, assuming Ingress and Storage match correctly with your cluster configuration, you can install Netmaker.

.. code-block::

  kubectl create ns nm
  kubectl config set-context --current --namespace=nm
  kubectl apply -f netmaker-template.yaml -n nm

In about 3 minutes, everything should be up and running:

``kubectl get ingress nm-ui-ingress-nginx``

Netclient Daemonset
--------------------------

The following instructions assume you have Netmaker running and a network you would like to add your cluster into. The Netmaker server does not need to be running inside of a cluster for this.

.. code-block::

  wget https://raw.githubusercontent.com/gravitl/netmaker/master/kube/netclient-template.yaml
  sed -i ‘s/ACCESS_TOKEN_VALUE/< your access token value>/g’ netclient-template.yaml
  kubectl apply -f netclient-template.yaml

For a more detailed guide on integrating Netmaker with MicroK8s, `check out this guide <https://itnext.io/how-to-deploy-a-cross-cloud-kubernetes-cluster-with-built-in-disaster-recovery-bbce27fcc9d7>`_. 

Nginx Reverse Proxy Setup with https
======================================

The `Swag Proxy <https://github.com/linuxserver/docker-swag>`_ makes it easy to generate a valid SSL certificate for the config below. Here is the `documentation <https://docs.linuxserver.io/general/swag>`_ for the installation.

The following file configures Netmaker as a subdomain. This config is an adaption from the swag proxy project.

./netmaker.subdomain.conf:

.. code-block:: nginx

    server {
        # Redirect HTTP to HTTPS.
        listen 80;
        server_name *.netmaker.example.org; # Please change to your domain
        return 301 https://$host$request_uri;
        }
    
    server {
        listen 443 ssl;
        listen [::]:443 ssl;
        server_name dashboard.netmaker.example.org; # Please change to your domain
        include /config/nginx/ssl.conf;
        location / {
            proxy_pass http://<NETMAKER_IP>:8082;
            }
        }
    
    server {
        listen 443 ssl;
        listen [::]:443 ssl;
        server_name api.netmaker.example.org; # Please change to your domain
        include /config/nginx/ssl.conf;
    
        location / {
            proxy_pass http://<NETMAKER_IP>:8081;
            proxy_set_header		Host api.netmaker.example.org; # Please change to your domain
            proxy_pass_request_headers	on;
            }
        }
    


Nginx Proxy Manager Setup
======================================

To use Netmaker with Nginx Proxy Manager, three proxy hosts should be added, one for each subdomain used by netmaker. Each subdomain should have SSL enable and be configured as follows:

.. code-block::

	api.netmaker.example.com: 
	Forward Hostname/IP: netmaker
	Forward Port: 8081
	dashboard.netmaker.example.com:
	Forward Hostname/IP: netmaker-ui
	Forward Port: 80
	grpc.netmaker.example.com:
	Forward Hostname/IP: netmaker
	Forward Port: 50051
	Custom Locations:
	Add location /
	Forward Hostname/IP: netmaker
	Forward Port: 50051
	Custom config (gear button): grpc_pass netmaker:50051;


The following is a cleaned up config generated by Nginx Proxy Manager to show how nginx can be configured to support Netmaker. This does not include the neccessary SSL configuration. 


.. code-block:: nginx

	# ------------------------------------------------------------
	# dashboard.netmaker.example.com
	# ------------------------------------------------------------
	server {
	  set $forward_scheme http;
	  set $server         "netmaker-ui";
	  set $port           80;
	listen 80;
	listen [::]:80;
	listen 443 ssl http2;
	listen [::]:443 ssl http2;
	server_name dashboard.netmaker.example.com;
	  location / {
	    # Proxy!
	    include conf.d/include/proxy.conf;
		#above file includes:
		#add_header       X-Served-By $host;
		#proxy_set_header Host $host;
		#proxy_set_header X-Forwarded-Scheme $scheme;
		#proxy_set_header X-Forwarded-Proto  $scheme;
		#proxy_set_header X-Forwarded-For    $remote_addr;
		#proxy_set_header X-Real-IP          $remote_addr;
		#proxy_pass       $forward_scheme://$server:$port$request_uri;
	  }
	}
	
	# ------------------------------------------------------------
	# api.netmaker.example.com
	# ------------------------------------------------------------
	server {
	  set $forward_scheme http;
	  set $server         "netmaker";
	  set $port           8081;
	listen 80;
	listen [::]:80;
	listen 443 ssl http2;
	listen [::]:443 ssl http2;
	  server_name api.netmaker.example.com;
	  location / {
	    # Proxy!
	    include conf.d/include/proxy.conf;
		#above file includes:
		#add_header       X-Served-By $host;
		#proxy_set_header Host $host;
		#proxy_set_header X-Forwarded-Scheme $scheme;
		#proxy_set_header X-Forwarded-Proto  $scheme;
		#proxy_set_header X-Forwarded-For    $remote_addr;
		#proxy_set_header X-Real-IP          $remote_addr;
		#proxy_pass       $forward_scheme://$server:$port$request_uri;
	  }
	}
	
	# ------------------------------------------------------------
	# grpc.netmaker.example.com
	# ------------------------------------------------------------
	server {
	  set $forward_scheme http;
	  set $server         "netmaker";
	  set $port           50051;
	listen 80;
	listen [::]:80;
	listen 443 ssl http2;
	listen [::]:443 ssl http2;
	  server_name grpc.netmaker.example.com;
	  location / {
	    proxy_set_header Host $host;
	    proxy_set_header X-Forwarded-Scheme $scheme;
	    proxy_set_header X-Forwarded-Proto  $scheme;
	    proxy_set_header X-Forwarded-For    $remote_addr;
	    proxy_set_header X-Real-IP          $remote_addr;
	    proxy_pass       http://netmaker:50051;
	    grpc_pass netmaker:50051;
	  }
	}


.. _HAInstall:



Highly Available Installation (Kubernetes)
==================================================

Netmaker comes with a Helm chart to deploy with High Availability on Kubernetes:

.. code-block::

    helm repo add netmaker https://gravitl.github.io/netmaker-helm/
    helm repo update

Requirements
---------------

To run HA Netmaker on Kubernetes, your cluster must have the following:
- RWO and RWX Storage Classes (RWX is only required if running Netmaker with DNS Management enabled).
- An Ingress Controller and valid TLS certificates 
- This chart can currently generate ingress for Nginx or Traefik Ingress with LetsEncrypt + Cert Manager
- If LetsEncrypt and CertManager are not deployed, you must manually configure certificates for your ingress

Furthermore, the chart will by default install and use a postgresql cluster as its datastore.

Recommended Settings:
----------------------
A minimal HA install of Netmaker can be run with the following command:
`helm install netmaker --generate-name --set baseDomain=nm.example.com`
This install has some notable exceptions:
- Ingress **must** be manually configured post-install (need to create valid Ingress with TLS)
- Server will use "userspace" WireGuard, which is slower than kernel WG
- DNS will be disabled

Example Installations:
------------------------
An annotated install command:

.. code-block::

    helm install netmaker/netmaker --generate-name \ # generate a random id for the deploy 
    --set baseDomain=nm.example.com \ # the base wildcard domain to use for the netmaker api/dashboard/grpc ingress 
    --set replicas=3 \ # number of server replicas to deploy (3 by default) 
    --set ingress.enabled=true \ # deploy ingress automatically (requires nginx or traefik and cert-manager + letsencrypt) 
    --set ingress.className=nginx \ # ingress class to use 
    --set ingress.tls.issuerName=letsencrypt-prod \ # LetsEncrypt certificate issuer to use 
    --set dns.enabled=true \ # deploy and enable private DNS management with CoreDNS 
    --set dns.clusterIP=10.245.75.75 --set dns.RWX.storageClassName=nfs \ # required fields for DNS 
    --set postgresql-ha.postgresql.replicaCount=2 \ # number of DB replicas to deploy (default 2)


The below command will install netmaker with two server replicas, a coredns server, and ingress with routes of api.nm.example.com, grpc.nm.example.com, and dashboard.nm.example.com. CoreDNS will be reachable at 10.245.75.75, and will use NFS to share a volume with Netmaker (to configure dns entries).

.. code-block::

    helm install netmaker/netmaker --generate-name --set baseDomain=nm.example.com \
    --set replicas=2 --set ingress.enabled=true --set dns.enabled=true \
    --set dns.clusterIP=10.245.75.75 --set dns.RWX.storageClassName=nfs \
    --set ingress.className=nginx

The below command will install netmaker with three server replicas (the default), **no coredns**, and ingress with routes of api.netmaker.example.com, grpc.netmaker.example.com, and dashboard.netmaker.example.com. There will be one UI replica instead of two and one database instance instead of two. Traefik will look for a ClusterIssuer named "le-prod-2" to get valid certificates for the ingress. 

.. code-block::

    helm3 install netmaker/netmaker --generate-name \
    --set baseDomain=netmaker.example.com --set postgresql-ha.postgresql.replicaCount=1 \
    --set ui.replicas=1 --set ingress.enabled=true \
    --set ingress.tls.issuerName=le-prod-2 --set ingress.className=traefik

Below, we discuss the considerations for Ingress, Kernel WireGuard, and DNS.

Ingress	
----------
To run HA Netmaker, you must have ingress installed and enabled on your cluster with valid TLS certificates (not self-signed). If you are running Nginx as your Ingress Controller and LetsEncrypt for TLS certificate management, you can run the helm install with the following settings:

- `--set ingress.enabled=true`
- `--set ingress.annotations.cert-manager.io/cluster-issuer=<your LE issuer name>`

If you are not using Nginx or Traefik and LetsEncrypt, we recommend leaving ingress.enabled=false (default), and then manually creating the ingress objects post-install. You will need three ingress objects with TLS:

- `dashboard.<baseDomain>`
- `api.<baseDomain>`
- `grpc.<baseDomain>`

If deploying manually, the gRPC ingress object requires special considerations. Look up the proper way to route grpc with your ingress controller. For instance, on Traefik, an IngressRouteTCP object is required.

There are some example ingress objects in the kube/example folder.

Kernel WireGuard
------------------
If you have control of the Kubernetes worker node servers, we recommend **first** installing WireGuard on the hosts, and then installing HA Netmaker in Kernel mode. By default, Netmaker will install with userspace WireGuard (wireguard-go) for maximum compatibility and to avoid needing permissions at the host level. If you have installed WireGuard on your hosts, you should install Netmaker's helm chart with the following option:

- `--set wireguard.kernel=true`

DNS
----------
By Default, the helm chart will deploy without DNS enabled. To enable DNS, specify with:

- `--set dns.enabled=true` 

This will require specifying a RWX storage class, e.g.:

- `--set dns.RWX.storageClassName=nfs`

This will also require specifying a service address for DNS. Choose a valid ipv4 address from the service IP CIDR for your cluster, e.g.:

- `--set dns.clusterIP=10.245.69.69`

**This address will only be reachable from hosts that have access to the cluster service CIDR.** It is only designed for use cases related to k8s. If you want a more general-use Netmaker server on Kubernetes for use cases outside of k8s, you will need to do one of the following:
- bind the CoreDNS service to port 53 on one of your worker nodes and set the COREDNS_ADDRESS equal to the public IP of the worker node
- Create a private Network with Netmaker and set the COREDNS_ADDRESS equal to the private address of the host running CoreDNS. For this, CoreDNS will need a node selector and will ideally run on the same host as one of the Netmaker server instances.

Values
---------

To view all options for the chart, please visit the README in the code repo `here <https://github.com/gravitl/netmaker/tree/master/kube/helm#values>`_ .

Highly Available Installation (VMs/Bare Metal)
==================================================

For a professional Netmaker installation, you will need a server that is highly available, to ensure redundant WireGuard routing when any server goes down. To do this, you will need:

1. A load balancer
2. 3+ Netmaker server instances
3. rqlite or PostgreSQL as the backing database

These documents outline general HA installation guidelines. Netmaker is highly customizable to meet a wide range of professional environments. If you would like support with a professional-grade Netmaker installation, you can `schedule a consultation here <https://gravitl.com/book>`_ .

The main consideration for this document is how to configure rqlite. Most other settings and procedures match the standardized way of making applications HA: Load balancing to multiple instances, and sharing a DB. In our case, the DB (rqlite) is distributed, making HA data more easily achievable.

If using PostgreSQL, follow their documentation for `installing in HA mode <https://www.postgresql.org/docs/14/high-availability.html>`_ and skip step #2.

1. Load Balancer Setup
------------------------

Your load balancer of choice will send requests to the Netmaker servers. Setup is similar to the various guides we have created for Nginx, Caddy, and Traefik. SSL certificates must also be configured and handled by the LB.

2. rqlite Setup
------------------

rqlite is the included distributed datastore for an HA Netmaker installation. If you have a different corporate database you wish to integrate, Netmaker is easily extended to other DB's. If this is a requirement, please contact us.

Assuming you use rqlite, you must run it on each Netmaker server VM, or alongside that VM as a container. Setup a config.json for database credentials (password supports BCRYPT HASHING) and mount in working directory of rqlite and specify with `-auth config.json` :

.. code-block::

    [{
        "username": "netmaker",
        "password": "<YOUR_DB_PASSWORD>",
        "perms": ["all"]
    }]


Once your servers are set up with rqlite, the first instance must be started normally, and then additional nodes must be added with the "join" command. For instance, here is the first server node:

.. code-block::

    sudo docker run -d -p 4001:4001 -p 4002:4002 rqlite/rqlite -node-id 1 -http-addr 0.0.0.0:4001 -raft-addr 0.0.0.0:4002 -http-adv-addr 1.2.3.4:4001 -raft-adv-addr 1.2.3.4:4002 -auth config.json

And here is a joining node:

.. code-block::

    sudo docker run -d -p 4001:4001 -p 4002:4002 rqlite/rqlite -node-id 2 -http-addr 0.0.0.0:4001 -raft-addr 0.0.0.0:4002 -http-adv-addr 2.3.4.5:4001  -raft-adv-addr 2.3.4.5:4002 -join https://netmaker:<YOUR_DB_PASSWORD>@1.2.3.4:4001

- reference for rqlite setup: https://github.com/rqlite/rqlite/blob/master/DOC/CLUSTER_MGMT.md#creating-a-cluster
- reference for rqlite security: https://github.com/rqlite/rqlite/blob/master/DOC/SECURITY.md

Once rqlite instances have been configured, the Netmaker servers can be deployed.

3. Netmaker Setup
------------------

Netmaker will be started on each node with default settings, except with DATABASE=rqlite (or DATABASE=postgress) and SQL_CONN set appropriately to reach the local rqlite instance. rqlite will maintain consistency with each Netmaker backend.

If deploying HA with PostgreSQL, you will connect with the following settings:

.. code-block::

    SQL_HOST = <sql host>
    SQL_PORT = <port>
    SQL_DB   = <designated sql DB>
    SQL_USER = <your user>
    SQL_PASS = <your password>
    DATABASE = postgres


4. Other Considerations
------------------------

This is enough to get a functioning HA installation of Netmaker. However, you may also want to make the Netmaker UI or the CoreDNS server HA as well. The Netmaker UI can simply be added to the same servers and load balanced appropriately. For some load balancers, you may be able to do this with CoreDNS as well.

Security Settings
==================

In some cases, it is useful to secure your web dashboard behind a firewall so it can only be accessed in that location. However, you may not want the API behind that firewall so the other nodes can interact with the network without the heightened security. This can be done in Your Caddyfile if you are using caddy.

For Caddy
-----------

In your /root/Caddyfile look in the Dashboard section for ``reverse_proxy http://netmaker-ui``

Above that line add the following

.. code-block:: cfg

    @blocked not remote_ip <ip1> <ip2> <ip3>
    respond @blocked "Nope" 403

Replace the <ip> placeholders with your whitelist IP ranges.

For Traefik
-----------

1. In the labels section, add the following line:

.. code-block:: yaml

    traefik.http.middlewares.nmui-security-1.ipwhitelist.sourcerange=YOUR_IP_CIDR

2. Then look for this line:

.. code-block:: yaml

    traefik.http.routers.netmaker-ui.middlewares=nmui-security@docker

and change it to this:

.. code-block:: yaml

    traefik.http.routers.netmaker-ui.middlewares=nmui-security-1@docker,nmui-security@docker

Replace YOUR_IP_CIDR with the whitelist IP range (can be multiple ranges).

After changes are made for your reverse proxy, ``docker-compose down && docker-compose up -d`` and you should be all set. You can now keep your dashboard secure and your API more available without having to change netmaker-ui ports.


