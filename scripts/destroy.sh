#!/bin/bash
set -e

cd ..
cd Terraform
cd VPC



echo "Destroying infrastructure..."
terraform destroy -auto-approve
