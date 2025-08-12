# CAUTION: arn number below is just an example. It is necessary to add a secret manager credentials in System Manager on aws, get the arn and write below
data "aws_secretsmanager_secret" "secret" {
  arn                       = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id                 = data.aws_secretsmanager_secret.secret.id
}

# To get "Host" and "DB" data in secret manager it is necessary to add a secret manager credentials in System Manager on aws (see instruction above) with key/value: Host/localhost and DB/db
resource "aws_launch_template" "template" {
  image_id                  = var.ami_id
  instance_type             = var.instance_type
  tags = {
    project_name            = var.project_name
    Name                    = "${var.prefix}-template"
  }
  user_data = base64encode(
<<EOF
#!/bin/bash
DB_STRING="Server=${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["Host"]};DB=${jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["DB"]}"
echo $DB_STRING > test.txt
EOF
)

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      project_name  = var.project_name
      Name          = "${var.prefix}-node"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  min_size          = 1
  desired_capacity  = 2
  max_size          = 3

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}