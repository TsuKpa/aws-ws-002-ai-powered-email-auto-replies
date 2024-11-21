---
title: "IaC (Terraform)"
date: 2024
weight: 12
chapter: false
pre: "<b>12. </b>"
---

This section will introduction you to create/destroy the infrastructure of this workshop by using Terraform

## 1. Setup

### 1.1. Setup Terraform

Download terraform by this [link](https://developer.hashicorp.com/terraform/install). After that, verify your terraform cli with:

```bash
terraform --version
```

### 1.2. Setup Github Token

Go to github account settings with this [link](https://github.com/settings/tokens?type=beta). Then create Fine-grained personal access tokens with full permissions. After that copy the token to somewhere we can paste it in next step.

### 1.3. Setup AWS CLI and credentials

Install AWS CLI at this [link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). Then verify it with

```bash
aws --version
```

Using this document to setup AWS Credentials to our AWS CLI with this [link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

## 2. Running

This is our terraform source code tree, i split each service into modules for use later.

```markdown
.
├── main.tf
├── modules
│   ├── cloudfront
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── github
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam-role
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── s3
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars.example (You must copy and rename this file to "terraform.tfvars")
└── variables.tf
```

### 2.1. Copy IaC to other directory

First, you must clone or download my source code at this [link](https://github.com/TsuKpa/001-deploy-static-site-to-s3). After that you would copy 2 folders `terraform` and `next-app` to other directory (2 of them must be same directory).

```markdown
any-directory
├── terraform/
├── next-app/
```

Next, in `terraform` directory we need copy the file `terraform.tfvars.example` to `terraform.tfvars`, lets check about 2 variables: `github_token` is the token we create in the step `1.2` and `github_owner` is your github username (case sensitive).

### 2.2. Init terraform

Go to `terraform` directory

```bash
cd terraform
```

Init Provider

```bash
terraform init
```

Check current state and variables

```bash
terraform plan
```

If not errors occurs, we can go next.

### 2.3. Creating resources

```bash
terraform apply -auto-approve
```

If this command runs well, we can see the final Cloudfront URL output at terminal and successfully create the infrastructure!

### 2.4. Deleting resources

```bash
terraform destroy -auto-approve
```
