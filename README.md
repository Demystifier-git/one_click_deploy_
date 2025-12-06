One-Click AWS Deployment for a REST API

This project provides a one-click deployment solution that provisions a complete AWS architecture to run a simple REST API. The API runs on private EC2 instances behind a Classic Load Balancer (CLB), with Terraform managing the infrastructure.

The deployment is fully repeatable, secure, and follows AWS best practices, including: no public EC2 instances, secure SSM access, and least-privilege IAM policies.
                      

ARCHITECTURE OVERVIEW
Client → CLB (Public Subnets) → Target Group → ASG → EC2 (Private Subnets)
                           ↑
                 Security Groups
                           ↓
Private EC2 → NAT Gateway → Internet Gateway


Key points:

EC2 instances are deployed in private subnets for security.

Traffic is routed through the Classic Load Balancer (CLB).

NAT Gateway and Internet Gateway enable outbound access for private instances.

Security groups enforce strict access: only the CLB can access EC2 instances.



AWS Resources Created

VPC: CIDR 10.0.0.0/16

Subnets: 2 public and 2 private

Internet Gateway

NAT Gateway

Route Tables

Classic Load Balancer (HTTP/HTTPS)

Note: A Classic Load Balancer is used because this AWS account is less than 72 hours old and cannot create an Application Load Balancer.

Launch Template: EC2 instances with user-data scripts

Auto Scaling Group: EC2 instances in private subnets

IAM Role for EC2:

AmazonSSMManagedInstanceCore

CloudWatchAgentServerPolicy

S3 bucket access

Security Groups:

CLB SG → allows HTTP/HTTPS from anywhere

EC2 SG → allows traffic only from the CLB SG

DynamoDB table for Terraform state locking (security best practice)

S3 bucket for storing Terraform state files and zipped application files

                  

DEPLOYMENT STEPS
Cd into scripts and run ./deploy.sh


TEARDOWN STEP
Cd into scripts and run ./destroy.sh

                  
                  
TESTING STEPS
check pm2 status (check server status on EC2)
curl http://0.0.0.0:8080 (test locally on EC2)
http://my-classic-lb-564157245.us-east-1.elb.amazonaws.com/ (test API from a broswer)




Github actions workflow (optional)
name: Deploy to AWS

on:
  push:
    branches:
      - master

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
      - name: Terraform Init & Apply
        run: |
          cd terraform
          cd VPC
          terraform init
          terraform apply -auto-approve
      

| Feature                                    | Screenshot                                                                                                    |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| API Test on Browser                        | ![API test on a browser](screenshots/API%20test%20on%20a%20broswer.png)                                       |
| Application Load Balancer – Creation Error | ![Application load balancer creation error](screenshots/application%20load%20balancer%20creation%20error.png) |
| Classic Load Balancer                      | ![Classic load balancer](screenshots/classic%20load%20balancer.png)                                           |
| DynamoDB Console                           | ![DynamoDB console](screenshots/Dynamodb%20console.png)                                                       |
| EC2 Console                                | ![EC2 console](screenshots/ec2-console.png)                                                                   |
| S3 Console                                 | ![S3 console](screenshots/s3%20console.png)                                                                   |
| Target Group & Registered Instance         | ![Target group and registered instance](screenshots/target%20group_and%20regsitered%20instance.png)           |
| Target Instance                            | ![Target instance](screenshots/target%20instance.png)                                                         |
| Test on EC2                                | ![Test on EC2](screenshots/test%20on%20EC2.png)                                                               |
| VPC Console Extension                      | ![VPC console extension](screenshots/VPC%20console%20extention.png)                                           |
| VPC Console                                | ![VPC console](screenshots/VPC%20console.png)                                                                 |










