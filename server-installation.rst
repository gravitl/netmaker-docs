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

NM_EMAIL
    **Default** ""

    **Description** Email used for SSL certificates

NM_DOMAIN
    **Default:** ""

    **Description:**  Public IP of machine

SERVER_HOST
    **Default:** (Server detects the public IP address of machine)

    **Description:** The public IP of the server where the machine is running.

MASTER_KEY  
    **Default:** "secretkey" 

    **Description:** The admin master key for accessing the API. Change this in any production installation.
 
MQ_USERNAME
    **Default** ""

    **Description** The username to set for MQ access

MQ_PASSWORD
    **Default** ""

    **Description** The password to set for MQ access

INSTALL_TYPE
    **Default** ce 

    **Description** The installation type to run on the server. "ce" will run community edition. "pro" will run professional edition if you have an on-prem tenant.

LICENSE_KEY

    **Default** ""

    **Description** The license key from your on-prem tenent needed to validate your professional installation.

NETMAKER_TENANT_ID

    **Default** ""

    **Description** The ID of your on-prem tenant used to validate your professional installation.

SERVER_IMAGE_TAG

    **Default**

    **Description** The tag used for the server docker image. You can set it to "latest" to get the most up to date version. To stay on a certain version set the tag to the version you would like. ex: v0.24.2. if using a pro image, add "-ee" after the version. ex: v0.24.2-ee.

UI_IMAGE_TAG

    **Default** ""

    **Description** The tag used for the netmaker ui docker image. You can set it to "latest" to get the most up to date version. To stay on a certain version set the tag to the version you would like. ex: v0.24.2.

METRICS_EXPORTER

    **Default** off

    **Description** This is a pro feature that exports metrics to the netmaker server.

PROMETHEUS

    **Default** off

    **Description** This is a pro feature. Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. It is used in out metrics collection

DNS_MODE

    **Default** on

    **Description** Enables DNS Mode, meaning all nodes will set hosts file for private dns settings

NETCLIENT_AUTO_UPDATE

    **Default** enabled

    **Description** Enable/Disable auto update of netclient

API_PORT

    **Default** 8081

    **Description** The HTTP API port for Netmaker. Used for API calls / communication from front end. If changed, need to change port of BACKEND_URL for netmaker-ui.

EXPORTER_API_PORT

    **Default** 8085

    **Description** the API port to set for the metrics exporter.

CORS_ALLOWED_ORIGIN

    **Default** "*"

    **Description** The "allowed origin" for API requests. Change to restrict where API requests can come from with comma-separated URLs. ex:- https://dashboard.netmaker.domain1.com,https://dashboard.netmaker.domain2.com

DISPLAY_KEYS

    **Default** on

    **Description** Show keys permanently in UI (until deleted) as opposed to 1-time display.

DATABASE

    **Default** sqlite

    **Description** Database to use - sqlite, postgres, or rqlite

SERVER_BROKER_ENDPOINT

    **Default** ws://mq:1883 

    **Description** The address of the mq server. If running from docker compose it will be "mq". Otherwise, need to input address. If using "host networking", it will find and detect the IP of the mq container. For EMQX websockets use `SERVER_BROKER_ENDPOINT=ws://mq:8083/mqtt`

VERBOSITY

    **Default** 1

    **Description** Logging verbosity level - 1, 2, 3, or 4

REST_BACKEND

    **Default** on

    **Description** Enables the REST backend (API running on API_PORT at SERVER_HTTP_HOST).

DISABLE_REMOTE_IP_CHECK

    **Default** off
    
    **Description** If turned "on", Server will not set Host based on remote IP check. This is already overridden if SERVER_HOST is set.

TELEMETRY

    **Default** on

    **Description** Whether or not to send telemetry data to help improve Netmaker. Switch to "off" to opt out of sending telemetry.

ALLOWED_EMAIL_DOMAINS

    **Default** "*"

    **Description** only mentioned domains will be allowded to signup using oauth, by default all domains are allowed

AUTH_PROVIDER

    **Default** ""

    **Description** You can use azure-ad, github, google, oidc

CLIENT_ID

    **Default** ""

    **Description** The client id of your oauth provider.

CLIENT_SECRET

    **Default** ""

    **Description** The client secret of your oauth provider.

FRONTEND_URL

    **Default** ""

    **Description** https://dashboard.<netmaker base domain>

AZURE_TENANT

    **Default** ""

    **Description** only for azure, you may optionally specify the tenant for the OAuth

OIDC_ISSUER

    **Default** ""

    **Description** https://oidc.yourprovider.com - URL of oidc provider

JWT_VALIDITY_DURATION

    **Default** 43200

    **Description** Duration of JWT token validity in seconds

RAC_AUTO_DISABLE

    **Default** false

    **Description** Auto disable a user's connected clients based on JWT token expiration

CACHING_ENABLED

    **Default** true

    **Description** if turned on data will be cached on to improve performance significantly (IMPORTANT: If HA set to `false` )

ENDPOINT_DETECTION

    **Default** true

    **Description** if turned on netclient checks if peers are reachable over private/LAN address, and choose that as peer endpoint

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

Your Caddyfile should look like this.

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

1. Get the binary. ``wget -O /etc/netmaker/netmaker https://github.com/gravitl/netmaker/releases/latest/download/netmaker-linux-amd64``
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
      serverbrokerendpoint: "ws://mq:1883"



4. Update YOUR_BASE_DOMAIN and SECRET_KEY as well as username and passwords for mq.
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
    ``sudo wget -O /tmp/netmaker-ui.zip https://github.com/gravitl/netmaker-ui/releases/latest/download/netmaker-ui.zip``
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


Setup Netmaker on IPv6 only machine
=====================================

This is not a guide how to add an overlay network(with IPv6) in Netmaker, it can be found in `Setup <https://docs.netmaker.io/getting-started.html#setup>`_ page.
This is to setup Netmaker working on an IPv6 only machine.

About the install script nm-quick.sh
------------------------------------------

At the moment which the document is written, the install script `nm-quick.sh` only supports IPv4. For the installation, the IPv4 needs to be enabled temporary anyway.

Add AAAA record for domain name resolution
------------------------------------------

The Netmaker client communicates with Netmaker server by domain name.   AAAA record here is to resolve the domain name to IPv6 address.


By default, Netmaker works on IPv4. Because Docker works on IPv4 by default.  After the installation, there are several steps to enable IPv6 for Docker and Netmaker.

Enable IPv6 support for Docker
------------------------------

1. Add/Edit the configuration file `/etc/docker/daemon.json`:

.. code-block:: json

	{
	  "experimental": true,
	  "ip6tables": true
	}

2. Restart the Docker daemon for your changes to take effect.

.. code-block::

	sudo systemctl restart docker

3. Create a new IPv6 network, for example,

.. code-block::

	docker network create --ipv6 --subnet 2001:0DB8::/112 ip6net

where "ip6net" is the network name, "2001:0DB8::/112" is the network range.


Enable IPv6 support for Netmaker
---------------------------------

1. Edit `docker-compose.yml` file and add the following lines at the bottom.

.. code-block:: yaml

	networks:
	  ip6net:
	    external: true

2. The same in `docker-compose.yml` file, add `networks` field for every service.

.. code-block:: yaml

	networks:
	  - ip6net

3. Run commands `"docker-compose down"` and `"docker-compose up -d"` to restart Netmaker server

