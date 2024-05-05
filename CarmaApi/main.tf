# resource "aws_instance" "test_server" {
#   ami           = "ami-07caf09b362be10b8"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.private-subnet-1.id

#   tags = {
#     Name = "server1"
#   }
# }


# Load Balancer
resource "aws_lb" "test_alb" {
  name               = "testserver-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load-balancer.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

# Target group
resource "aws_alb_target_group" "default-target-group" {
  name     = "testserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 60
    matcher             = "200"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.ec2-cluster.id
  lb_target_group_arn    = aws_alb_target_group.default-target-group.arn
}

resource "aws_alb_listener" "ec2-alb-http-listener" {
  load_balancer_arn = aws_lb.test_alb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.default-target-group]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default-target-group.arn
  }
}


resource "aws_key_pair" "terraform-lab" {
  key_name   = "${var.ec2_instance_name}_key_pair"
  public_key = file(var.ssh_pubkey_file)
}



resource "aws_autoscaling_group" "ec2-cluster" {
  name                 = "${var.ec2_instance_name}_auto_scaling_group"
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  desired_capacity     = var.autoscale_desired
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ec2.name
  vpc_zone_identifier  = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  target_group_arns    = [aws_alb_target_group.default-target-group.arn]
}





data "aws_iam_policy_document" "ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "session-manager" {
  description = "session-manager"
  name        = "session-manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "ec2:*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : "ecr:*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "elasticloadbalancing:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "cloudwatch:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "autoscaling:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : [
              "autoscaling.amazonaws.com",
              "ec2scheduled.amazonaws.com",
              "elasticloadbalancing.amazonaws.com",
              "spot.amazonaws.com",
              "spotfleet.amazonaws.com",
              "transitgateway.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.session-manager.name
  policy_arn = aws_iam_policy.session-manager.arn
}

resource "aws_iam_role" "session-manager" {
  assume_role_policy = data.aws_iam_policy_document.ec2.json
  name               = "session-manager"
  tags = {
    Name = "session-manager"
  }
}

resource "aws_iam_instance_profile" "session-manager" {
  name = "session-manager"
  role = aws_iam_role.session-manager.name
}

# resource "aws_instance" "bastion" {
#   ami                         = lookup(var.amis, var.region)
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.terraform-lab.key_name
#   iam_instance_profile        = aws_iam_instance_profile.session-manager.id
#   associate_public_ip_address = true
#   security_groups             = [aws_security_group.ec2.id]
#   subnet_id                   = aws_subnet.public-subnet-1.id
#   tags = {
#     Name = "Bastion"
#   }
# }

resource "aws_launch_configuration" "ec2" {
  name                        = "${var.ec2_instance_name}-instance"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ec2.id]
  key_name                    = aws_key_pair.terraform-lab.key_name
  iam_instance_profile        = aws_iam_instance_profile.session-manager.id
  associate_public_ip_address = false
  user_data                   = <<-EOL
  #!/bin/bash -xe
  sudo yum update -y
  sudo yum -y install docker
  sudo service docker start
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 471112707365.dkr.ecr.us-east-1.amazonaws.com
  docker pull 471112707365.dkr.ecr.us-east-1.amazonaws.com/ecrepo
  docker tag 471112707365.dkr.ecr.us-east-1.amazonaws.com/ecrepo:latest my-nginx
  docker run --rm --name nginx-server -d -p 80:80 -t my-nginx
  EOL
  depends_on                  = [aws_nat_gateway.terraform-lab-ngw]
}




resource "aws_ecr_repository" "ecr_repo" {
  name = "ecrepo"


  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_lifecycle_policy" "default_policy" {
  repository = aws_ecr_repository.ecr_repo.name


  policy = <<EOF
	{
	    "rules": [
	        {
	            "rulePriority": 1,
	            "description": "Keep only the last ${var.untagged_images} untagged images.",
	            "selection": {
	                "tagStatus": "untagged",
	                "countType": "imageCountMoreThan",
	                "countNumber": ${var.untagged_images}
	            },
	            "action": {
	                "type": "expire"
	            }
	        }
	    ]
	}
	EOF
}


data "aws_caller_identity" "current" {}


resource "null_resource" "docker_push" {

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<EOF
      docker buildx build -t "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/ecrepo:latest" -f C:\Users\Varam\OneDrive\Desktop\.vscode\.vscode\CodeBase\Dockerfile .
	    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com
      docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/ecrepo:latest
	    EOF
  }


  triggers = {
    "run_at" = timestamp()
  }


  depends_on = [
    aws_ecr_repository.ecr_repo
  ]
}