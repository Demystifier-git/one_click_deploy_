############################################
# EC2 SECURITY GROUP
############################################
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg-3"
  description = "Allow ALB traffic only"
  vpc_id      = module.vpc.vpc_id

  # Only ALB SG allowed — secure
  ingress {
    description     = "Allow traffic from ALB"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }

  # Outbound open
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg-2"
  }
}

############################################
# EC2 LAUNCH TEMPLATE
############################################
resource "aws_launch_template" "app" {
  name_prefix = "app-template-"

  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]



  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    s3_bucket = var.app_s3_bucket
    s3_key    = var.app_s3_key
  }))

  # Required for ASG
  lifecycle {
    create_before_destroy = true
  }

  # Allow IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "app-server"
  }

# ✅ IAM instance profile as a block
   iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }




  

}

############################################
# AUTO SCALING GROUP
############################################
resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  vpc_zone_identifier       = module.subnets.private_subnet_ids
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

    load_balancers = [aws_elb.classic_lb.Id]   # attach the Classic LB

  tag {
    key                 = "Name"
    value               = "autoscaled-app"
    propagate_at_launch = true
  }
}
