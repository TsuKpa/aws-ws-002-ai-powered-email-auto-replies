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

### 1.2. Setup AWS CLI and credentials

Install AWS CLI at this [link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). Then verify it with

```bash
aws --version
```

Using this document to setup AWS Credentials to our AWS CLI with this [link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

### 1.3. Setup AWS SAM CLI

Install SAM CLI for building lambda functions stage: [link](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)

```bash
sam --version
```

### 1.4. Setup NVM and NodeJS Esbuild

Install NVM at this link and run following command to install nodejs and esbuild [link](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)

```bash
# Validate nvm
nvm -v

# Install nodejs with latest version (Listing version with `nvm ls` or specified version `nvm install 20 && nvm use 20`)
nvm install node && nvm use node

# Validate nodejs is installed
node -v

# Install esbuild global
npm install -g esbuild
```

## 2. Running

{{% notice info %}}
**Region** is `us-east-1`.
{{% /notice %}}

This is our terraform source code tree, i split each service into modules for use later.

```markdown
.
├── README.md
├── main.tf
├── modules
│   ├── amazon-bedrock
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   ├── cloudwatch
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── dynamodb
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam-role
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambdas
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ses
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── sqs
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars.example (You must copy and edit this file to `terraform.tfvars`)
└── variables.tf
```

### 2.1. Copy resource to other directory

First, you must clone or download my source code at this [link](https://github.com/TsuKpa/aws-ws-002-ai-powered-email-auto-replies). After that you would copy folder `resource` to other directory and then you can start creating your infrastructure.

Next, in `terraform` directory we need copy the file `terraform.tfvars.example` to `terraform.tfvars`.

- region        = "us-east-1"
- bucket_name   = "ai-powered-email-auto-replies-001"
- custom_domain = "YOUR_DOMAIN" <-- Change this
- sender_email  = "YOUR_EMAIL_TEST" <-- Change this
- source_email  = "support@YOUR_DOMAIN" <-- Change this

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

After this, you must go to SES dashboard to setup Easy DKIM in the step [4 Setting Domain and Email identity](4-ses/). Now, you can go to testing your result.

### 2.4. Deleting resources

```bash
terraform destroy -auto-approve
```
