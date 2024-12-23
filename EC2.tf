provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "EC1" {
  ami = "ami-0ae69fd56f71576ad"
  instance_type = "t2.micro"
  key_name = "DevOps_complete_Project"

  tags = {
   Name = "EC1"
  }
}
