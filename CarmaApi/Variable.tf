variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}
variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}


# load balancer

variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/"
}

variable "amis" {
  description = "Which AMI to spawn."
  default = {
    us-east-1 = "ami-05fa00d4c63e32376"
    us-east-2 = "ami-0568773882d492fc8"
  }
}
variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_instance_name" {
  description = "Name of the EC2 instance"
  default     = "test_server"
}



# key pair - Location to the SSH Key generate using openssl or ssh-keygen or AWS KeyPair
variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/id_ed25519.pub"
}


# auto scaling

variable "autoscale_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "2"
}
variable "autoscale_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "2"
}

variable "untagged_images" {
  description = "Desired no.of untagged images"
  default     = "1"
}