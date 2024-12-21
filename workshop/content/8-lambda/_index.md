---
title : "Setup Lambda Functions"
date : "`r Sys.Date()`"
weight : 8
chapter : false
pre : " <b> 8. </b> "
---

{{< img src="images/8.lambda/logo.png" title="Lambda logo" >}}

### Overview

**An Amazon Lambda function** is a serverless computing service that allows you to run code without provisioning or managing servers. You simply upload your code, and Lambda takes care of everything required to run and scale your application.

- Benefits of Using Lambda Functions:

    - **Serverless Architecture**: No need to manage servers.
    - **Pay-as-you-go Pricing**: Pay only for what resource you consumed.
    - **Automatic Scaling**: Automatically respond to code execution requests at any scale, from a dozen events per day to hundreds of thousands per second..
    - **Rapid Deployment**: Deploy code quickly and easily.
    - **Integration with Other AWS Services**: Seamless integration with various AWS services.

- Common Use Cases: Data Processing, Real-time Applications, Web and Mobile Backends, Image and Video Processing, Machine Learning,...

### Content

In this workshop, we have 3 lambda functions with difference missions:

8.1. [Create Extract Email Function](8.1-extract-email-function/)\
8.2. [Create Generate Email Function](8.2-generate-email-function/)\
8.3. [Create Send Email Function](8.3-send-email-function)
