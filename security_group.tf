# Security Group so the ELB is web accessible
resource "aws_security_group" "elb" {
  name = "web_services_elb_security_access"
  description = "The Elastic Load Balancer to make sure there is always at least 1 web portal available"
  vpc_id = "${aws_vpc.default.id}"

  # Public to Web Servers Traffic Access Control Lists; only allow web traffic.
  # Allow HTTP from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
    description = "Allow all regular http traffic."
  }

  # Allow HTTPS from anywhere
  ingress {
    from_port = 443
    to_port = 443
    cidr_block = ["0.0.0.0/0"]
    description = "Allow all secure https traffic."
  }

  # Outbound Internet traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = ["0.0.0.0/0"]
  }
}

# DMZ and Private Subnet communication
resource "aws_security_group" "cross_subnet_comms" {
  name = "cross_subnet_communication"
  description = "Used to allow the web servers to communicate with the databases"
  vpc_id = "${aws_vpc.default.id}"

  # Database access from the DMZ
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "-1"
    cidr_block = "[10.99.1.0/24]"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol - "-1"
    cidr_block = "[0.0.0.0/0]"
  }
}

# Access to VPN subnet
resource "aws_security_group" "vpn_port_access" {
  name ="vpn_connection_port_access"
  description = "Access to the VPN server to the rest of the network."
  vpc_id = "${aws_vpc.default.id}"

  # SSH Allow on non-default ssh port
  ingress {
    from_port = 4422
    to_port = 4422
    protocol = "-1"
    cidr_block = "[0.0.0.0/0]"
  }
  # Allow OpenVPN
  ingress {
    from_port = 1194
    to_port = 1194
    protocol ="-1"
    cidr_block = "[0.0.0.0/0]"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = "[0.0.0.0/0]"
  }
}

# Allow access to private subnet from VPN
resource "aws_security_group" "private_vpn_access" {
  name ="vpn_connection_to_private_subnet_access"
  description = "Access from the VPN server from outside the network."
  vpc_id = "${aws_vpc.default.id}"

  # SSH Allow from VPN
  ingress {
    from_port = 22
    to_port = 22
    protocol = "-1"
    cidr_block = "[10.99.3.0/24]"
  }
  # VNC Server Allow from VPN
  ingress {
    from_port = 5500
    to_port = 5500
    protocol = "-1"
    cidr_block = "[10.99.3.0/24]"
  }
  # VNC Server Allow from VPN HTTP
  ingress {
    from_port = 5800
    to_port = 5800
    protocol = "-1"
    cidr_block = "[10.99.3.0/24]"
  }
  # VNC Server Allow from VPN
  ingress {
    from_port = 5900
    to_port = 6000
    protocol = "-1"
    cidr_block = "[10.99.3.0/24]"
  }
  # LDAP / Active Directory (Generic)
  ingress {
    from_port = 389
    to_port = 389
    protocol = "-1"
    cidr_block = ["10.99.3.0/24"]
  }
  # LDAP / Active Directory (Microsoft)
  ingress {
    from_port = 445
    to_port = 445
    protocol = "-1"
    cidr_block = ["10.99.3.0/24"]
  }
  # LDAP / Active Directory (Over SSL)
  ingress {
    from_port = 636
    to_port = 636
    protocol = "-1"
    cidr_block = ["10.99.3.0/24"]
  }
  # Microsoft Remote Desktop
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "-1"
    cidr_block = ["10.99.3.0/24"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = "[0.0.0.0/0]"
  }
}

# Allow access to private subnet from VPN
resource "aws_security_group" "vpn_ssh_access" {
  name ="vpn_connection_to_dmz_subnet_access"
  description = "Access from the VPN server from outside the network."
  vpc_id = "${aws_vpc.default.id}"

  # SSH Allow from VPN
  ingress {
    from_port = 22
    to_port = 22
    protocol = "-1"
    cidr_block = "[10.99.3.0/24]"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = "[0.0.0.0/0]"
  }
}
