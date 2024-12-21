---
title : "Create Shipments table"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre : " <b> 7.2 </b> "
---

#### 1. Details

- **Table Name**: shipments
- **Description**: This table will simulate the data of each shipments status.
- **Billing Mode**: PAY_PER_REQUEST (On-demand)
- **Partition Key**: orderId (String)

#### 2. Attributes

| Attribute Name | Type   |
| -------------- | ------ |
| orderId        | String |
| carrier        | String |
| trackingNumber | String |
| status         | String |

#### 3. Create table

{{% notice info %}}
This step is the same with step **7.1** using default settings, i just change the name of the table
{{% /notice %}}

You can create table with AWS CLI

```bash
aws dynamodb create-table \
    --table-name shipments \
    --attribute-definitions AttributeName=orderId,AttributeType=S \
    --key-schema AttributeName=orderId,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region=us-east-1
```

The table is created

{{< img src="images/7.dynamodb/11.png" title="11-dynamodb" >}}

Final, let's create sample records

```bash
# Create shipment record 1
aws dynamodb put-item \
  --table-name shipments \
  --item '{
    "orderId": {"S": "12345"},
    "carrier": {"S": "FastShip"},
    "trackingNumber": {"S": "FS123456789"},
    "status": {"S": "IN_TRANSIT"}
  }' \
  --region=us-east-1

# Create shipment record 2  
aws dynamodb put-item \
  --table-name shipments \
  --item '{
    "orderId": {"S": "67890"},
    "carrier": {"S": "QuickPost"},
    "trackingNumber": {"S": "QP987654321"}, 
    "status": {"S": "DELIVERED"}
  }' \
  --region=us-east-1

# Create shipment record 3
aws dynamodb put-item \
  --table-name shipments \
  --item '{
    "orderId": {"S": "24680"},
    "carrier": {"S": "ExpressLine"},
    "trackingNumber": {"S": "EL456789123"},
    "status": {"S": "PROCESSING"}
  }' \
  --region=us-east-1
```

Refresh the page and you got these items

{{< img src="images/7.dynamodb/12.png" title="12-dynamodb" >}}

Let's go to the next step.
