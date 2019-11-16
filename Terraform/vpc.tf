provider "aws" {
   region = "us-west-2"
}

data "aws_availability_zones" "available" {}

#VPC Creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/20"
  enable_dns_hostnames = true
  enable_dns_support = true

  #tags{
  # Name = "my-test-terraform-vpc"
  #}
}


#Create Internet Gateway
resource "aws_internet_gateway" "gw"{
  vpc_id = "${aws_vpc.main.id}"

  #tags = {
  # Name = "my-test-terraform-igw"
  #}
}


#Create public route table
resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "my-public-route-table"
  }
}


#Create private route table
resource "aws_default_route_table" "private_route" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  tags = {
    Name = "my-default-route-table"
  }
}


#Public subnet
resource "aws_subnet" "public_subnet" {
  count = 3
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = element(var.public_cidrs,count.index) #"${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "public-subnet-$[count.index + 1]"
  }
}


#Create Private subnet
resource "aws_subnet" "private_subnet" {
  count = 3
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.private_cidrs[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "private-subnet-$[count.index + 1]"
  }
}


#Create public subnet route table association
resource "aws_route_table_association" "pub_sub_assoc" {
  count		 = "${length(aws_subnet.public_subnet)}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.public_route.id}"
  depends_on	 = ["aws_route_table.public_route","aws_subnet.public_subnet"]
}


#Create private subnet route table association
resource "aws_route_table_association" "priv_sub_assoc" {
  count          = "${length(aws_subnet.private_subnet)}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  route_table_id = "${aws_default_route_table.private_route.id}"
  depends_on	 = ["aws_default_route_table.private_route","aws_subnet.private_subnet"]
}


#Security Group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]# add a CIDR block here
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  #tags {
  #  Name = "my-test-terraform-securitygrp"
  #}
}


