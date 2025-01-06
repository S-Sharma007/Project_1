provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "EC1" {
  ami             = "ami-0ae69fd56f71576ad"
  instance_type   = "t2.micro"
  key_name        = "DevOps_complete_Project"
  security_groups = [aws_security_group.SG_project1.id]
  subnet_id       = aws_subnet.pbsubnet1.id
  for_each        = toset(["Jenkins_master", "build_slave", "ansible"])
  tags = {
    Name = "${each.key}"
  }

}


/* Creation of the SG */

resource "aws_security_group" "SG_project1" {
  name        = "SG_project1"
  description = "ALLow inbount traffic SSH connection"
  vpc_id      = aws_vpc.Project1vpc.id


  tags = {
    Name = "SG_project1"
  }


  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


  }

  egress {
    description = "ssh access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Jenkins access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

   
  }
}

resource "aws_vpc" "Project1vpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "Project1vpc"
  }
}

resource "aws_subnet" "pbsubnet1" {
  vpc_id                  = aws_vpc.Project1vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "pbsubnet1"
  }
}

resource "aws_subnet" "pbsubnet2" {
  vpc_id                  = aws_vpc.Project1vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "pbsubnet2"
  }
}


resource "aws_internet_gateway" "P1IGW" {
  vpc_id = aws_vpc.Project1vpc.id

  tags = {
    Name = "P1IGW"
  }
}

resource "aws_route_table" "routePB" {
  vpc_id = aws_vpc.Project1vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.P1IGW.id
  }


  tags = {
    Name = "routePB"
  }
}


resource "aws_route_table_association" "routePB_association01" {
  subnet_id      = aws_subnet.pbsubnet1.id
  route_table_id = aws_route_table.routePB.id
}

resource "aws_route_table_association" "routePB_association02" {
  subnet_id      = aws_subnet.pbsubnet2.id
  route_table_id = aws_route_table.routePB.id
}



module "sgs" {
    source = "../sg_eks"
    vpc_id     =     aws_vpc.Project1vpc.id
  }

  module "eks" {
      source = "../eks"
       vpc_id     =     aws_vpc.dpp-vpc.id
       subnet_ids = [aws_subnet.pbsubnet1.id,aws_subnet.pbsubnet2.id]
      sg_ids = module.sgs.security_group_public
  }