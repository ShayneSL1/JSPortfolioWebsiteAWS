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

#Subnet 1

#Internet Gateway

#Route Table

#Route Table Associations