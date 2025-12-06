#!/bin/bash
set -e

sudo -i
snap install aws cli --classic

S3_BUCKET="delight2026"
echo "[3/8] Downloading app from s3://$S3_BUCKET/app.zip"
aws s3 cp s3://$S3_BUCKET/app.zip .

echo "[1/8] Updating system packages..."
apt-get update -y
apt-get upgrade -y
sudo apt-get install -y unzip zip

echo "Unzipping application package..."
unzip -o app.zip


cd app


curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs
npm install
npm install -g pm2

pm2 start server.js --name "app-server" --watch
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
