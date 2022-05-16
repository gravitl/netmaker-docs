================================
Client Installation
================================

This document tells you how to install the netclient as a system service on all supported operating systems. These include:

- Linux (most distributions)
- Windows
- Mac
- FreeBSD

The client install **does not** add the client as a member of any network. Once the client is installed, you must run:

.. code-block::

  netclient join -t <token>

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

The Windows Installer is coming soon! (0.14.1). In the meantime, please use the Windows powershell script found here: https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/netclient-install.ps1

To install in one command, open Powershell as administrator and run the following:

.. code-block::

  . { iwr -useb  https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/netclient-install.ps1 } | iex; Netclient-Install -version "<your netmaker version>"

Mac
============

Brew Install
---------------

.. code-block::

  brew tap gravitl/netclient
  (optional) brew audit netclient
  brew install netclient

Installer
---------------

Installer: <installer link>

FreeBSD
=============

A FreeBSD package is coming soon. In the meantime, please use this install script:

.. code-block::

  curl -sfL https://raw.githubusercontent.com/gravitl/netmaker/master/scripts/netclient-install.sh | VERSION="<your netmaker version>" sh -