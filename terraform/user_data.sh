#!/bin/bash
set -euo pipefail

# Update Ubuntu packages
apt-get update -y

# Install prerequisites for AWS CLI v2 and Docker
apt-get install -y ca-certificates curl unzip

# Install AWS CLI v2 using the official AWS installer
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install
rm -rf /tmp/aws /tmp/awscliv2.zip

# Verify AWS CLI installation
aws --version

# Retrieve secrets from AWS Systems Manager Parameter Store
get_ssm_parameter() {
  aws ssm get-parameter \
    --name "$1" \
    --with-decryption \
    --region ap-south-1 \
    --query 'Parameter.Value' \
    --output text
}

JWT_SECRET="$(get_ssm_parameter ecommerce-dev-jwt-secret)"
MONGODB_URI_USER="$(get_ssm_parameter ecommerce-dev-mongodb-uri-user)"
MONGODB_URI_PRODUCT="$(get_ssm_parameter ecommerce-dev-mongodb-uri-product)"
MONGODB_URI_CART="$(get_ssm_parameter ecommerce-dev-mongodb-uri-cart)"
MONGODB_URI_ORDER="$(get_ssm_parameter ecommerce-dev-mongodb-uri-order)"

# Add Docker's official signing key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository for Ubuntu
. /etc/os-release
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  ${UBUNTU_CODENAME:-$VERSION_CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list

# Install Docker Engine and Docker Compose plugin
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker at boot
systemctl enable --now docker

# Verify Docker installation in the boot log
docker --version

# Create a shared network for the e-commerce containers
docker network inspect ecommerce-network >/dev/null 2>&1 || \
  docker network create ecommerce-network

# Download the five application images from Docker Hub
docker pull learndevopsabhash/ecommerce-user-service:1.0
docker pull learndevopsabhash/ecommerce-product-service:1.0
docker pull learndevopsabhash/ecommerce-cart-service:1.0
docker pull learndevopsabhash/ecommerce-order-service:1.0
docker pull learndevopsabhash/ecommerce-frontend:1.1


# Start the User Service
docker run -d \
  --name ecommerce-user-container \
  --network ecommerce-network \
  --restart unless-stopped \
  -p 3001:3001 \
  -e PORT=3001 \
  -e MONGODB_URI="$MONGODB_URI_USER" \
  -e JWT_SECRET="$JWT_SECRET" \
  learndevopsabhash/ecommerce-user-service:1.0

# Start the Product Service
docker run -d \
  --name ecommerce-product-container \
  --network ecommerce-network \
  --restart unless-stopped \
  -p 3002:3002 \
  -e PORT=3002 \
  -e MONGODB_URI="$MONGODB_URI_PRODUCT" \
  learndevopsabhash/ecommerce-product-service:1.0

# Start the Cart Service
docker run -d \
  --name ecommerce-cart-container \
  --network ecommerce-network \
  --restart unless-stopped \
  -p 3003:3003 \
  -e PORT=3003 \
  -e MONGODB_URI="$MONGODB_URI_CART" \
  learndevopsabhash/ecommerce-cart-service:1.0

# Start the Order Service
docker run -d \
  --name ecommerce-order-container \
  --network ecommerce-network \
  --restart unless-stopped \
  -p 3004:3004 \
  -e PORT=3004 \
  -e MONGODB_URI="$MONGODB_URI_ORDER" \
  learndevopsabhash/ecommerce-order-service:1.0

# Start the Frontend Service
docker run -d \
  --name ecommerce-frontend-container \
  --network ecommerce-network \
  --restart unless-stopped \
  -p 80:80 \
  learndevopsabhash/ecommerce-frontend:1.1
