provider "aws" {
  region            = "us-east-1"
}

variables {
  project_name = "tf-test"
  prefix = "test"
}

run "network" {
    
    command = apply

    variables {
        vpc_cidr_block = "10.0.0.0/16"
        subnet_cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
    }

    module {
      source = "../network"
    }

    assert {
        condition = length(output.subnet_ids) == 2
        error_message = "Expected 2 subnet IDs to be created"
    }

}

run cluster {

    command = apply

    variables {
        subnet_ids          = run.network.subnet_ids
        security_group_ids  = [run.network.security_group_id]
        vpc_id              = run.network.vpc_id
        image_id            = "ami-0de716d6197524dd9"
        instance_type       = "t2.micro"
        min_size            = 1
        desired_capacity    = 1
        max_size            = 1
        scale_in = {
            cooldown           = 60
            threshold          = 20
            scaling_adjustment = -1
        }
        scale_out = {
            cooldown           = 60
            threshold          = 70
            scaling_adjustment = 1
        }
        user_data = <<EOF
        #!/bin/bash
        yum update -y
        yum install -y nginx
        systemctl start nginx
        EOF
    }

    module {
        source = "../cluster"
    }

    assert {
        condition = aws_lb.app_lb.dns_name != null
        error_message = "Expected application load balancer to be created"
    }

    assert {
        condition = output.lb_arn != null
        error_message = "Expected application load balancer ARN to be output"
    }

}

run "verify_http" {
    command = apply

    variables {
        lb_arn = run.cluster.lb_arn
    }

    module {
        source = "./testing/http"
    }
    assert {
        condition = data.http.lb.status_code == 200
        error_message = "Expected HTTP 200 response from load balancer"
    }

}