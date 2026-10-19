# E-Commerce Microservices Application

# Project roadmap

## Phase 1 — Application assessment
Inspect the GitHub repository, understand the five services, identify ports, and check existing application code.


## Phase 2 — Docker containerization
Create or review five Dockerfiles, build the images, test the containers locally, and push versioned images to Docker Hub.


## Phase 3 — Terraform infrastructure
Create the VPC, public subnet, internet gateway, route table, security group, and EC2 instance using reusable Terraform configuration.

## Phase 4 — Automated deployment
Use EC2 user data to install Docker, pull the images, and start all five containers with suitable port mappings and service communication.

## Phase 5 — Verification and cleanup
Verify the frontend using the public IP, check backend health and logs, review Terraform outputs, and destroy resources when finished to avoid unnecessary AWS charges.

## 🏗️ Architecture Overview
```
Frontend (React) → API Gateway → Microservices
                                    ├── User Service (3001)
                                    ├── Product Service (3002)
                                    ├── Cart Service (3003)
                                    └── Order Service (3004)
```
# Local Deployment
## Phase 1 — Application assessment

## Check all the files in the current project to create Dockerfile
### Step 1 — Inspect the project repository

```
git clone https://github.com/learndevopsabhash/E-commerce-App-Using-Terraform-and-Docker.git
cd E-commerce-App-Using-Terraform-and-Docker
git status
git branch --show-current
ls -la
```
### Step 2 — Inspect application configuration and dependencies

### 2.1 Inspect the backend dependencies

```
cat backend/user-service/package.json
cat backend/product-service/package.json
```
<img width="1896" height="996" alt="image" src="https://github.com/user-attachments/assets/cee97b46-06b6-4257-9456-b370ff31e9b0" />

```
cat backend/order-service/package.json
cat backend/cart-service/package.json
```
<img width="1896" height="992" alt="image" src="https://github.com/user-attachments/assets/8253904d-af38-413d-aab5-db92fb858f63" />


### 2.2 Inspect the frontend configuration
```
cat frontend/package.json
```
<img width="1895" height="991" alt="image" src="https://github.com/user-attachments/assets/632904d6-110b-4382-84f6-79a2efd8d198" />


### 2.3 Check the application ports and database configuration
```
grep -nE 'listen|PORT|MONGO|mongo|process\.env' backend/*/server.js
```
<img width="1895" height="666" alt="image" src="https://github.com/user-attachments/assets/6ae5a193-2ea6-412e-8067-dcb509d90d32" />

### Step 3 — Inspect frontend API URLs
```
cat frontend/src/services/api.js
```
<img width="1896" height="960" alt="image" src="https://github.com/user-attachments/assets/f406ba63-c655-499f-b96b-5d03649db8bd" />
<img width="1897" height="986" alt="image" src="https://github.com/user-attachments/assets/f95791e3-8a8c-4226-bc12-7654992f2239" />
<img width="1896" height="528" alt="image" src="https://github.com/user-attachments/assets/2380eed8-0cff-49fc-bccc-6e969bc3cbd7" />


### Step 4 — Verify the local prerequisites
```
docker --version
docker login
```

<img width="1896" height="245" alt="image" src="https://github.com/user-attachments/assets/65e86bbe-7578-4a00-8293-972c3a805997" />

### Step 5 — Check whether MongoDB is available
- We user MongoDB Atlas database configuration.

### Step 6 — Create the local environment file

```
touch backend/user-service/.env 
touch backend/product-service/.env
touch backend/cart-service/.env
touch backend/order-service/.env
```
<img width="1902" height="412" alt="image" src="https://github.com/user-attachments/assets/bd6d0376-dba2-4a4f-891f-035d106b2a4d" />

## Phase 2 — Docker containerization

### Create  Docker images
- Create five Dockerfiles.
- Build and run each container locally.
- Test application responses.
- Tag and push all five images to Docker Hub.

### Step 1
### 1.1 Create the Dockerfile for the User Service
```
cd backend/user-service
nano Dockerfile
```
-
```
FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .
EXPOSE 3001
CMD ["node", "server.js"]
```

### 1.2 Build the User Service Docker image
```
docker build -t ecommerce-user-service:1.0 .
```
<img width="1162" height="777" alt="image" src="https://github.com/user-attachments/assets/c7424cb0-483a-47f0-a30c-9eae858f5cae" />

### 1.3 Run the User Service container & Verify the container is running
```
docker run -d --name ecommerce-user-container -p 3001:3001 --env-file .env ecommerce-user-service:1.0
docker ps --filter "name=ecommerce-user-container"
curl http://localhost:3001/health
```
<img width="1900" height="210" alt="image" src="https://github.com/user-attachments/assets/e89b2cc0-a55a-4211-ac1a-2bf7a701eae8" />

### Step 2
### 2.1 Create the Product Service Dockerfile 
```
cd ../..
cd product-service
nano Dockerfile
```
-
```
FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .
EXPOSE 3002
CMD ["node", "server.js"]
```

### 2.2 Build the Product Service Docker image
```
docker build -t ecommerce-product-service:1.0 .
```
### 2.3 Run the Product Service container & Verify the container is running
```
docker run -d --name ecommerce-product-container -p 3002:3002 --env-file .env ecommerce-product-service:1.0
docker ps --filter "name=ecommerce-product-container"
curl http://localhost:3002/health
```
<img width="1896" height="207" alt="image" src="https://github.com/user-attachments/assets/f78ab3ae-832f-480f-b6dc-014d346fe112" />

### Step 3
### 3.1 Create the Cart Service Dockerfile 
```
cd ../cart-service
nano Dockerfile
```
-
```
FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .
EXPOSE 3003
CMD ["node", "server.js"]
```

### 3.2 Build the Cart Service Docker image
```
docker build -t ecommerce-cart-service:1.0 .
```
<img width="1737" height="748" alt="image" src="https://github.com/user-attachments/assets/406a72d6-63e6-41a3-9e2f-585cf1a22dc9" />

### 3.3 Run the Cart Service container & Verify the container is running
```
docker run -d --name ecommerce-cart-container -p 3003:3003 --env-file .env ecommerce-cart-service:1.0
docker ps --filter "name=ecommerce-cart-container"
curl http://localhost:3003/health
```
<img width="1741" height="387" alt="image" src="https://github.com/user-attachments/assets/3fb9f3e9-2cab-4e4f-b206-8106b2e86666" />

### Step 4
### 4.1 Create the Order Service Dockerfile 
```
cd ../order-service
nano Dockerfile
```
-
```
FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .
EXPOSE 3004
CMD ["node", "server.js"]
```

### 4.2 Build the Order Service Docker image
```
docker build -t ecommerce-order-service:1.0 .
```
<img width="1737" height="641" alt="image" src="https://github.com/user-attachments/assets/5a543912-1265-442c-a40f-7cb369d7621f" />

### 4.3 Run the Order Service container & Verify the container is running
```
docker run -d --name ecommerce-order-container -p 3004:3004 --env-file .env ecommerce-order-service:1.0
docker ps --filter "name=ecommerce-order-container"
curl http://localhost:3004/health
```
<img width="1765" height="396" alt="image" src="https://github.com/user-attachments/assets/956ff4f6-d949-4f9f-81b0-2a84a1e55745" />

### Step 5
### Create the Nginx configuration file
```
cd ../../frontend
nano nginx.conf
```
-
```
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;
    location /api/auth/ {
        proxy_pass http://ecommerce-user-container:3001/api/auth/;
    }
    location /api/users/ {
        proxy_pass http://ecommerce-user-container:3001/api/users/;
    }
    location = /api/products {
        proxy_pass http://ecommerce-product-container:3002;
    }
    location /api/products/ {
        proxy_pass http://ecommerce-product-container:3002;
    }
    location = /api/categories {
        proxy_pass http://ecommerce-product-container:3002;
    }
    location /api/categories/ {
        proxy_pass http://ecommerce-product-container:3002;
    }
    location /api/cart/ {
        proxy_pass http://ecommerce-cart-container:3003/api/cart/;
    }
    location /api/orders/ {
        proxy_pass http://ecommerce-order-container:3004/api/orders/;
    }
    location /api/payments/ {
        proxy_pass http://ecommerce-order-container:3004/api/payments/;
    }
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### 5.1 Create the Frontend Dockerfile
```
cd ../../frontend
nano Dockerfile
```
-
```
FROM node:24-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 5.2 Build the Frontend Service Docker image
```
docker build -t ecommerce-frontend:1.1 .
```

### 5.3 Run the Frontend Service container & Verify the container is running
```
docker run -d --name ecommerce-frontend-container -p 8080:80 ecommerce-frontend:1.1
docker ps --filter "name=ecommerce-frontend-container"
curl -I http://localhost:8080
```
<img width="1653" height="466" alt="image" src="https://github.com/user-attachments/assets/ab5e274c-eb94-4aa4-a192-54a712464b80" />

### Step 6 Create a shared Docker network

```
docker network create ecommerce-network
docker network inspect ecommerce-network
```
<img width="1522" height="863" alt="image" src="https://github.com/user-attachments/assets/02759399-018a-4e4f-8b90-7ffd0fbb26dd" />
<img width="1527" height="232" alt="image" src="https://github.com/user-attachments/assets/c89f6539-8350-4f45-a4e1-40826d1a8dbe" />

### 6.1 Connect all Service to the shared network
```
docker network connect ecommerce-network ecommerce-user-container
docker network connect ecommerce-network ecommerce-product-container
docker network connect ecommerce-network ecommerce-cart-container
docker network connect ecommerce-network ecommerce-order-container
docker network connect ecommerce-network ecommerce-frontend-container
docker network inspect ecommerce-network
```
<img width="1896" height="921" alt="image" src="https://github.com/user-attachments/assets/8da2df8e-85da-48ca-bbfa-f29b190f648b" />
<img width="1896" height="897" alt="image" src="https://github.com/user-attachments/assets/6a462908-12d6-40be-ae9b-1a0e05f10d30" />


### Step 7 Verify all five containers are running
```
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
```
<img width="1892" height="198" alt="image" src="https://github.com/user-attachments/assets/028d7a56-bbcf-4c98-9cee-51ef21a1ad4d" />

### Step 8 Test the backend services together
```
curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health
curl http://localhost:3004/health
```
<img width="1627" height="283" alt="image" src="https://github.com/user-attachments/assets/f41d7b65-3cc7-413c-9880-b31732006d9b" />

<img width="1917" height="967" alt="image" src="https://github.com/user-attachments/assets/6fe36fe9-55dc-46b8-a3ae-7229e034d6e2" />
<img width="1910" height="956" alt="image" src="https://github.com/user-attachments/assets/c29049a3-fede-4d75-9adc-a6a581817ad5" />
<img width="1910" height="962" alt="image" src="https://github.com/user-attachments/assets/fef5c70e-127f-4d1b-9ee8-b6efd937a9d0" />
<img width="1917" height="966" alt="image" src="https://github.com/user-attachments/assets/acbaa552-c79d-4950-b596-1f4096e94e40" />
<img width="1917" height="422" alt="image" src="https://github.com/user-attachments/assets/b368526e-1301-421a-8793-b236ed85bef4" />
<img width="1917" height="567" alt="image" src="https://github.com/user-attachments/assets/7d916624-8bcf-41ef-a19b-d2198ffd5068" />
<img width="1917" height="371" alt="image" src="https://github.com/user-attachments/assets/828af68a-7b0b-4ccb-a881-26df8a468070" />


### Step 9 Tag Service image & Pushing Images to Docker Hub

### 9.1 User Service image
```
docker tag ecommerce-user-service:1.0 learndevopsabhash/ecommerce-user-service:1.0
Veryfi:
docker images learndevopsabhash/ecommerce-user-service
Push :
docker push learndevopsabhash/ecommerce-user-service:1.0
```
<img width="1530" height="117" alt="image" src="https://github.com/user-attachments/assets/dda3e723-0b2b-4f5e-a273-40a85f056d23" />
<img width="920" height="331" alt="image" src="https://github.com/user-attachments/assets/e1ff99b7-f951-4917-abec-c09d16a93c2d" />


### 9.2 Product Service image
```
docker tag ecommerce-product-service:1.0 learndevopsabhash/ecommerce-product-service:1.0
Veryfi:
docker images learndevopsabhash/ecommerce-product-service
Push :
docker push learndevopsabhash/ecommerce-product-service:1.0
```
<img width="1537" height="183" alt="image" src="https://github.com/user-attachments/assets/40805047-d327-49ad-9489-28ad86fb6bc2" />
<img width="926" height="322" alt="image" src="https://github.com/user-attachments/assets/075d19e6-2a64-4c8c-9b0a-5b6795a10a94" />

### 9.3 Cart Service image
```
docker tag ecommerce-cart-service:1.0 learndevopsabhash/ecommerce-cart-service:1.0
Veryfi:
docker images learndevopsabhash/ecommerce-cart-service
Push :
docker push learndevopsabhash/ecommerce-cart-service:1.0
```

<img width="1532" height="522" alt="image" src="https://github.com/user-attachments/assets/fc688f7f-9dfd-4538-ad95-f62c80494691" />


### 9.4 Order Service image
```
docker tag ecommerce-order-service:1.0 learndevopsabhash/ecommerce-order-service:1.0
Veryfi:
docker images learndevopsabhash/ecommerce-order-service
Push :
docker push learndevopsabhash/ecommerce-order-service:1.0
```
<img width="1533" height="503" alt="image" src="https://github.com/user-attachments/assets/036d7a93-e6fc-4ed8-9d93-8c5fa210039f" />


### 9.5 Frontend Service image
```
docker tag ecommerce-frontend:1.1 learndevopsabhash/ecommerce-frontend:1.1
Veryfi:
docker images learndevopsabhash/ecommerce-frontend
Push :
docker push learndevopsabhash/ecommerce-frontend:1.1
```

<img width="1527" height="552" alt="image" src="https://github.com/user-attachments/assets/eb61ac3b-74ac-4bc7-b3f6-357076bae1c8" />

## Phase 3 — Terraform infrastructure

### Check Terraform and AWS user
```
terraform -version
```
<img width="927" height="156" alt="image" src="https://github.com/user-attachments/assets/090b8c4f-4f55-46b2-a06e-ff39f70d5d8f" />


```
$ aws sts get-caller-identity --profile ecommerce-terraform
{
    "UserId": "AIDAQ2SRTUHBA653QN6J5",
    "Account": "057079472578",
    "Arn": "arn:aws:iam::057079472578:user/ecommerce-terraform"
}
```
- I already setup a terraform user will all the required permission
  

### Step 1 — Create the Terraform directory from your e-commerce project root folder
```
mkdir -p terraform
ls -ld terraform
```
<img width="1530" height="150" alt="image" src="https://github.com/user-attachments/assets/8956a09c-f958-4538-8353-1ad4e48831d9" />

### Step 2 Create provider.tf
```
nano terraform/provider.tf
```
[provider.tf](terraform/provider.tf)


### Step 3 Create variables.tf
```
nano terraform/variables.tf
```
[variables.tf](terraform/variables.tf)


### Step 4 Create main.tf
```
nano terraform/main.tf
```
[main.tf](terraform/main.tf)

### Step 5 Create iam.tf
```
nano terraform/iam.tf
```
[iam.tf](terraform/iam.tf)

### Step 6 Create outputs.tf
```
nano terraform/outputs.tf
```
[outputs.tf](terraform/outputs.tf)


### Step 7 Create user_data.sh for Install Docker and run Docker images
```
nano terraform/user_data.sh
```
[user_data.sh](terraform/user_data.sh)


### Check Format and validate the Terraform files
```
terraform fmt
terraform validate
```
<img width="1895" height="202" alt="image" src="https://github.com/user-attachments/assets/edb8ae72-615f-4700-8fcb-8d9d0679338b" />


### Review the Terraform deployment plan
```
terraform plan -out=tfplan
```

<img width="1892" height="295" alt="image" src="https://github.com/user-attachments/assets/9117600c-4c74-4c55-b73d-6dd0ff711ee6" />


### Terraform deployment apply

```
terraform apply tfplan
```
<img width="1896" height="730" alt="image" src="https://github.com/user-attachments/assets/0759d328-e905-46b0-8560-5130edb96a98" />



### Veryfi Terraform deployment by open IP/DNS in browser

<img width="1915" height="962" alt="image" src="https://github.com/user-attachments/assets/c8161cf1-3b4a-4b12-b8b8-785603fa1163" />
<img width="1915" height="966" alt="image" src="https://github.com/user-attachments/assets/38e9501a-e0d2-4444-827a-214f195681b8" />
<img width="1917" height="940" alt="image" src="https://github.com/user-attachments/assets/686b0b35-bdeb-4533-bfcb-dd1fc482beee" />
<img width="1917" height="967" alt="image" src="https://github.com/user-attachments/assets/c5bdf956-7279-4cd1-80ac-5c2276d2b788" />
<img width="1915" height="966" alt="image" src="https://github.com/user-attachments/assets/209cda7e-6010-4f22-8127-d2a5ec4a41e5" />
<img width="1916" height="807" alt="image" src="https://github.com/user-attachments/assets/151c5a59-ad94-4440-a71e-7c420fe6a25e" />
<img width="1913" height="973" alt="image" src="https://github.com/user-attachments/assets/dc6b8075-6d07-42df-9071-c1cedf062379" />

### Check Data Base

<img width="1916" height="968" alt="image" src="https://github.com/user-attachments/assets/cfc068cb-f8db-47b9-885d-c215ffea7c22" />


