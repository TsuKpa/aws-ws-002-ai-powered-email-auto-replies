---
title : "Create Orders table"
date :  "`r Sys.Date()`" 
weight : 1
chapter : false
pre : " <b> 7.1 </b> "
---

#### 1. Details

- **Table Name**: orders
- **Description**: This table will simulate the data of each order status.
- **Billing Mode**: PAY_PER_REQUEST (On-demand)
- **Partition Key**: orderId (String)

#### 2. Attributes

| Attribute Name | Type   |
| -------------- | ------ |
| orderId        | String |
| status         | String |
| items          | List   |
| total          | Number |

#### 3. Create table

3.1. Go to DynamoDB service in AWS console, remember to choose `us-east-1`

{{< img src="images/7.dynamodb/1.png" title="1-dynamodb" >}}

3.2. At the left panel, choose **Tables** -> Choose **Create table**

{{< img src="images/7.dynamodb/2.png" title="2-dynamodb" >}}

3.3. Next, we will fill some information about our table, the table name is `orders` and the Partition key is `orderId`

{{< img src="images/7.dynamodb/3.png" title="3-dynamodb" >}}

3.4. Final click **Create table**

{{< img src="images/7.dynamodb/4.png" title="4-dynamodb" >}}

Create `orders` table successful

{{< img src="images/7.dynamodb/5.png" title="5-dynamodb" >}}

3.5. Next, we need to create some records for simulate data of our service, let's choose the table we just created

{{< img src="images/7.dynamodb/6.png" title="6-dynamodb" >}}

3.6. Click **Create item** at the menu **Actions**

{{< img src="images/7.dynamodb/7.png" title="7-dynamodb" >}}

3.7. Choose **JSON view** and paste following JSON below to **Attributes**, final choose **Create item**

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

After created, you need to refresh the page

{{< img src="images/7.dynamodb/9.png" title="9-dynamodb" >}}

Then repeat from the **step 3.6** with another data

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

Yeah, we got 2 records in our orders table, let's go to the next step

{{< img src="images/7.dynamodb/10.png" title="10-dynamodb" >}}
