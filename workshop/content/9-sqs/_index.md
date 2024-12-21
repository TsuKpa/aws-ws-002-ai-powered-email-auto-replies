---
title : "Setup SQS"
date : "`r Sys.Date()`"
weight : 9
chapter : false
pre : " <b> 9. </b> "
---

{{< img src="images/9.sqs/logo.svg" title="SQS logo" >}}

### Overview

**Amazon Simple Queue Service (SQS)** is a fully managed message queuing service that enables decoupling and scaling of distributed systems and serverless applications. It provides a reliable, highly-available intermediary for sending messages between application components.

Key benefits of SQS:

- **Decouple components**: SQS allows different parts of a distributed application to run independently
- **Handle high throughput**: Can process thousands of messages per second
- **At-least-once delivery**: Messages are stored redundantly across multiple AZs
- **Configurable retention**: Messages can be stored up to 14 days
- **Cost effective**: Pay only for the requests you make
- **Managed service**: No servers to provision or manage

Common use cases:

- **Workload decoupling**: Separate producers from consumers
- **Batch processing**: Collect and process messages in batches
- **Request buffering**: Handle traffic spikes by queuing requests
- **Fan-out architectures**: Distribute messages to multiple consumers
- **Job queues**: Coordinate distributed job processing
- **Microservices** communication: Reliable async messaging between services

In this workshop, we'll use SQS to decouple our Lambda functions that handle email processing:
- Generate email responses 
- Send emails

This architecture allows each function to process messages at its own pace while ensuring reliable message delivery between components.

### Content

Now, we going to create them

#### Generate email response queue

1. In the **AWS Console**, search *"sqs"* and choose **Simple Queue Service**

{{< img src="images/9.sqs/1.png" title="sqs1" >}}

2. Choose **Create queue**

{{< img src="images/9.sqs/2.png" title="sqs2" >}}

3. We are using default setting, type `sqs-generate-email-content-queue` as Name

{{< img src="images/9.sqs/3.png" title="sqs3" >}}

4. Choose **Create queue**

{{< img src="images/9.sqs/4.png" title="sqs4" >}}

5. Create queue successful, next we need to setup trigger lambda function when a message incoming, choose **Lambda triggers**

{{< img src="images/9.sqs/5.png" title="sqs5" >}}

6. Choose **Configure Lambda function trigger**

{{< img src="images/9.sqs/6.png" title="sqs6" >}}

7. Then we choose exist Generate Email Lambda we created at step 8.2, then choose **Save**

{{< img src="images/9.sqs/7.png" title="sqs7" >}}

8. As you can see we just add a trigger for our SQS, then you can go next step

{{< img src="images/9.sqs/8.png" title="sqs8" >}}

#### Send email queue

This queue is same with generate email queue, please help me create this queue

- Name: `sqs-send-email-to-customer-queue`
- Trigger Lambda function: `SendEmailLambda`

{{< img src="images/9.sqs/9.png" title="sqs9" >}}