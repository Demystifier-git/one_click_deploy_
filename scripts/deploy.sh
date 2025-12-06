#!/bin/bash
set -e

cd ..
cd Terraform

cd VPC

echo "Initializing Terraform..."
terraform init -reconfigure

echo "Validating..."
terraform validate



echo "Deploying infrastructure..."
terraform apply -auto-approve
