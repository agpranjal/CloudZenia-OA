# CloudZenia-OA Infrastructure as Code

This Terraform project provisions a comprehensive AWS infrastructure for hosting WordPress and a Node.js microservice, along with supporting EC2 instances running Nginx and Docker containers.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Modules](#modules)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Module Dependencies](#module-dependencies)
- [Outputs](#outputs)

## 🎯 Overview

This infrastructure project creates a production-ready AWS environment with:

- **VPC** with public and private subnets across multiple availability zones
- **Application Load Balancer (ALB)** with SSL/TLS termination (using certificates issued by ACM)
- **RDS MySQL database** for WordPress
- **ECS Fargate** services for WordPress and Node.js microservice
- **EC2 instances** running Nginx and Docker containers
- **Route53** DNS records for domain management
- **ACM** SSL certificates (issued to ALB) with automatic validation
- **CloudWatch** logging (nginx logs) and monitoring (EC2 Ram Utilization)
- **Secrets Manager** for secure credential storage (RDS credentials)
- **IAM** roles and policies for service access

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Route53 DNS                           │
│  *.agpranjal.site → ALB                                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│              Application Load Balancer (ALB)                 │
│  - HTTPS Listener (Port 443)                                │
│  - HTTP → HTTPS Redirect (Port 80)                          │
│  - Host-based routing rules                                 │
└──────┬──────────────┬──────────────┬──────────────┬─────────┘
       │              │              │              │
       │              │              │              │
┌──────▼──────┐ ┌─────▼──────┐ ┌───▼──────┐ ┌───▼──────┐
│ WordPress   │ │Microservice│ │  Nginx    │ │  Docker  │
│ (ECS Fargate│ │(ECS Fargate│ │  (EC2)    │ │  (EC2)   │
│  Port 80)   │ │ Port 3000) │ │ Port 80  │ │ Port 8080│
└──────┬──────┘ └────────────┘ └───────────┘ └──────────┘
       │
       │
┌──────▼──────────────────────────────────────────────────────┐
│              RDS MySQL Database (Private Subnet)            │
│  - Multi-AZ deployment                                      │
│  - Encrypted storage                                        │
│  - Automated backups                                        │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
terraform/
├── bootstrap/              # Bootstrap resources (S3, DynamoDB for state)
│   ├── main.tf
│   └── outputs.tf
├── modules/                # Reusable Terraform modules
│   ├── acm/               # SSL Certificate Management
│   ├── alb/               # Application Load Balancer
│   ├── ec2/               # EC2 Instances
│   ├── ecr/               # ECR Repository
│   ├── ecs/               # ECS Cluster and Services
│   ├── iam/               # IAM Roles and Policies
│   ├── rds/               # RDS Database
│   ├── secrets_manager/   # Secrets Management
│   ├── security_groups/   # Security Groups
│   └── vpc/               # VPC and Networking
├── main.tf                # Root module - orchestrates all modules
├── variables.tf           # Root variables
├── outputs.tf            # Root outputs
├── provider.tf           # Provider configuration
└── README.md             # This file
```


## 🌐 Domain Endpoints

The root domain for this project is: **agpranjal.site**

Below are the subdomain endpoints and their respective services:

| Subdomain                        | Description                                      | Service / Target                                                                       |
| -------------------------------- | ------------------------------------------------ | -------------------------------------------------------------------------------------- |
| **wordpress.agpranjal.site**     | WordPress web application                        | WordPress (ECS Fargate)                                                                |
| **microservice.agpranjal.site**  | Custom Node.js microservice                      | Node.js Microservice (ECS Fargate)                                                     |
| **ec2-alb-instance.agpranjal.site** | Load-balanced Nginx on EC2, returns "Hello from Instance" | Nginx (EC2, load-balanced via ALB)                                                     |
| **ec2-alb-docker.agpranjal.site**  | Load-balanced Docker container on EC2, returns "Namaste from Container" | Docker container (EC2, port 8080, load-balanced via ALB)                               |
| **ec2-instance1.agpranjal.site** | Points to elastic IP attached to first EC2 instance, Nginx: "Hello from Instance" | Nginx (EC2 Instance 1)                                                                 |
| **ec2-instance2.agpranjal.site** | Points to elastic IP attached to second EC2 instance, Nginx: "Hello from Instance" | Nginx (EC2 Instance 2)                                                                 |
| **ec2-docker1.agpranjal.site**   | Points to first EC2 instance, Docker: "Namaste from Container" | Docker container (EC2 Instance 1, port 8080)                                           |
| **ec2-docker2.agpranjal.site**   | Points to second EC2 instance, Docker: "Namaste from Container" | Docker container (EC2 Instance 2, port 8080)                                           |

All services are configured with SSL, and host-based routing is managed using the Application Load Balancer (ALB), except for direct EC2 subdomains which may use individual public DNS records via Route53.

---


## 🧩 Modules

### 1. VPC Module (`modules/vpc/`)
Creates VPC with public and private subnets across multiple availability zones, internet gateway, NAT gateway, and route tables.

### 2. Security Groups Module (`modules/security_groups/`)
Creates security groups for ALB, ECS, EC2, and RDS with appropriate ingress/egress rules.

### 3. IAM Module (`modules/iam/`)
Creates IAM roles and policies for ECS task execution, ECS tasks, and EC2 instances (CloudWatch Agent).

### 4. Secrets Manager Module (`modules/secrets_manager/`)
Manages RDS database credentials securely in AWS Secrets Manager.

### 5. RDS Module (`modules/rds/`)
Creates MySQL RDS instance in private subnets with encrypted storage and automated backups.

### 6. ACM Module (`modules/acm/`)
Manages SSL/TLS certificates with automatic DNS validation via Route53.

### 7. EC2 Module (`modules/ec2/`)
Creates two EC2 instances in public subnets with Elastic IPs, CloudWatch logging, and Route53 DNS records.

### 8. ALB Module (`modules/alb/`)
Creates Application Load Balancer with HTTPS listeners, target groups, host-based routing rules, and Route53 DNS records.

### 9. ECR Module (`modules/ecr/`)
Creates ECR repository for Node.js microservice with image scanning and lifecycle policies.

### 10. ECS Module (`modules/ecs/`)
Creates ECS Fargate cluster with WordPress and Node.js microservice services, including auto-scaling policies and CloudWatch logging.

---

## 🔧 Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** >= 1.0 installed
3. **AWS CLI** configured with credentials
4. **Route53 Hosted Zone** already created
5. **SSH Key Pair** (public key at `~/.ssh/id_rsa.pub`)
6. **Bootstrap Resources** (S3 bucket and DynamoDB table for state)

### Bootstrap Setup

Before deploying the main infrastructure, you need to create the S3 bucket and DynamoDB table for Terraform state:

```bash
cd bootstrap/
terraform init
terraform plan
terraform apply
```

This creates:
- S3 bucket: `cloudzenia-oa-tf-state` (with versioning and encryption)
- DynamoDB table: `cloudzenia-oa-tf-state-lock` (for state locking)

---

## 🚀 Usage

### 1. Configure Variables

Edit `variables.tf` or create a `terraform.tfvars` file:

```hcl
domain_name      = "agpranjal.site"
route53_zone_id  = "Z07540001AX4AZZUPCDUQ"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply the Infrastructure

```bash
terraform apply
```

### 5. Destroy the Infrastructure

```bash
terraform destroy
```

---

## 🔗 Module Dependencies

The modules have the following dependency chain:

```
vpc
  └── security_groups (depends on: vpc)
  └── ec2 (depends on: vpc, security_groups, iam)
  └── alb (depends on: vpc, security_groups, acm)
  └── rds (depends on: vpc, security_groups, secrets_manager)
  └── ecs (depends on: vpc, security_groups, iam, secrets_manager, rds, alb, ecr)

iam (independent)
secrets_manager (independent)
acm (independent, but uses route53_zone_id)
ecr (independent)
```

**Execution Order:**
1. VPC, IAM, Secrets Manager, ACM, ECR (can run in parallel)
2. Security Groups (depends on VPC)
3. EC2, ALB, RDS (depend on VPC and Security Groups)
4. ECS (depends on all previous modules)

---

## 🔐 Security Considerations

1. **Database Security:**
   - RDS deployed in private subnets
   - Credentials stored in Secrets Manager
   - Security group restricts access to ECS and EC2 only

2. **Network Security:**
   - Private subnets for sensitive resources (RDS, ECS)
   - Public subnets only for ALB and EC2 instances
   - Security groups follow least-privilege principle

3. **Access Control:**
   - IAM roles with minimal required permissions
   - Secrets Manager for credential management
   - Encrypted storage for RDS

4. **SSL/TLS:**
   - ACM certificates with automatic validation
   - HTTPS enforced (HTTP redirects to HTTPS)
   - Modern SSL policies

---

## 📝 Notes

- **State Management:** Terraform state is stored in S3 with DynamoDB locking
- **Region:** All resources are deployed in `us-east-1` (configurable)
- **Multi-AZ:** Resources are distributed across multiple availability zones for high availability
- **CloudWatch monitoring**: Nginx access log collection and RAM utilization metrics for EC2 instances are automated using the [`modules/ec2/cloudwatch-agent-config.sh`](modules/ec2/cloudwatch-agent-config.sh) script.

- **Manual setup on EC2**: The Nginx server configuration, Docker container setup and SSL/HTTPS enablement (via Certbot) were performed manually by SSH-ing into each EC2 instance after deployment. This ensures proper LetsEncrypt certificate issuance and correct Nginx TLS handling, as these steps require interactive processes and DNS propagation.



### ⚡ Challenge-2: EC2 Accessibility

#### EC2 Accessibility

- EC2 instances are deployed in public subnets, each with an Elastic IP attached, and are also placed behind an Application Load Balancer (ALB).
- This configuration allows EC2 instances and their services to be accessed either through the ALB endpoints (`ec2-alb-instance.agpranjal.site` / `ec2-alb-docker.agpranjal.site`), or directly via their assigned Elastic IP domains (`ec2-instance1.agpranjal.site`, `ec2-docker1.agpranjal.site`, `ec2-instance2.agpranjal.site`, `ec2-docker2.agpranjal.site`).
- **Note:** The assignment's Challenge-2 specified deploying EC2 instances in a private subnet and attaching an Elastic IP (EIP). However, attaching an EIP to an EC2 instance in a private subnet does not provide public internet access. For practical functionality, the EC2 instances have been deployed in a public subnet, which allows Elastic IP association and direct accessibility as required.


