provider "aws" {
  region = "ap-southeast-2"
  }

resource "aws_vpc" "dev" {
cidr_block = "10.0.0.0/16"
#instance_tenancy = "default"
#enable_dns_support = "true"
#enable_dns_hostname = "true"
#enable_clasiclink = "false"
 
 tags = {
    Name = "aws-vpc-dev"
    }
 
 }
resource "aws_subnet" "aws-public-subnet1" {
vpc_id = aws_vpc.dev.id
cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = "true"
availability_zone = "ap-southeast-2a"
tags ={
 Name = "aws-public-subnet1"
}
}

resource "aws_subnet" "aws-public-subnet2" {
vpc_id = aws_vpc.dev.id
cidr_block = "10.0.2.0/24"
map_public_ip_on_launch = "true"
availability_zone = "ap-southeast-2b"
tags = {
  Name = "aws-public-subnet2"
}
}

resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "aws-igw"
  }
}

resource "aws_route_table" "aws-rt" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-igw.id
  }
 tags = {
       Name = "aws-public-route-table"
}
}

resource "aws_route_table_association" "aws-rt-association1" {
  subnet_id      = aws_subnet.aws-public-subnet1.id
  route_table_id = aws_route_table.aws-rt.id
}

resource "aws_route_table_association" "aws-rt-association2" {
  subnet_id      = aws_subnet.aws-public-subnet2.id
  route_table_id = aws_route_table.aws-rt.id
}

resource "aws_instance" "instance1" {
  ami = "ami-080660c9757080771"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.aws-public-subnet1.id}"
  tags = {
              Name = "aws-instance1"
}
}

resource "aws_instance" "instance2" {
ami = "ami-080660c9757080771"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.aws-public-subnet2.id}"
tags = {
Name = "aws-instance2"
}

}
