<!-- BEGIN_TF_DOCS -->
## Requirements

DevOps Junior Assignment: Terraform Deployment for Microservice

Objective

Create a Terraform codebase to deploy a simple web server microservice on a cloud environment,
containerized with Docker and accessible via a Load Balancer.

Context

The goal of this exercise is to test your understanding of a Cloud Compute deployment with Terraform.
You are tasked with creating a codebase for a microservice deployment on a cloud environment, using
Terraform.
Since our focus is not the application itself, the service will be a simple web server that returns a static
page. You can use an apache2 or nginx server and serve a simple html file.
The service should be containerized and kept in a Docker registry.
The service should be deployed on a single VM instance as a docker container. The image should be
pulled from the registry specified earlier.
The service should not be accessible from the internet but only from a Load Balancer, except for an SSH
connection from specific IP addresses.

Tasks

1. Dockerfile Creation
• Create a Dockerfile for building the Docker image of the simple web server.
• Use a basic web server like nginx or Apache serving a static HTML page.
2. Terraform Codebase
• Set up a Docker registry.
• Provision VPC and necessary networking resources.
• Deploy a single VM instance.
• Configure a Load Balancer.
3. Terraform Deployment
• Push the local Docker image to the Docker registry using Terraform.
• Pull the image from the registry and run it on the VM instance using Terraform.
4. Security Measures
• Ensure that the service is not directly accessible from the internet but only through
the Load Balancer.
• Allow SSH access only from specific IP addresses.
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

CarmaApi

## POC

## provider.tf

AWS is configured as the cloud provider using terraform. AWS CLI is installed in local computer and the credentials file is used to pass the access key and private key securely.

## network.tf

vpc is created.

Public subnets are created.

Private subnets are created.

Internet Gateway for the public subnet is created.

NAT Gateway for the public subnet is created.

Route tables for the subnets are created.

Routing the public subnet traffic through the Internet Gateway.

Routing NAT Gateway.

Associate the newly created route tables to the subnets.

Security Groups are created and configured with necessary inbound and outbound rules.

ALB Security Group (Traffic Internet -> ALB).

Instance Security group (traffic ALB -> EC2, ssh -> EC2).

## main.tf

A load balancer is created in the public subnet to act as a reverse proxy. alb listener resource is created and configured to listen on port 80 and forward to the target group.

An ecr repository is created.

A null resource is used to execute a script which will build a docker image for the dockerfile created locally. Also it logins to the aws ecr using AWS CLI from powershell. After logging in, the local docker image for the sample app html page is pushed to the remote aws ecr repository.

An autoscaling group is created which spins up a single instance in the private subnet. A launch configuration template was created with the desired configuration of the virtual machine and it is attached to the auto scaling group. IAM role and policy are created which will grant all the necessary permissions to the private ec2. The launch template also has user data script which will be executed when the instance spins up. The script installs docker in the virtual machine. It retrieves the docker image from the ecr repository and deploys it on the server.

a bastion server is created in the public subnet. A local ssh key pair is created and the key pair's public key is registered with AWS to allow logging-in to EC2 instances.

## variable.tf 

Contains all the variables used in configuration.

## output.tf

It displays the dns adress of load balancer as output.


<!-- END_TF_DOCS -->
