# My Terraform Test

## File List

Main.TF


Variables.TF


Subnet.TF
 - public_dmz
 - private_subnet
 - vpn_connection

Resource.TF
 - Web 1
 - Web 2
 - ELB
 - DB 1
 - LDAP 1
 - Man WS
 - Fin WS
 - HR WS
 - VPN

Security_Group.TF

VPN
 - RDP -> .2
 - SSH -> .2
 - VNC -> .2
 - .0 -> SSH
 - .0 -> VPN

 Ports
5500 VNC Server
1194 OpenVPN
135 Microsoft RPC
 5800 VNC over HTTP
5900+ VNC Server
389 LDAP
445 Microsoft DS
636 LDAP over SSL
3389 Terminal Server

1812-1813 RADIUS
