# 🎮 Movie Database Application Deployment

This repository contains the code and configurations for deploying a **three-tier Movie Database application**, consisting of:

- **Frontend**: React, served by Nginx  
- **Backend API**: Flask (Python)  
- **Database**: PostgreSQL hosted on AWS RDS  

Infrastructure is provisioned using **Terraform**, and deployment is automated with **GitHub Actions** and **Ansible**, using a **bastion host** to securely SSH into a **private EC2 application server**.

---

## 🏗️ Architecture Overview

```
You (local / GitHub Actions)
        |
        v
Bastion Host (Public EC2)
        |
        v
Private EC2 App Server
        |
        v
AWS RDS PostgreSQL
```

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
```

---

## ✅ Prerequisites

- Docker installed
- AWS CLI configured (for Terraform)
- The following GitHub Actions **Secrets** must be configured:

```env
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
```

---

## 🚀 Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/flomihciu/devops-assessment-3.git
cd devops-assessment-3
```

### 2. Provision Infrastructure (via GitHub Actions)

Push to the `main` branch to trigger the **"Provision Infrastructure"** workflow using Terraform.

---

### 3. Configure Bastion Access

Use SSH through the bastion to reach your private EC2 app server:

```bash
ssh -i flo-east-1.pem -J ubuntu@<BASTION_PUBLIC_IP> ubuntu@<EC2_PRIVATE_IP>
```

Or for frontend access:

```bash
ssh -i flo-east-1.pem -N -L 8080:<EC2_PRIVATE_IP>:80 ubuntu@<BASTION_PUBLIC_IP>
```

Then open your app at:

```
http://127.0.0.1:8080
```

---

### 4. Deploy the App (via GitHub Actions)

After provisioning completes, the **"Deploy App"** workflow will:

- Build and push Docker images for frontend/backend
- Copy SSH keys to the bastion host
- SSH into the private EC2 instance via bastion
- Run Ansible to deploy containers with Docker Compose

---

## 🛉️ Cleanup

To destroy all infrastructure:

```bash
cd terraform
terraform destroy
```

---