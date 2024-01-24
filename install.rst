=========
Install
=========

Choose the install method that makes sense for you.


1. **We recommend using the nm-quick script for self-hosted/On-Prem setup.**

.. code-block::

  sudo wget -qO /root/nm-quick.sh https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/nm-quick.sh && sudo chmod +x /root/nm-quick.sh && sudo /root/nm-quick.sh


**IMPORTANT:** Notes on Installation
- Due to the high volume of installations, the auto-generated domain has been rate-limited by the certificate provider. For this reason, we **strongly recommend** using your own domain. Using the auto-generated domain may lead to a failed installation due to rate limiting.

**IMPORTANT:** From v0.22.0 the install script will install PRO version of netmaker with a 30-day free trial, for you to try out full capabilities of netmaker.

After trial period ends:
=========================

    a. if you wish to continue using PRO :-

        i. check these steps to obtain pro license `<https://docs.netmaker.io/pro/pro-setup.html>`_
        ii. Run `/root/nm-quick.sh -u`

    b. if you wish to downgrade to community version
    
        i. Run `/root/nm-quick.sh -d`

2. **To get started the easiest way, visit our SaaS platform to set up a netmaker server with just a few clicks** `<https://app.netmaker.io>`_


3. :doc:`check out these steps for manual installation process for on-prem, although we don't recommend this path, instead use the install script mentioned above<./manual-install>`

4. :ref:`Kubernetes Installation <KubeInstall>`

5. :ref:`Non-Docker (from binary) Install <NoDocker>`

6. :ref:`Highly Available Installation <HAInstall>`

7. :doc:`Advanced Install Resources <./server-installation>`

