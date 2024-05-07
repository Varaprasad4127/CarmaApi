# CarmaApi
## Introduction
Create a Terraform codebase to deploy a simple web server microservice on a cloud environment, containerized with Docker and accessible via a Load Balancer.
<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
## OS
This POC Assignment is implemented on a windows OS
<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener.ec2-alb-http-listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.default-target-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_autoscaling_attachment.asg_attachment_bar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.ec2-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_ecr_lifecycle_policy.default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ecr_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.session-manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.session-manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.session-manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.test-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.terraform-lab-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.terraform-lab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_configuration.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.test_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_nat_gateway.terraform-lab-ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.nat-ngw-route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public-internet-igw-route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private-route-table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public-route-table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private-route-1-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private-route-2-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-route-1-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-route-2-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.load-balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private-subnet-1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private-subnet-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-subnet-1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-subnet-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.test_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [null_resource.docker_push](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amis"></a> [amis](#input\_amis) | Which AMI to spawn. | `map` | <pre>{<br>  "us-east-1": "ami-07caf09b362be10b8",<br>  "us-east-2": "ami-0568773882d492fc8"<br>}</pre> | no |
| <a name="input_autoscale_desired"></a> [autoscale\_desired](#input\_autoscale\_desired) | Desired autoscale (number of EC2) | `string` | `"1"` | no |
| <a name="input_autoscale_max"></a> [autoscale\_max](#input\_autoscale\_max) | Maximum autoscale (number of EC2) | `string` | `"1"` | no |
| <a name="input_autoscale_min"></a> [autoscale\_min](#input\_autoscale\_min) | Minimum autoscale (number of EC2) | `string` | `"1"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_ec2_instance_name"></a> [ec2\_instance\_name](#input\_ec2\_instance\_name) | Name of the EC2 instance | `string` | `"test_server"` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health check path for the default target group | `string` | `"/"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_private_subnet_1_cidr"></a> [private\_subnet\_1\_cidr](#input\_private\_subnet\_1\_cidr) | CIDR Block for Private Subnet 1 | `string` | `"10.0.3.0/24"` | no |
| <a name="input_private_subnet_2_cidr"></a> [private\_subnet\_2\_cidr](#input\_private\_subnet\_2\_cidr) | CIDR Block for Public Subnet 2 | `string` | `"10.0.4.0/24"` | no |
| <a name="input_public_subnet_1_cidr"></a> [public\_subnet\_1\_cidr](#input\_public\_subnet\_1\_cidr) | CIDR Block for Public Subnet 1 | `string` | `"10.0.1.0/24"` | no |
| <a name="input_public_subnet_2_cidr"></a> [public\_subnet\_2\_cidr](#input\_public\_subnet\_2\_cidr) | CIDR Block for Public Subnet 2 | `string` | `"10.0.2.0/24"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to create resources in. | `string` | `"us-east-1"` | no |
| <a name="input_ssh_pubkey_file"></a> [ssh\_pubkey\_file](#input\_ssh\_pubkey\_file) | Path to an SSH public key | `string` | `"~/.ssh/id_ed25519.pub"` | no |
| <a name="input_untagged_images"></a> [untagged\_images](#input\_untagged\_images) | Desired no.of untagged images | `string` | `"1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR Block for VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns"></a> [alb\_dns](#output\_alb\_dns) | n/a |
<!-- END_TF_DOCS -->
