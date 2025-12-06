resource "aws_elb" "classic_lb" {
  name               = "my-classic-lb"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = module.subnets.public_subnet_ids 

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 8080
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    target              = "HTTP:8080/"
  }


  tags = {
    Name = "classic-elb"
  }
}

resource "aws_security_group" "elb_sg" {
  name        = var.sg_name
  description = "Security group for Classic Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # Accept traffic from anywhere
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

# Attach EC2 instance to Classic LB
resource "aws_elb_attachment" "elb_attach" {
  elb      = aws_elb.classic_lb.name
  instance = aws_launch_template.app.id
}


