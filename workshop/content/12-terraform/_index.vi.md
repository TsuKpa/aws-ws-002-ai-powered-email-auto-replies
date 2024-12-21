---
title: "IaC (Terraform)"
date: 2024
weight: 12
chapter: false
pre: "<b>12. </b>"
---

Ở phần này thì mình sẽ hướng dẫn các bạn sử dụng terraform để tự động tạo hệ thống

## 1. Setup

### 1.1. Setup Terraform

Download CLI tại [link](https://developer.hashicorp.com/terraform/install). Sau đó thì kiểm tra bằng lệnh:

```bash
terraform --version
```

### 1.2. Setup AWS CLI and credentials

Cài đặt AWS CLI tại [link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). Và kiểm tra tại

```bash
aws --version
```

Bạn có thể sử dụng tài liệu này để setup credentials cho CLI [link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

### 1.3. Setup AWS SAM CLI

Cài đặt SAM CLI để build source: [link](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)

```bash
sam --version
```

### 1.4. Setup NVM and NodeJS Esbuild

Tiếp theo là bạn cần nvm để cài đặt nodejs và esbuild [link](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)

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

Đây là cấu trúc thư mục chính, mục đích là để sử dụng lại khi cần

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

### 2.1. Copy thư mục resource vào nơi khác

Đầu tiên thì bạn cần clone hoặc download source code tại [link](https://github.com/TsuKpa/aws-ws-002-ai-powered-email-auto-replies). Sau đó thì bạn copy thư mục resource vào nơi khác.

Tiếp theo, ở thư mục `terraform` bạn cần copy file `terraform.tfvars.example` thành `terraform.tfvars`. File này giống như .env trong NodeJS và sẽ chứa các nội dung như sau

- region        = "us-east-1"
- bucket_name   = "ai-powered-email-auto-replies-001"
- custom_domain = "YOUR_DOMAIN" <-- Change this
- sender_email  = "YOUR_EMAIL_TEST" <-- Change this
- source_email  = "support@YOUR_DOMAIN" <-- Change this

### 2.2. Init terraform

Vào thư mục `terraform`

```bash
cd terraform
```

Init Provider

```bash
terraform init
```

Kiểm tra state hiện tại và cú pháp

```bash
terraform plan
```

Nếu không có lỗi thì bạn có thể tiếp tục.

### 2.3. Tạo tài nguyên

```bash
terraform apply -auto-approve
```

Sau bước này thì bạn cần vào SES để setup DKIM [4 Setting Domain and Email identity](4-ses/). Sau khi xong thì bạn đã có thể testing hệ thống của mình.

### 2.4. Xoá tài nguyên

```bash
terraform destroy -auto-approve
```
