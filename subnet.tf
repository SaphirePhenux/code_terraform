# Create Public DMZ subnet for Web Servers / Load Balancer
resource "aws_subnet" "public_dmz" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.99.1.0/24"
  map_public_ip_on_launch = true
}

# Create Private subnet for LDAP, Database, and WS instances
resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.99.2.0/24"
  map_public_ip_on_launch = false
}

# Create a VPN Connection for offsite access
resource "aws_subnet" "vpn_connection" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.99.3.0/24"
  map_public_ip_on_launch = true
}
