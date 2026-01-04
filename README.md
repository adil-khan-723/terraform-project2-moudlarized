<div align="center">

# 🏗️ Modular AWS Infrastructure with Terraform

### Production-Grade ALB + EC2 + Security Groups Architecture

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

[Overview](#-overview) • [Architecture](#️-architecture) • [Features](#-key-features) • [Getting Started](#-getting-started) • [Modules](#-module-breakdown)

</div>

---

## 📋 Overview

This project demonstrates how to design, provision, and operate a **production-style AWS infrastructure** using Terraform with a strong focus on **modularity**, **safety**, and **scalability**.

The infrastructure is intentionally built in **two phases**:

1. 🔨 **Non-modular implementation** - Understanding raw Terraform behavior
2. 🎯 **Fully modularized version** - Reflecting real-world DevOps practices

The final result is a **reusable, extensible Terraform codebase** that provisions multiple EC2 instances behind an Application Load Balancer, with secure networking, remote state management, and safe concurrent access handling.

---

## 🎯 Problem Statement

Most beginner Terraform projects stop at **"it works"**.

This project was built to go further and answer harder questions:

- ❓ How do you manage Terraform at scale?
- ❓ How do teams avoid state corruption?
- ❓ How do you pass data safely between resources and modules?
- ❓ How do you design infrastructure so it can evolve without rewrites?

### 🎖️ Project Goals

The goal was not just to deploy resources, but to design infrastructure that is:

- ✅ **Modular** - Clean separation of concerns
- ✅ **Reusable** - DRY principles applied
- ✅ **Secure** - Production-grade security patterns
- ✅ **Team-safe** - State locking and remote backend
- ✅ **Production-aligned** - Real-world best practices

---

## 🏛️ Architecture

### AWS Components

| Component | Purpose |
|-----------|---------|
| 🌐 **Default VPC** | Network foundation |
| 🔀 **Multiple Public Subnets** | High availability across AZs |
| ⚖️ **Application Load Balancer** | Traffic distribution |
| 🎯 **Target Group** | Instance-based routing |
| 💻 **6 EC2 Instances** | Web server fleet |
| 🔒 **Security Groups** | Network access control |
| 🪣 **S3 Backend** | Terraform state storage |
| 🔐 **DynamoDB Table** | State locking mechanism |

### 🔄 Traffic Flow

```
🌍 Internet
    ↓
⚖️ Application Load Balancer (HTTP)
    ↓
🎯 Target Group
    ↓
💻 EC2 Instances (Nginx web servers)
```

> 🛡️ **Security Note**: Only the ALB is exposed to the internet. EC2 instances accept traffic **only** from the ALB security group, not from the internet.

---

## ⭐ Key Features

### 1️⃣ Modular Terraform Design

```
📦 Infrastructure split into independent modules:
├── 💻 EC2 Module
├── 🔒 Security Group Module
└── ⚖️ Load Balancer Module
```

Each module:
- ✨ Has a clear responsibility
- 📤 Exposes only required outputs
- 🚫 Avoids hidden dependencies

> 💡 This mirrors how Terraform is used in real teams.

---

### 2️⃣ `for_each` Instead of `count`

Resources are created using **`for_each`** with maps instead of `count`.

**Why?**
- ✅ Stable resource addressing
- ✅ Safer updates
- ✅ Easier association with other resources
- ✅ Deterministic naming and identity

---

### 3️⃣ Security Group Isolation

Instead of using open CIDR rules everywhere:

```
🌐 Internet → 🔓 ALB Security Group (0.0.0.0/0)
                    ↓
              🔒 EC2 Security Group (ALB SG only)
```

This dramatically reduces attack surface and reflects **real production security practices**.

---

### 4️⃣ Remote State with Locking

Terraform state is stored in:

- 🪣 **S3** - Remote backend
- 🔐 **DynamoDB** - State locking

**Prevents:**
- ⛔ Concurrent applies
- ⛔ State corruption
- ⛔ Team conflicts

> ⚠️ This setup is **mandatory** in real-world Terraform usage and is often missing in beginner projects.

---

### 5️⃣ Dynamic Target Group Registration

EC2 instance IDs are exported from the EC2 module as a **map**.

The ALB module dynamically:
- 🔄 Iterates over instance IDs
- 🔗 Attaches each instance to the target group

**No hardcoded instance references. No manual wiring.**

---

## 📁 Directory Structure

```
📂 terraform-aws-infrastructure/
├── 📄 main.tf                    # Root module orchestration
├── 📄 variables.tf               # Input variables
├── 📄 outputs.tf                 # Root outputs
├── 📄 backend.tf                 # S3 + DynamoDB backend config
├── 📄 data.tf                    # Data sources
├── 📄 locals.tf                  # Local values
├── 📄 user_data.tpl              # EC2 bootstrap script
│
└── 📂 modules/
    ├── 📂 instances/             # EC2 Module
    │   ├── 📄 main.tf
    │   ├── 📄 variables.tf
    │   └── 📄 outputs.tf
    │
    ├── 📂 securityGroups/        # Security Group Module
    │   ├── 📄 main.tf
    │   ├── 📄 variables.tf
    │   └── 📄 outputs.tf
    │
    └── 📂 loadBalancers/         # ALB Module
        ├── 📄 main.tf
        ├── 📄 variables.tf
        └── 📄 outputs.tf
```

---

## 🧩 Module Breakdown

### 💻 EC2 Module

**Responsibilities:**
- ✅ Create EC2 instances using `for_each`
- ✅ Attach security groups
- ✅ Apply tags consistently
- ✅ Support lifecycle safety (`create_before_destroy`)

**Inputs:**
- AMI ID
- Instance type
- Key name
- Security group IDs
- Map of instance names → subnet IDs

**Outputs:**
- Instance IDs (map)
- Private IPs (map)
- ARNs (map)

---

### 🔒 Security Group Module

**Responsibilities:**
- ✅ Create a security group
- ✅ Dynamically create ingress rules
- ✅ Dynamically create egress rules
- ✅ Support CIDR-based and SG-based rules

Ingress and egress rules are passed as **maps**, allowing:
- 📝 Multiple rules
- 🏷️ Clear naming
- 🔧 Easy extension

---

### ⚖️ Load Balancer Module

**Responsibilities:**
- ✅ Create ALB
- ✅ Create target group
- ✅ Create listener
- ✅ Register EC2 instances dynamically

> 💡 The module does not assume how instances are created. It only requires instance IDs as input.

---

## 🚀 Getting Started

### Prerequisites

```bash
# Required tools
terraform >= 1.0
aws-cli >= 2.0
```

### 📦 Installation

```bash
# Clone the repository
git clone https://github.com/adil-khan-723/terraform-aws-infrastructure.git
cd terraform-aws-infrastructure

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the infrastructure
terraform apply
```

### 🧪 User Data

Each EC2 instance runs a startup script that:
- 📥 Installs Nginx
- 🌐 Serves a unique response per instance

This confirms:
- ✅ User data execution
- ✅ Instance differentiation
- ✅ Load balancing behavior

---

## 🎓 Challenges Faced

| Challenge | Solution |
|-----------|----------|
| 🔢 **count vs for_each** | Understanding resource addressing and stability |
| 📤 **Module Output Consumption** | Preserving maps across module boundaries |
| 🔒 **Security Group References** | Designing flexible variable structures |
| 🎯 **ALB Target Attachments** | Clean output/input design patterns |
| 📝 **User Data in Modules** | Template configuration at module boundary |
| 🔐 **Terraform State Locking** | Validating DynamoDB locking behavior |

---

## 🎉 Outcomes

By completing this project, I gained hands-on experience with:

- ✅ Real Terraform module design
- ✅ Remote backend configuration
- ✅ State locking mechanics
- ✅ Advanced `for_each` usage
- ✅ Secure AWS networking patterns
- ✅ Infrastructure composition using outputs and inputs

> 🎯 This project moved me from **"Terraform user"** to **"Terraform designer"**.

---

## 🚫 What This Project Is NOT

- ❌ Not a toy example
- ❌ Not copy-pasted from tutorials
- ❌ Not over-engineered with unnecessary services

---

## 🔮 Future Improvements

- [ ] 📈 Replace EC2 with Auto Scaling Groups
- [ ] 🔐 Add HTTPS listener with ACM
- [ ] 📊 Introduce CloudWatch alarms
- [ ] 🔄 Add CI/CD pipeline for Terraform
- [ ] 🐳 Extend to ECS or EKS
- [ ] 🌍 Add environment separation (dev/stage/prod)

---

## 👥 Who This Project Is For

- 🎓 DevOps interns
- 👨‍💻 Junior DevOps engineers
- ☁️ Cloud engineers learning Terraform
- 🔄 Anyone transitioning from scripts to infrastructure design

---

## 📚 Key Learnings

<table>
<tr>
<td width="50%">

### 🎯 Technical Skills
- Terraform module architecture
- AWS networking best practices
- State management strategies
- Security group design patterns
- Load balancer configuration

</td>
<td width="50%">

### 💡 Soft Skills
- Infrastructure as Code principles
- Production-ready thinking
- Scalability considerations
- Team collaboration patterns
- Documentation practices

</td>
</tr>
</table>

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. 🍴 Fork the repository
2. 🌿 Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push to the branch (`git push origin feature/AmazingFeature`)
5. 🎉 Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- 📖 HashiCorp Terraform Documentation
- 🌐 AWS Well-Architected Framework
- 👥 DevOps Community

---

## 📞 Contact

**Adil Khan** - [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/adilk3682)

Project Link: [https://github.com/adil-khan-723/terraform-aws-infrastructure](https://github.com/adil-khan-723/terraform-project2-moudlarized)

---

<div align="center">

### 🌟 Final Note

This project represents a **complete journey**:

**From non-modular Terraform** → **To production-aligned modular infrastructure**

With state safety, security, and scalability in mind.

It reflects how Terraform is **actually used in teams**, not just how it is taught in tutorials.

---

**Made with ❤️ and ☕ by Adil Khan**

⭐ Star this repo if you found it helpful!

</div>
