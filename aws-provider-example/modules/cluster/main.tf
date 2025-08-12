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
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
public_ip=$(curl http://checkip.amazonaws.com/)
echo "
<html>
  <head><title>Hello from Nginx!</title></head>
  <body><h1>Hello from Nginx!</h1>
  <p>Your public IP is: $public_ip</p>
  </body>
</html>" | tee /usr/share/nginx/html/index.html > dev/null
systemctl restart nginx
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
  name              = "${var.prefix}-asg"
  min_size          = 1
  desired_capacity  = 2
  max_size          = 3

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "${var.prefix}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "scale_out_alarm" {
  alarm_description   = "Monitor Average CPU Utilization"
  alarm_name          = "${var.prefix}-scale-out-alarm"
  namespace          = "AWS/EC2"
  metric_name        = "CPUUtilization"
  threshold          = "60"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  period             = "30"
  statistic          = "Average"
  alarm_actions = [aws_autoscaling_policy.scale_out_policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "${var.prefix}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
  alarm_description   = "Monitor Average CPU Utilization"
  alarm_name          = "${var.prefix}-scale-in-alarm"
  namespace          = "AWS/EC2"
  metric_name        = "CPUUtilization"
  threshold          = "20"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  period             = "30"
  statistic          = "Average"
  alarm_actions = [aws_autoscaling_policy.scale_in_policy.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}