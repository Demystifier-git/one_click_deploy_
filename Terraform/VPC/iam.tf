# ----------------------------
# IAM Role for EC2 (SSM + S3)
# ----------------------------
resource "aws_iam_role" "ec2_role" {
  name = "ec2-ssm-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ec2-ssm-s3-role"
  }
}

# Attach AWS managed policy for SSM (Session Manager)
resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Optional: CloudWatch Agent policy
resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach custom S3 access policy
resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "ec2-s3-access-policy"
  description = "Allow EC2 to access a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject","s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::delight2026",
          "arn:aws:s3:::delight2026/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

# Instance profile to attach role to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-s3-instance-profile"
  role = aws_iam_role.ec2_role.name
}

