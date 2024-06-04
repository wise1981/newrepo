resource "aws_vpc" "genius-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "genius-vpc"
  }
}

#public-subnet-1
resource "aws_subnet" "prod-pub-sub1" {
  vpc_id     = aws_vpc.genius-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-pub-sub1"
  }
}

#public-subnet-2
resource "aws_subnet" "prod-pub-sub2" {
  vpc_id     = aws_vpc.genius-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "prod-pub-sub2"
  }
}

#private-subnet-1
resource "aws_subnet" "prod-pri-sub1" {
  vpc_id     = aws_vpc.genius-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "prod-pri-sub1"
  }
}

#private-subnet-2
resource "aws_subnet" "prod-pri-sub2" {
  vpc_id     = aws_vpc.genius-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "prod-pri-sub2"
  }
}

#public route table 
resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.genius-vpc.id

  tags = {
    Name = "prod-pub-route-table"
  }
}

#private route table 
resource "aws_route_table" "prod-pri-route-table" {
  vpc_id = aws_vpc.genius-vpc.id

  tags = {
    Name = "prod-pri-route-table"
  }
}

#public subnet association 
resource "aws_route_table_association" "prod-pub-association" {
  subnet_id      = aws_subnet.prod-pub-sub1.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}

#private subnet association 
resource "aws_route_table_association" "prod-pri-association" {
  subnet_id      = aws_subnet.prod-pri-sub1.id
  route_table_id = aws_route_table.prod-pri-route-table.id
}

#internet gateway 
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.genius-vpc.id

  tags = {
    Name = "IGW-Terraform"
  }
}

#route table destination and target
resource "aws_route" "public-internet-route" {
  route_table_id            = aws_route_table.prod-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.prod-igw.id
}
