# Highly-Available-Web-App-on-AWS-with-Terraform


<div align="center">

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Node.js](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)

**Production-ready, highly available web application with Auto Scaling, Load Balancing, and Multi-AZ RDS**

[Features](#-features) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Deployment](#-deployment) • [Testing](#-testing-high-availability)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Project Setup](#-project-setup)
- [Configuration](#-configuration)
- [Deployment Guide](#-deployment-guide)
- [Testing High Availability](#-testing-high-availability)
- [Monitoring & Troubleshooting](#-monitoring--troubleshooting)
- [Cost Estimation](#-cost-estimation)
- [Cleanup](#-cleanup)
- [Advanced Features](#-advanced-features)
- [Troubleshooting Guide](#-troubleshooting-guide)
- [Best Practices](#-best-practices)
- [Contributing](#-contributing)

---

## 🎯 Overview

This project demonstrates how to build a **production-grade, highly available web application** on AWS using infrastructure as code (Terraform). It's perfect for learning AWS fundamentals while building something real and production-relevant.

### What You'll Learn

- ✅ AWS core services (EC2, RDS, VPC, ALB, S3, CloudWatch)
- ✅ High availability and fault tolerance patterns
- ✅ Auto Scaling and load balancing
- ✅ Infrastructure as Code with Terraform
- ✅ Security best practices (VPC, Security Groups, IAM)
- ✅ Monitoring and alerting with CloudWatch
- ✅ Database management with RDS PostgreSQL

---

## ⭐ Features

### Infrastructure Features
- **Multi-AZ Deployment** - Resources distributed across 2 Availability Zones for fault tolerance
- **Application Load Balancer** - Intelligent traffic distribution with health checks
- **Auto Scaling** - Automatically scales from 2 to 6 instances based on CPU utilization (70% target)
- **Multi-AZ RDS PostgreSQL** - Highly available database with automatic failover
- **Private Networking** - EC2 instances in private subnets with NAT Gateway for secure internet access
- **CloudWatch Monitoring** - Custom metrics, alarms, and logs
- **S3 Backups** - Versioned backup storage with encryption
- **IAM Roles** - Least privilege access with instance profiles

### Application Features
- **Real-time Metrics Dashboard** - Beautiful UI showing live statistics
- **Load Distribution Display** - See which instances handle requests
- **Visit Tracking** - Persistent data across all instances
- **Health Check Endpoint** - For ALB health monitoring
- **REST API** - JSON endpoint for programmatic access
- **Graceful Shutdown** - Proper connection handling

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Internet                             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │ Application Load     │
              │ Balancer (ALB)       │
              │ Port 80              │
              └──────────┬───────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│   EC2       │  │   EC2       │  │   EC2       │
│ Instance 1  │  │ Instance 2  │  │ Instance N  │
│ (Private)   │  │ (Private)   │  │ (Private)   │
│ Node.js App │  │ Node.js App │  │ Node.js App │
└──────┬──────┘  └──────┬──────┘  └──────┬──────┘
       │                │                │
       └────────────────┼────────────────┘
                        │
                        ▼
              ┌──────────────────────┐
              │   RDS PostgreSQL     │
              │   (Multi-AZ)         │
              │   Primary + Standby  │
              └──────────────────────┘
```

### Network Architecture

```
VPC (10.0.0.0/16)
│
├─ Public Subnets (10.0.1.0/24, 10.0.2.0/24)
│  ├─ Application Load Balancer
│  └─ NAT Gateways
│
├─ Private Subnets (10.0.10.0/24, 10.0.11.0/24)
│  └─ EC2 Instances (Auto Scaling Group)
│
└─ Database Subnets (10.0.20.0/24, 10.0.21.0/24)
   └─ RDS PostgreSQL (Multi-AZ)
```

---

## 📦 Prerequisites

Before you begin, ensure you have the following installed and configured:

### Required Software

1. **AWS Account**
   - Active AWS account with appropriate permissions
   - Credit card on file (for resources outside free tier)

2. **AWS CLI** (v2.x or higher)
   ```bash
   # Install AWS CLI
   # macOS
   brew install awscli
   
   # Linux
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   
   # Windows
   # Download and run: https://awscli.amazonaws.com/AWSCLIV2.msi
   
   # Verify installation
   aws --version
   ```

3. **Terraform** (v1.0 or higher)
   ```bash
   # macOS
   brew tap hashicorp/tap
   brew install hashicorp/tap/terraform
   
   # Linux
   wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
   unzip terraform_1.6.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   
   # Windows
   # Download from: https://www.terraform.io/downloads
   
   # Verify installation
   terraform --version
   ```

4. **Node.js** (v18 or higher) - *Optional, for local testing*
   ```bash
   # macOS
   brew install node
   
   # Linux
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   
   # Windows
   # Download from: https://nodejs.org/
   
   # Verify installation
   node --version
   npm --version
   ```

5. **Git**
   ```bash
   # macOS
   brew install git
   
   # Linux
   sudo apt-get install git
   
   # Windows
   # Download from: https://git-scm.com/download/win
   
   # Verify installation
   git --version
   ```

### AWS Permissions Required

Your AWS IAM user/role needs the following permissions:
- EC2 (full access)
- VPC (full access)
- RDS (full access)
- Elastic Load Balancing (full access)
- Auto Scaling (full access)
- CloudWatch (full access)
- S3 (full access)
- IAM (limited - for creating roles and instance profiles)

**Tip**: For learning, you can use `AdministratorAccess` policy, but **never use this in production**!

---

## 🚀 Project Setup

### Step 1: Clone the Repository

```bash
# Clone this repository
git clone https://github.com/yourusername/ha-webapp-aws.git
cd ha-webapp-aws
```

**OR** Create the project from scratch:

```bash
# Create project directory
mkdir ha-webapp-aws
cd ha-webapp-aws

# Initialize git
git init
```

### Step 2: Create Project Structure

Create all necessary files with the following structure:

```
ha-webapp-aws/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── user-data.sh
├── app/
│   ├── server.js
│   ├── package.json
│   └── .env.example
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── .gitignore
└── README.md
```

**Copy all files from the artifacts provided** into their respective directories.

### Step 3: Configure AWS CLI

```bash
# Configure AWS credentials
aws configure

# You'll be prompted for:
# AWS Access Key ID: [Your Access Key]
# AWS Secret Access Key: [Your Secret Key]
# Default region name: us-east-1
# Default output format: json

# Verify configuration
aws sts get-caller-identity
```

You should see output with your AWS account information.

---

## ⚙️ Configuration

### Step 1: Copy Configuration Template

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

### Step 2: Edit Configuration

Open `terraform.tfvars` in your editor:

```bash
nano terraform.tfvars
# or
code terraform.tfvars
```

### Step 3: Customize Your Settings

```hcl
# AWS Configuration
aws_region   = "us-east-1"        # Change to your preferred region
project_name = "ha-webapp"        # Change to your project name

# EC2 Configuration
instance_type = "t3.micro"        # Free tier eligible

# Auto Scaling Configuration
asg_min_size         = 2          # Minimum instances (2 for HA)
asg_max_size         = 6          # Maximum instances
asg_desired_capacity = 2          # Starting instances

# RDS Configuration
db_instance_class = "db.t3.micro" # Free tier eligible
db_name           = "webapp_db"
db_username       = "dbadmin"
db_password       = "YOUR_SECURE_PASSWORD_HERE"  # ⚠️ CHANGE THIS!
```

### 🔒 Security: Database Password

**CRITICAL**: Change the default database password!

✅ **Good Password Examples**:
- `MyS3cur3P@ssw0rd!2024`
- `Tr0ng#Database$Pass123`
- `Aws-Rds-P@ssw0rd-9876`

❌ **Bad Password Examples**:
- `password123`
- `admin`
- `12345678`

**Password Requirements**:
- Minimum 8 characters
- Mix of uppercase, lowercase, numbers
- Special characters (!@#$%^&*)

### Step 4: Review Region Selection

**Popular AWS Regions**:
- `us-east-1` - US East (N. Virginia) - Usually cheapest
- `us-west-2` - US West (Oregon)
- `eu-west-1` - Europe (Ireland)
- `ap-southeast-1` - Asia Pacific (Singapore)

**Tip**: Choose a region close to your target users for lower latency.

---

## 🎯 Deployment Guide

### Step 1: Initialize Terraform

```bash
cd terraform

# Initialize Terraform (downloads providers)
terraform init
```

**Expected Output**:
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.x.x...

Terraform has been successfully initialized!
```

### Step 2: Validate Configuration

```bash
# Check for syntax errors
terraform validate
```

**Expected Output**:
```
Success! The configuration is valid.
```

### Step 3: Review Infrastructure Plan

```bash
# See what will be created
terraform plan
```

This shows you:
- ✅ Resources to be created (should be ~40 resources)
- ✅ Estimated costs
- ✅ Any potential issues

**Review carefully** before proceeding!

### Step 4: Deploy Infrastructure

```bash
# Deploy everything
terraform apply
```

You'll see a plan summary. Type `yes` to proceed.

**Deployment Timeline**:
- ⏱️ **Total Time**: 10-15 minutes
- 📊 **Progress Stages**:
  1. VPC and networking (2-3 min)
  2. RDS database (5-7 min) - Slowest part
  3. Load balancer and ASG (2-3 min)
  4. CloudWatch and S3 (1-2 min)

**Expected Output**:
```
Apply complete! Resources: 41 added, 0 changed, 0 destroyed.

Outputs:

alb_url = "http://ha-webapp-alb-123456789.us-east-1.elb.amazonaws.com"
asg_name = "ha-webapp-asg"
rds_endpoint = <sensitive>
s3_backup_bucket = "ha-webapp-backups-123456789012"
vpc_id = "vpc-0a1b2c3d4e5f6g7h8"
```

### Step 5: Access Your Application

```bash
# Get the application URL
terraform output alb_url
```

Copy the URL and open it in your browser:
```
http://ha-webapp-alb-123456789.us-east-1.elb.amazonaws.com
```

**First Load**: May take 1-2 minutes as instances start and become healthy.

### Step 6: Verify Deployment

Check that everything is working:

```bash
# Check Auto Scaling Group
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names ha-webapp-asg

# Check target health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)

# Check RDS status
aws rds describe-db-instances \
  --db-instance-identifier ha-webapp-db
```

---

## 🧪 Testing High Availability

### Test 1: Load Balancer Distribution

Verify traffic is distributed across multiple instances:

```bash
# Get your ALB URL
ALB_URL=$(terraform output -raw alb_url)

# Make multiple requests and see different instance IDs
for i in {1..20}; do
  curl -s $ALB_URL | grep -o "Instance ID: [^<]*"
  sleep 1
done
```

**Expected Result**: You should see requests handled by different instance IDs.

### Test 2: Database Persistence

1. Visit your application URL
2. Refresh the page multiple times
3. Note the "Total Visits" counter increasing
4. Even though different instances serve requests, the counter persists

**This proves**: All instances share the same database!

### Test 3: Instance Failure Recovery

Simulate an instance failure:

```bash
# Get running instances
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=ha-webapp-asg-instance" \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' \
  --output table

# Terminate one instance (Auto Scaling will replace it)
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0

# Watch Auto Scaling replace it
watch -n 5 'aws autoscaling describe-auto-scaling-instances'
```

**Expected Behavior**:
1. Instance terminates
2. Auto Scaling detects unhealthy instance
3. New instance launches automatically
4. Application continues serving traffic (no downtime!)

### Test 4: Auto Scaling Under Load

Generate CPU load to trigger scaling:

```bash
# SSH to an instance (requires Session Manager or bastion)
# Then run CPU stress:
stress-ng --cpu 4 --timeout 600s

# Watch scaling activity
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name ha-webapp-asg \
  --max-records 10
```

**Expected Behavior**:
- When CPU > 70%, new instances launch
- When CPU < 70%, excess instances terminate
- Scaling takes 3-5 minutes

### Test 5: Database Failover (Multi-AZ)

RDS automatically handles failover:

```bash
# Trigger failover (for testing)
aws rds reboot-db-instance \
  --db-instance-identifier ha-webapp-db \
  --force-failover

# Monitor failover
aws rds describe-db-instances \
  --db-instance-identifier ha-webapp-db \
  --query 'DBInstances[0].DBInstanceStatus'
```

**Expected Behavior**:
- Brief interruption (30-60 seconds)
- Application automatically reconnects
- No data loss

---

## 📊 Monitoring & Troubleshooting

### CloudWatch Dashboard

Access your CloudWatch dashboard:

```bash
# Get dashboard URL
terraform output cloudwatch_dashboard_url

# Or use AWS CLI
aws cloudwatch list-dashboards
```

### View Logs

```bash
# Stream application logs
aws logs tail /aws/ec2/webapp --follow

# View recent errors
aws logs filter-log-events \
  --log-group-name /aws/ec2/webapp \
  --filter-pattern "ERROR"
```

### Check Alarms

```bash
# List all alarms
aws cloudwatch describe-alarms

# Check specific alarm
aws cloudwatch describe-alarms \
  --alarm-names ha-webapp-high-cpu
```

### Common Issues & Solutions

#### Issue 1: Application Not Accessible

```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)

# If unhealthy, check instance logs
aws ssm start-session --target i-1234567890abcdef0
journalctl -u webapp -n 50
```

**Common Causes**:
- Health check endpoint failing
- Database connection issues
- Security group misconfiguration

#### Issue 2: Database Connection Failed

```bash
# Check RDS status
aws rds describe-db-instances \
  --db-instance-identifier ha-webapp-db

# Check security group rules
aws ec2 describe-security-groups \
  --group-ids $(terraform output -raw rds_security_group_id)

# Test connection from EC2
psql -h your-rds-endpoint -U dbadmin -d webapp_db
```

#### Issue 3: Instances Not Scaling

```bash
# Check Auto Scaling activities
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name ha-webapp-asg

# Check CloudWatch metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=AutoScalingGroupName,Value=ha-webapp-asg \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average
```

### Performance Metrics

Key metrics to monitor:

1. **ALB Metrics**:
   - Request count
   - Target response time
   - HTTP 4xx/5xx errors
   - Healthy host count

2. **EC2 Metrics**:
   - CPU utilization
   - Network in/out
   - Disk usage

3. **RDS Metrics**:
   - CPU utilization
   - Database connections
   - Read/Write latency
   - Free storage space

---

## 💰 Cost Estimation

### Free Tier (First 12 Months)

If you're on AWS Free Tier:

| Service | Free Tier | Monthly Cost |
|---------|-----------|--------------|
| EC2 (2x t3.micro) | 750 hours | $0 |
| RDS (db.t3.micro) | 750 hours | $0 |
| ALB | 750 hours | $0 |
| EBS (30 GB) | 30 GB | $0 |
| Data Transfer | 15 GB out | $0 |

**Estimated Cost**: ~$65/month (mainly NAT Gateway which isn't free tier)

### After Free Tier

| Service | Usage | Monthly Cost |
|---------|-------|--------------|
| EC2 (2x t3.micro) | 730 hours | ~$15 |
| RDS (db.t3.micro Multi-AZ) | 730 hours | ~$30 |
| ALB | 730 hours + data | ~$20 |
| NAT Gateway (2x) | 730 hours + data | ~$65 |
| EBS Storage | 40 GB | ~$4 |
| S3 | 10 GB | ~$0.25 |
| Data Transfer | Varies | ~$10 |

**Total Estimated Cost**: ~$144/month

### Cost Optimization Tips

1. **Reduce NAT Gateways**:
   ```hcl
   # In main.tf, use only 1 NAT Gateway instead of 2
   # Reduces cost by ~$32/month (but reduces HA)
   ```

2. **Use Single AZ RDS** (not recommended for production):
   ```hcl
   multi_az = false  # Reduces cost by ~$15/month
   ```

3. **Reduce Instance Count During Development**:
   ```hcl
   asg_min_size = 1
   asg_desired_capacity = 1
   ```

4. **Stop Resources When Not In Use**:
   ```bash
   # Destroy infrastructure when not testing
   terraform destroy
   ```

---

## 🧹 Cleanup

### Option 1: Destroy Everything

```bash
cd terraform

# Destroy all resources
terraform destroy
```

Type `yes` when prompted.

**Cleanup Time**: ~10 minutes

**What Gets Deleted**:
- ✅ All EC2 instances
- ✅ Load Balancer
- ✅ RDS database (no snapshot due to config)
- ✅ VPC and networking
- ✅ S3 bucket
- ✅ CloudWatch alarms
- ✅ IAM roles

### Option 2: Selective Cleanup

Keep infrastructure but stop instances:

```bash
# Set desired capacity to 0
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name ha-webapp-asg \
  --desired-capacity 0

# Stop RDS (if you want to keep data)
aws rds stop-db-instance \
  --db-instance-identifier ha-webapp-db
```

### Verify Cleanup

```bash
# Check no resources remain
aws ec2 describe-instances --filters "Name=tag:Name,Values=ha-webapp*"
aws rds describe-db-instances --db-instance-identifier ha-webapp-db
aws elbv2 describe-load-balancers --names ha-webapp-alb
```

---

## 🎓 Advanced Features

### Add HTTPS Support

1. **Request ACM Certificate**:
   ```bash
   aws acm request-certificate \
     --domain-name yourdomain.com \
     --validation-method DNS
   ```

2. **Update ALB Listener**:
   ```hcl
   resource "aws_lb_listener" "https" {
     load_balancer_arn = aws_lb.main.arn
     port              = "443"
     protocol          = "HTTPS"
     ssl_policy        = "ELBSecurityPolicy-2016-08"
     certificate_arn   = "arn:aws:acm:..."
     
     default_action {
       type             = "forward"
       target_group_arn = aws_lb_target_group.main.arn
     }
   }
   ```

### Add Custom Domain

1. **Create Route 53 Hosted Zone**
2. **Add A Record pointing to ALB**:
   ```bash
   aws route53 change-resource-record-sets \
     --hosted-zone-id Z1234567890ABC \
     --change-batch file://change-batch.json
   ```

### Add Redis Caching

1. **Create ElastiCache Cluster**:
   ```hcl
   resource "aws_elasticache_cluster" "redis" {
     cluster_id           = "ha-webapp-redis"
     engine               = "redis"
     node_type            = "cache.t3.micro"
     num_cache_nodes      = 1
     parameter_group_name = "default.redis7"
     port                 = 6379
     subnet_group_name    = aws_elasticache_subnet_group.main.name
   }
   ```

2. **Update Application** to use Redis for session storage

### Implement CI/CD

Use AWS CodePipeline for automated deployments:

```yaml
# buildspec.yml
version: 0.2
phases:
  install:
    commands:
      - npm install
  build:
    commands:
      - npm test
      - npm run build
  post_build:
    commands:
      - aws s3 cp server.js s3://deployment-bucket/
```

---

## 🛠️ Troubleshooting Guide

### Problem: Terraform Apply Fails

**Error**: `Error creating RDS instance: DBInstanceAlreadyExists`

**Solution**:
```bash
# Import existing resource
terraform import aws_db_instance.main ha-webapp-db

# Or destroy and recreate
aws rds delete-db-instance \
  --db-instance-identifier ha-webapp-db \
  --skip-final-snapshot
```

### Problem: Can't Access Application

**Error**: `502 Bad Gateway`

**Diagnosis**:
```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)

# Check application logs
aws logs tail /aws/ec2/webapp --follow
```

**Solutions**:
1. Wait for instances to become healthy (2-3 minutes)
2. Check security groups allow traffic
3. Verify health check endpoint is responding

### Problem: Database Connection Timeout

**Error**: `ETIMEDOUT` or `Connection refused`

**Diagnosis**:
```bash
# Test from EC2 instance
telnet your-rds-endpoint 5432

# Check security group
aws ec2 describe-security-groups \
  --group-ids sg-xxxxx
```

**Solutions**:
1. Verify RDS security group allows traffic from EC2 security group
2. Check RDS is in "available" state
3. Verify database credentials in user-data.sh

### Problem: High Costs

**Symptom**: AWS bill higher than expected

**Investigation**:
```bash
# Check running resources
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"
aws rds describe-db-instances
aws ec2 describe-nat-gateways

# Use AWS Cost Explorer
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

**Solutions**:
1. Destroy when not in use: `terraform destroy`
2. Reduce NAT Gateways from 2 to 1
3. Use smaller instance types during testing

---

## ✅ Best Practices

### Security

1. **Never Commit Secrets**:
   ```bash
   # Always in .gitignore
   terraform.tfvars
   .env
   *.pem
   ```

2. **Use AWS Secrets Manager** (Production):
   ```hcl
   data "aws_secretsmanager_secret_version" "db_password" {
     secret_id = "prod/db/password"
   }
   ```

3. **Enable CloudTrail**:
   ```bash
   aws cloudtrail create-trail \
     --name ha-webapp-trail \
     --s3-bucket-name cloudtrail-bucket
   ```

4. **Regular Security Updates**:
   ```bash
   # Update user-data.sh to include
   yum update -y --security
   ```

### Operations

1. **Tag Everything**:
   ```hcl
   tags = {
     Project     = "ha-webapp"
     Environment = "production"
     ManagedBy   = "terraform"
     CostCenter  = "engineering"
   }
   ```

2. **Enable Detailed Monitoring**:
   ```hcl
   monitoring = true  # In launch template
   ```

3. **Automated Backups**:
   ```bash
   # Create backup Lambda function
   aws lambda create-function \
     --function-name backup-rds \
     --runtime python3.9 \
     --handler lambda_function.lambda_handler \
     --role arn:aws:iam::123456789012:role/lambda-backup
   ```

4. **Set Up Alerts**:
   ```hcl
   resource "aws_sns_topic" "alerts" {
     name = "webapp-alerts"
   }
   
   resource "aws_sns_topic_subscription" "email" {
     topic_arn = aws_sns_topic.alerts.arn
     protocol  = "email"
     endpoint  = "your-email@example.com"
   }
   ```

---

## 📚 Additional Resources

### Official Documentation
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Node.js on AWS](https://aws.amazon.com/developer/language/javascript/)
- [RDS Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html)

### Tutorials
- [AWS Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)
- [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
- [VPC Design](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)

### Community
- [AWS Community Builders](https://aws.amazon.com/developer/community/community-builders/)
- [HashiCorp Discuss - Terraform](https://discuss.hashicorp.com/c/terraform-core/)
- [r/aws Subreddit](https://www.reddit.com/r/aws/)

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
