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
Setup superadmin user 
***********************

Set base domain
================
.. code-block::

        export NN_DOMAIN=example.com

Create SuperAdmin User
=======================
.. code-block::

                curl --location 'https://api.$NM_DOMAIN/api/users/adm/createsuperadmin' \
                --header 'Content-Type: application/json' \
                --data '{
                "username":"superadmin",
                "password":"NetmakerIsAwe$ome"
                }'

Set Context
================
.. code-block::

           nmctl context set commandline --endpoint https://api.$NM_DOMAIN --username $USER --password $PASSWORD
            
Create Admin User
==================
.. code-block::

            nmctl user create --admin --name $USER --password $PASSWORD
            
Create Normal User
==================
.. code-block::

            nmctl user create --name <user> --password <user-password>

*************************
Normal Operations by user 
*************************

*assume that users have been created by superAdmin*

***********************
Set username/password
***********************
.. code-block::

        export USER=<user>
        export PASSWORD=<user-password>



******************
Set User Context
******************
.. code-block::

            nmctl context set commandline --endpoint https://api.$NM_DOMAIN --username $USER --password $PASSWORD

******************
Create Network
******************
.. code-block::

        nmctl network create --name mynetwork --ip4v_addr 10.10.10.0/24

**********************
Create Enrollment Key 
**********************
*create one of Unlimited/LimitedUse/Expiration*

Unlimited
============
.. code-block::

        export KEY=$(nmctl enrollment_key create --network mynetwork --unlimited | jq .token)

Limited Use (3)
================
.. code-block::

        export KEY=$(nmctl enrollment_key create --network mynetwork --uses 3 | jq .token)

With Expiration Time (2 days)
==============================
.. code-block::

        export EXPIRES=$(date -d "+2 days" +$s)
        export KEY=$(nmctl enrollment_key create --network mynetwork --expires $EXPIRES | jq .token)

******************
Join network
******************
.. code-block::

        sudo netclient join -t $KEY
