---
title : "Tạo bảng Shipments"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre : " <b> 7.2 </b> "
---

#### 1. Thông tin chi tiết

- **Tên bảng**: shipments
- **Mô tả**: Bảng này mô tả trạng thái vận chuyển của mỗi đơn hàng.
- **Billing Mode**: PAY_PER_REQUEST (On-demand)
- **Partition Key**: orderId (String)

#### 2. Thuộc tính

| Attribute Name | Type   |
| -------------- | ------ |
| orderId        | String |
| carrier        | String |
| trackingNumber | String |
| status         | String |

#### 3. Các bước thực hiện

{{% notice info %}}
Bước này tương tự với bước **7.1** sử dụng cấu hình mặc định, và khác nhau ở tên bảng
{{% /notice %}}

Bạn có thể dễ dàng tạo với CLI

```bash
aws dynamodb create-table \
    --table-name shipments \
    --attribute-definitions AttributeName=orderId,AttributeType=S \
    --key-schema AttributeName=orderId,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region=us-east-1
```

Bảng đã được tạo

{{< img src="images/7.dynamodb/11.png" title="11-dynamodb" >}}

Cuối cùng là tạo 1 vài records

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

Làm mới trang và bạn có thể thấy records đã được tạo

{{< img src="images/7.dynamodb/12.png" title="12-dynamodb" >}}

Bước này đã hoàn thành, giờ bạn có thể sang bước tiếp theo.
