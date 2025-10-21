provider "aws" {
    region = "us-east-2"
}

#VPC
resource "aws_vpc" "MyVPC" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "MyVPC-tf"
  }
}

#Subnet 0
resource "aws_subnet" "subnet0" {
  vpc_id = aws_vpc.MyVPC.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "subnet0"
  }
}

#Subnet 1
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.MyVPC.id
  cidr_block = "192.168.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "subnet1"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "vpcIGW" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    Name = "vpcIGW"
  }
}

#Route Table
resource "aws_route_table" "routing-table" {
  vpc_id = aws_vpc.MyVPC.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpcIGW.id

  }
  tags = {
    Name = "main-route-table"
  }
}

#Route Table Associations
resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.subnet0.id
    route_table_id = aws_route_table.routing-table.id

  
}

resource "aws_route_table_association" "b" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.routing-table.id
    
  
}