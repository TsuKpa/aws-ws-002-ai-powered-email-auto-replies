---
title : "Tạo bảng Orders"
date :  "`r Sys.Date()`" 
weight : 1
chapter : false
pre : " <b> 7.1 </b> "
---

#### 1. Thông tin chi tiết

- **Tên bảng**: orders
- **Mô tả**: Bảng này sẽ chứa các thông tin cơ bản về đơn hàng
- **Billing Mode**: PAY_PER_REQUEST (On-demand)
- **Partition Key**: orderId (String)

#### 2. Thuộc tính

| Attribute Name | Type   |
| -------------- | ------ |
| orderId        | String |
| status         | String |
| items          | List   |
| total          | Number |

#### 3. Các bước thực hiện

3.1. Vào DynamoDB service ở AWS console, nhớ chọn region `us-east-1`

{{< img src="images/7.dynamodb/1.png" title="1-dynamodb" >}}

3.2. Ở panel bên trái, chọn **Tables** -> chọn **Create table**

{{< img src="images/7.dynamodb/2.png" title="2-dynamodb" >}}

3.3. Tiếp theo, chúng ta sẽ thêm thông tin vào, tên bảng là `orders` và Partition key là `orderId`

{{< img src="images/7.dynamodb/3.png" title="3-dynamodb" >}}

3.4. Cuối cùng chọn **Create table**

{{< img src="images/7.dynamodb/4.png" title="4-dynamodb" >}}

Tạo bảng `orders` thành công

{{< img src="images/7.dynamodb/5.png" title="5-dynamodb" >}}

3.5. Tiếp theo chúng ta cần tạo 1 vài record để giả định, Chọn **orders**

{{< img src="images/7.dynamodb/6.png" title="6-dynamodb" >}}

3.6. Chọn **Create item** ở menu **Actions**

{{< img src="images/7.dynamodb/7.png" title="7-dynamodb" >}}

3.7. Chọn **JSON view** và paste đoan JSON bên dưới vào **Attributes**, cuối cùng chọn **Create item**

```json
{
  "orderId": {
    "S": "12345"
  },
  "status": {
    "S": "DELIVERED"
  },
  "items": {
    "SS": [
      "Widget A",
      "Gadget B"
    ]
  },
  "total": {
    "N": "150"
  }
}
```

{{< img src="images/7.dynamodb/8.png" title="8-dynamodb" >}}

Sau khi thêm thì bạn cần load lại trang

{{< img src="images/7.dynamodb/9.png" title="9-dynamodb" >}}

Và lặp lại từ bước **3.6** với dữ liệu khác

```json
{
  "orderId": {
    "S": "6789"
  },
  "status": {
    "S": "PROCESSING"
  },
  "items": {
    "SS": [
      "Gizmo C"
    ]
  },
  "total": {
    "N": "75.50"
  }
}
```

Chúng ta đã tạo thành công, giờ bạn có thể sang bước tiếp theo

{{< img src="images/7.dynamodb/10.png" title="10-dynamodb" >}}
