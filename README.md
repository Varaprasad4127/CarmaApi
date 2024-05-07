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

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
