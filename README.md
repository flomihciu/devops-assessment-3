# Movie Database Application Deployment

This repository contains the code and configurations for deploying a **three-tier Movie Database application**, consisting of:

- **Frontend**: React, served by Nginx  
- **Backend API**: Flask (Python)  
- **Database**: PostgreSQL hosted on AWS RDS  

Infrastructure is provisioned using **Terraform**, and deployment is automated with **GitHub Actions** and **Ansible**, using a **bastion host** to securely SSH into a **private EC2 application server**.

---

## 🏗️ Architecture Overview

You (local / GitHub Actions) | v Bastion Host (Public EC2) | v Private EC2 App Server | v AWS RDS PostgreSQL

yaml
Copy
Edit

- **Bastion Host**: Exposes a public IP address to allow SSH access to the private EC2 instance  
- **Private EC2 App Server**: Hosts Docker containers for frontend and backend  
- **RDS Instance**: Stores movie data securely, accessible only from the private subnet  

---

## 📁 Project Structure

```text
.github/workflows/       # CI/CD pipelines for infrastructure and deployment
ansible/                 # Ansible playbooks and templates
flask-react/
├── flask/               # Flask backend application
└── nginx/reactApp/      # React frontend served by Nginx
terraform/               # Terraform scripts for AWS infrastructure
docker-compose.yml       # Docker Compose service definitions
✅ Prerequisites
Docker installed

AWS CLI configured (for Terraform)

The following GitHub Actions Secrets must be configured:

env
Copy
Edit
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
AWS_SSH_PRIVATE_KEY
BASTION_SSH_KEY_B64
BASTION_PUBLIC_IP
EC2_PRIVATE_IP
DB_USER
DB_PASSWORD
DB_NAME
RDS_ENDPOINT
DOCKER_USERNAME
DOCKER_PASSWORD
🚀 Deployment Steps
1. Clone the Repository
bash
Copy
Edit
git clone https://github.com/flomihciu/devops-assessment-3.git
cd devops-assessment-3
2. Provision Infrastructure (via GitHub Actions)
Push to the main branch to trigger the "Provision Infrastructure" workflow using Terraform.

3. Configure Bastion Access
Use SSH through the bastion to reach your private EC2 app server:

bash
Copy
Edit
ssh -i flo-east-1.pem -J ubuntu@<BASTION_PUBLIC_IP> ubuntu@<EC2_PRIVATE_IP>
Or for frontend access:

bash
Copy
Edit
ssh -i flo-east-1.pem -N -L 8080:<EC2_PRIVATE_IP>:80 ubuntu@<BASTION_PUBLIC_IP>
Then open your app at:

cpp
Copy
Edit
http://127.0.0.1:8080
4. Deploy the App (via GitHub Actions)
After provisioning completes, the "Deploy App" workflow will:

Build and push Docker images for frontend/backend

Copy SSH keys to the bastion host

SSH into the private EC2 instance via bastion

Run Ansible to deploy containers with Docker Compose

🎬 Database and Table Setup
Manually create the PostgreSQL database and movies table on your RDS instance by following these steps:

Step 1: Copy PEM Key to Bastion Host
bash
Copy
Edit
scp -i flo-east-1.pem flo-east-1.pem ubuntu@3.88.237.55:/home/ubuntu/
Step 2: SSH into Bastion Host
bash
Copy
Edit
ssh -i "flo-east-1.pem" ubuntu@3.88.237.55
Step 3: SSH into Private EC2 App Server
bash
Copy
Edit
ssh -i flo-east-1.pem ubuntu@10.0.3.53
Step 4: Access Backend Container
bash
Copy
Edit
sudo docker exec -it ubuntu-backend-1 /bin/bash
Step 5: Install PostgreSQL Client
bash
Copy
Edit
apt update && apt install -y postgresql-client
Step 6: Connect to RDS Instance
bash
Copy
Edit
psql -h flo-postgres-db.cvyw6igek2bp.us-east-1.rds.amazonaws.com -U flodev -d postgres
Password: DEVops123

Step 7: Create Database
sql
Copy
Edit
CREATE DATABASE "flo-db";
Step 8: Exit and Reconnect to New Database
bash
Copy
Edit
psql -h flo-postgres-db.cvyw6igek2bp.us-east-1.rds.amazonaws.com -U flodev -d flo-db
Password: DEVops123

Step 9: Create Movies Table
sql
Copy
Edit
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    director VARCHAR(255),
    year INT
);
Step 10: Forward Port for Local Access
bash
Copy
Edit
ssh -i /home/flomihciu/devops/flo-east-1.pem -N -L 8080:10.0.3.53 ubuntu@3.88.237.55
Then open your browser at:

cpp
Copy
Edit
http://127.0.0.1:8080
🛉️ Cleanup
To destroy all infrastructure:

bash
Copy
Edit
cd terraform
terraform destroy