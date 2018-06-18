# Main.TF
# Includes most of the primary Resources

# Specifying the provider to use
provider "aws" {
  region = "us-west-2"
}

# Creating a VPC to hold the instances
resource "aws_vpc" "default" {
  cidr_block = "10.99.0.0/16"
}

# Creating an Internet Gateway to give Internet access to the VPC / Public Subnet
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant the VPC Internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

## For subnet information see subnet.tf

## For Security Group info, see Security_Group.tf
