=============================================
API Reference
=============================================

API Usage
==========================

Most actions that can be performed via API can be performed via UI. We recommend managing your networks using the official netmaker-ui project. However, Netmaker can also be run without the UI, and all functions can be achieved via API calls. If your use case requires using Netmaker without the UI or you need to do some troubleshooting/advanced configuration, using the API directly may help.


Authentication
==============
API calls must be authenticated via a header of the format ``-H "Authorization: Bearer <YOUR_SECRET_KEY>"``. There are two methods to obtain YOUR_SECRET_KEY:

#. Using the masterkey. By default, this value is "secret key," but you should change this on your instance and keep it secure. This value can be set via env var at startup or in a config file (config/environments/< env >.yaml). See the [general usage](./USAGE.md) documentation for more details.
#. Using a JWT received for a node. This can be retrieved by calling the `/api/nodes/<network>/authenticate` endpoint, as documented below.


Format of Calls for Curl
========================
Requests take the format of 

.. code-block::

    curl -H "Authorization: Bearer <YOUR_SECRET_KEY>" -H 'Content-Type: application/json' localhost:8081/api/path/to/endpoint

API Documentation
=================

Now located `here <https://app.swaggerhub.com/apis-docs/Netmaker/netmaker/0.15.2>`_.


Networks API Call Examples
--------------------------

.. code-block::

    Get All Networks: curl -H "Authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/networks | jq

    Create Network: curl -d '{"addressrange":"10.70.0.0/16","netid":"skynet"}' -H "Authorization: Bearer YOUR_SECRET_KEY" -H 'Content-Type: application/json' localhost:8081/api/networks

    Get Network: curl -H "Authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/networks/skynet | jq

    Update Network: curl -X PUT -d '{"displayname":"my-house"}' -H "Authorization: Bearer YOUR_SECRET_KEY" -H 'Content-Type: application/json' localhost:8081/api/networks/skynet

    Delete Network: curl -X DELETE -H "Authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/networks/skynet

    Cycle PublicKeys on all Nodes: curl -X POST -H "Authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/networks/skynet/keyupdate



Access Keys API Call Examples
-----------------------------

.. code-block::

    Get All Keys: curl -H "Authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/networks/skynet/keys | jq

    Create Key: curl -d '{"uses":10,"name":"mykey"}' -H "Authorization: Bearer YOUR_SECRET_KEY" -H 'Content-Type: application/json' localhost:8081/api/networks/skynet/keys

    Delete Key: curl -X DELETE -H "Authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/networks/skynet/keys/mykey


ACL API Call Examples
-----------------------------

.. code-block::

    Get ACL for Network: curl -H "Authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/networks/skynet/acl | jq

    Update ACL for Network: curl -X PUT -H 'Content-Type: application/json' -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/nodes/skynet/acl \

    -d `{"20703260-4b0e-4f2d-8d74-bf28e21cc682":{"75721e5b-f2ac-4cca-b648-fa1d83712287":1},"75721e5b-f2ac-4cca-b648-fa1d83712287":{"20703260-4b0e-4f2d-8d74-bf28e21cc682":1}}`



Nodes API Call Examples
-----------------------

.. code-block::

    Get All Nodes: curl -H "Authorization: Bearer YOUR_SECRET_KEY" http://localhost:8081/api/nodes | jq

    Get Network Nodes: curl -H "Authorization: Bearer YOUR_SECRET_KEY" http://localhost:8081/api/nodes/skynet | jq

    Create Node: curl  -d  '{ "endpoint": 100.200.100.200, "publickey": aorijqalrik3ajflaqrdajhkr,"macaddress": "8c:90:b5:06:f1:d9","password": "reallysecret","localaddress": "172.16.16.1","accesskey": "aA3bVG0rnItIRXDx","listenport": 6400}' -H 'Content-Type: application/json' -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/nodes/skynet

    Get Node: curl -H "Authorization: Bearer YOUR_SECRET_KEY" http://localhost:8081/api/nodes/skynet/{macaddress} | jq

    Update Node: curl -X PUT -d '{"name":"laptop1"}' -H 'Content-Type: application/json' -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/nodes/skynet/8c:90:b5:06:f1:d9

    Delete Node: curl -X DELETE -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/skynet/nodes/8c:90:b5:06:f1:d9

    Create a Gateway: curl  -d  '{ "rangestring": "172.31.0.0/16", "interface": "eth0"}' -H 'Content-Type: application/json' -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/nodes/skynet/8c:90:b5:06:f1:d9/creategateway

    Delete a Gateway: curl -X DELETE -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/nodes/skynet/8c:90:b5:06:f1:d9/deletegateway

    Approve a Pending Node: curl -X POST -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/nodes/skynet/8c:90:b5:06:f1:d9/approve

    Get Last Modified Date (Last Modified Node in Network): curl -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/nodes/adm/skynet/lastmodified

    Authenticate: curl -d  '{"macaddress": "8c:90:b5:06:f1:d9", "password": "YOUR_PASSWORD"}' -H 'Content-Type: application/json' localhost:8081/api/nodes/adm/skynet/authenticate



Users API Calls Examples
------------------------

.. code-block::

    Get User: curl -H "Authorization: Bearer YOUR_SECRET_KEY" http://localhost:8081/api/users/{username} | jq

    Update User: curl -X PUT -d '{"password":"noonewillguessthis"}' -H 'Content-Type: application/json' -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/users/{username}

    Delete User: curl -X DELETE -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/users/{username}

    Check for Admin User: curl -H "Authorization: Bearer YOUR_SECRET_KEY" http://localhost:8081/api/users/adm/hasadmin

    Create Admin User: curl -d '{ "username": "smartguy", "password": "YOUR_PASS"}' -H 'Content-Type: application/json' -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/users/adm/createadmin

    Authenticate: curl -d  '{"username": "smartguy", "password": "YOUR_PASS"}' -H 'Content-Type: application/json' localhost:8081/api/nodes/adm/skynet/authenticate


Server Management API Examples
------------------------------

The Server Management API allows you to add and remove the server from networks.

**Add to Network:**  `curl -X POST -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/server/addnetwork/{network id}`

**Remove from Network:** `curl -X DELETE -H "authorization: Bearer YOUR_SECRET_KEY" localhost:8081/api/server/removenetwork/{network id}`


File Server API Example
-----------------------


`curl localhost:8081/meshclient/files/meshclient`