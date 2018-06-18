resource "aws_elb" "web" {
  name = "web-services-elb"

  subnets         = ["${aws_subnet.public_dmz.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.web1.id}","${aws_instance.web2.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 443
    instance_protocol = "HTTPS"
    lb_port           = 443
    lb_protocol       = "HTTPS"
  }


}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "web1" {
  # The default username for AMI
  connection {
    user = "ubuntu"
  }

  instance_type = "t2.medium"

  # Specifying the AMI
  ami = "ami-a2a2a2a2"

  # The name of the SSH keypair
  key_name = "${aws_key_pair.auth.id}"

  # The Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.elb.id}", "${aws_security_group.vpn_ssh_access.id}"]

  # subnet ID
  subnet_id = "${aws_subnet.public_dmz.id}"

  # install and start nginx server
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
}
  resource "aws_instance" "web2" {
    # The default username for AMI
    connection {
      user = "ubuntu"
    }

    instance_type = "t2.medium"

    # Specifying the AMI
    ami = "ami-b1b1b1b1"

    # The name of the SSH keypair
    key_name = "${aws_key_pair.auth.id}"

    # The Security group to allow HTTP and SSH access
    vpc_security_group_ids = ["${aws_security_group.elb.id}", "${aws_security_group.vpn_ssh_access.id}"]

    # Subnet ID
    subnet_id = "${aws_subnet.public_dmz.id}"

    # install and start nginx server
    provisioner "remote-exec" {
      inline = [
        "sudo apt-get -y update",
        "sudo apt-get -y install nginx",
        "sudo service nginx start",
      ]
    }
}


resource "aws_db_instance" "default" {
  depends_on             = ["aws_security_group.cross_subnet_comms"]
  identifier             = "web-mysql"
  allocated_storage      = "500 GB"
  engine                 = "mysql"
  engine_version         = "5.7.21"
  instance_class         = "db.t2.micro"
  name                   = "web_db"
  username               = "web_user"
  password               = "qw3rty"
  vpc_security_group_ids = ["${aws_security_group.cross_subnet_comms.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
}

resource "aws_db_subnet_group" "default" {
  name        = "main_db_subnet_group"
  description = "The db subnet"
  subnet_ids = ["${aws_subnet.private_subnet.id}"]
}


resource "aws_instance" "Active_Directory" {
  # The default username for the AMI
  connection {
    user = "AD-Admin"
  }

  instance_type = "t2.medium"

  # Specifying the AMI
  ami = "ami-c3c3c3c3"

  # The name of the SSH keypair
  key_name = "${aws_key_pair.auth.id}"

  # The Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.private_vpn_access.id}"]

  # subnet ID
  subnet_id = "${aws_subnet.private_subnet.id}"

}

resource "aws_instance" "vpn" {
  # The default username for AMI
  connection {
    user = "ubuntu"
  }

  instance_type = "t2.medium"

  # Specifying the AMI
  ami = "ami-d4d4d4d4"

  # The name of the SSH keypair
  key_name = "${aws_key_pair.auth.id}"

  # The Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.vpn_port_access.id}"]

  # subnet ID
  subnet_id = "${aws_subnet.vpn_connection.id}"

}
