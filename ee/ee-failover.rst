===================================================
How to set up p2p failover in Netmaker Enterprise
===================================================

Netmaker Enterprise offers a peer to peer failover option. There are scenarios where a peer to peer connection may be difficult to achieve like a restrictive CG NAT, or a double NAT. Failover provides an automated way to relay those tricky connections when they are not working.

A failover is easy to setup on Netmaker. Simply pick a node with a strong connection that you would like to use, and click the failover button. That's it.


(screenshot of failover will be here)

You will notice when you click the failover button that the ingress status gets turned on as well. This is normal. Failover is actually very similar to ingress. It uses the same iptables rules and calculates it's peers in very similar ways. Failover uses a few extra steps to work properly. 

When you turn the failover on, Netmaker will use the metrics it obtains from the peers to figure out if any need to be rerouted. If it sees that a peer has been disconnected and the last handshake has been longer than two minutes, it will route that peer to the failover. The whole process should take about three minutes. You should see the IP of the disconnected peer in the allowed IPs of the failover server. 

(screenshot of peer in allowed ips of failover server)