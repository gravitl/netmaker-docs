===============================================
NMCTL - how to use netmaker from command line
===============================================

a brief guide to using netmaker from the command line (without the UI)

******************
Assumptions
******************

1. using bash shell
2. netclient, nmctl and jq have been installed
3. netmaker server has been set up at example.com without UI  (netmaker-ui section of docker-compose.yml has been deleted)


***********************
Set username/password
***********************
.. code-block::
    
        export USER=admin
        export PASSWORD=somelongpassword

***********************
Set masterkey
***********************
*masterkey* must match the masterkey on server
.. code-block::
        export MASTERKEY=masterkey

******************
Set base domain
******************
.. code-block::
        
            export NN_DOMAIN=example.com

******************
Set Context
******************
.. code-block::
            
            nmctl context set commandline --endpoint https://api.$NM_DOMAIN --master_key $MASTERKEY
            nmctl context use commandline

******************
Create Admin User
******************
.. code-block::
                
            nmctl user create --admin --name $USER --password $PASSWORD

******************
ReSet Context
******************
.. code-block::
            
            nmctl context set commandline --endpoint https://api.$NM_DOMAIN --username $USER --password $PASSWORD
            nmctl context use commandline

******************
Create Network
******************
.. code-block::

        nmctl network create --name mynetwork --ip4v_addr 10.10.10.0/24

**********************
Create Enrollment Key
**********************

Unlimited
============
.. code-block::
    
        export KEY=$(nmctl key create --network mynetwork --unlimited | jq .token)

Limited Use (3)
================
.. code-block::
        
        export KEY=$(nmctl key create --network mynetwork --uses 3 | jq .token)

With Expiration Time
=====================
.. code-block::

        export EXPIRES=$(date -d "+2 days" +$s)
        export KEY=$(nmctl key create --network mynetwork --expires $EXPIRES | jq .token)

******************
Join network
******************
.. code-block::

        sudo netclient join -t $KEY
