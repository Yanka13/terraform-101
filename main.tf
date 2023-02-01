
# 1 - Declare providers
provider "aws" {
  region = "eu-west-3"
}

# 2 - Use data sources
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

variable "number_of_instances" {
   type = number
}

# 3 - Set resources
resource "aws_instance" "web-server" {
  ami               =  data.aws_ami.ubuntu.id
  count = var.number_of_instances
  instance_type     = "t2.micro"
  user_data = file("${path.module}/install.sh")
  user_data_replace_on_change = true
  tags = {
    Name = "web-server"
  }
}

output "instance_ip_address" {
  value = aws_instance.web-server[0].public_dns
}
