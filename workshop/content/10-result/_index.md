---
title : "Testing result"
date : "`r Sys.Date()`"
weight : 10
chapter : false
pre : " <b> 10. </b> "
---

1. We will go to the email dashboard, at this workshop i used Gmail, then i send a email with following format

```txt
Do you accept payment methods with credit cards?
```

{{< img src="images/10.result/1.png" title="1" >}}

2. Next we will check S3 email

{{< img src="images/10.result/2.png" title="2" >}}

3. Our first lambda function ExtractEmailLambda is working, we can see the log in Cloudwatch

{{< img src="images/10.result/3.png" title="3" >}}

4. Next we check GenerateEmailLambda

{{< img src="images/10.result/4.png" title="4" >}}

5. And SendEmailLambda

{{< img src="images/10.result/5.png" title="5" >}}

6. Our system is working perfectly :D. And the result is send to my gmail

{{< img src="images/10.result/6.png" title="6" >}}

7. Let's try sending query database

{{< img src="images/10.result/7.png" title="7" >}}

8. Ask something about policy

{{< img src="images/10.result/8.png" title="8" >}}

That's all, I hope you will love this workshop, please comment for any issue <3