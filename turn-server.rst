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

If You have an existing installation and would like to add a TURN server, You sill need to make some changes to your docker-compose.yml and Caddyfile. These changes work with both Community edition and Enterprise edition. There is also an option to turn the TURN server on and off, so if you decide not to use it anymore, you can just switch it off.

