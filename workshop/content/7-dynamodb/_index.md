---
title : "Setup DynamoDB"
date : "`r Sys.Date()`"
weight : 7
chapter : false
pre : " <b> 7. </b> "
---

{{< img src="images/7.dynamodb/dynamodb.jpeg" title="dynamodb logo" >}}

### Overview

**Amazon DynamoDB** is a serverless, NoSQL database service that allows you to develop modern applications at any scale.

As a serverless database, you only pay for what you use and **DynamoDB** scales to zero, has no cold starts, no version upgrades, no maintenance windows, no patching, and no downtime maintenance.

**DynamoDB** offers a broad set of security controls and compliance standards. For globally distributed applications, **DynamoDB** global tables is a multi-Region, multi-active database with a 99.999% availability SLA and increased resilience.

**DynamoDB** reliability is supported with managed backups, point-in-time recovery, and more.

{{% notice note %}}
In this workshop, this section just simulate a part of ecommerce ecosystem :)
{{% /notice %}}

### Content

7.1. [Create Orders table](7.1-create-orders-table/)\
7.2. [Create Shipments table](7.2-create-shipments-table/)
