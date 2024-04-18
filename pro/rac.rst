===================================
Netmaker Remote Access Client (RAC)
===================================

The Netmaker Remote Access Client, RAC for short is a GUI tool for easily getting access to a Netmaker network.
RAC is mostly suited for offsite machines that need access to a Netmaker network. It supports Windows, Mac and Linux (mobile support coming soon).


***********************
Download/Installation
***********************

**For Mac**, You can download the mac installer from the fileserver link above and run it. The open the GUI to start using RAC.!

**For Windows**, you can download the remoteclientbundle.exe bundle (recommended as this install wireguard and other dependencies) or remote-access-client_86.msi installer and run it to install on your windows machine. You can then open the GUI to start using RAC!


For mobile devices, you can download the app from the respective app stores.

**Google Play Store:**

Scan the QR code

.. image:: images/netmaker-rac-android.png
   :width: 400px
   :alt: Netmaker RAC on Google Play Store
   :align: left

Or use the following link:
https://play.google.com/store/apps/details?id=com.net.netmaker&pli=1&utm_source=docs


**Apple App Store:**

Scan the QR code

.. image:: images/netmaker-rac-apple.png
   :width: 400px
   :alt: Netmaker RAC on Apple App Store
   :align: left

Or use the following link:
https://apps.apple.com/us/app/netmaker-rac/id6479694220?itsct=apps_box_badge&amp;itscg=30200


**For Linux (Debian/Ubuntu):**

You can also use the following command to download the latest version:

.. code-block:: 

   curl -sL 'https://apt.netmaker.org/remote-client/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/remote-client.asc
   curl -sL 'https://apt.netmaker.org/remote-client/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/remote-client.list
   sudo apt update
   sudo apt search remote-client  # to see available versions
   sudo apt install remote-client


**Red Hat Distros (Fedora/RedHat/CentOSRocky):**

.. code-block::

  curl -sL 'https://rpm.netmaker.org/remote-client/gpg.key' | sudo tee /tmp/gpg.key
  curl -sL 'https://rpm.netmaker.org/remote-client/remote-client-repo' | sudo tee /etc/yum.repos.d/remote-client.repo
  sudo rpm --import /tmp/gpg.key
  sudo dnf check-update
  sudo dnf install remote-client


Following the above instructions, you can run RAC from your Linux desktop environment launcher or from the command line using the `remote-client` command.


Not finding your OS? You can download the latest version of RAC from the our file server:

.. code-block::

  https://fileserver.netmaker.org/releases/download/<version>

Search for remote client and download the appropriate version for your operating system.


******************
Quick Start
******************

**NOTE**: OpenGL is a requirement for Netmaker RAC to run. If you are running RAC on a virtual machine (especially with Windows as guest OS), you may need to enable 3D acceleration in your virtual machine settings.

To use RAC, you will need to have a Netmaker server running and have a user account on that server. You will also need to have a remote access gateway set up on the server. Client devices connect to the network through the remote access gateway (ingress host).

Check :ref:`this section <pro/pro-users:adding users>` on how to create a non-admin user.
RAC is best suited for non-admin users who want to gain remote access to the network, this also provides admins fine-grained control over users in the network by attaching/removing them from a remote access gateway. Admins can also use RAC to gain remote access to the network with a different machine.

.. include:: rac.txt