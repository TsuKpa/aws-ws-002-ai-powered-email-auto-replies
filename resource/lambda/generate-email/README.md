# Auto email reply with Generative AI

#### Local running result example

At first you must create **Amazon Bedrock** with knowledge base and agent (watch out **terraform** folder) and setting result to the **.env** file

```bash
$npm run local
> src@1.0.0 local
> tsx ./src/local-test.ts

Processing email: "How your shop protecting customer personal information?"
Routing intent "How your shop protecting customer personal information?" to customer-service-agent-bedrock ...
Final Response: [
  {
    text: 'Dear Customer,\n' +
      '\n' +
      "Thank you for reaching out and providing the details about the security measures our shop takes to protect customer personal information. I'm glad to hear that our commitment to data privacy and security has been recognized.\n" +
      '\n' +
      "You've summarized the key points very accurately. We do indeed use industry-standard encryption, HTTPS, and other technical safeguards to protect sensitive data like passwords and payment information. We also have strict data collection and retention policies to minimize the personal data we hold and ensure it's deleted or anonymized when no longer needed.\n" +
      '\n' +
      "Conducting regular security audits and having a data breach response plan in place are also critical components of our approach. It's important to us that our customers feel confident their information is being handled responsibly and securely.\n" +
      '\n' +
      'We also emphasize the importance of customers practicing good cyber hygiene, like using strong and unique passwords, being cautious of phishing attempts, and keeping their software up-to-date. These individual security practices complement the measures we have in place on our end.\n' +
      '\n' +
      "Thank you for taking the time to research and understand our data protection practices. If you have any other questions, please don't hesitate to reach out. We're always happy to provide more information about how we safeguard our customers' personal data.\n" +
      '\n' +
      'Best regards,\n' +
      'Cat Shop'
  }
]
Response from Customer Service Agent BedRock:
According to the search results, your shop takes several measures to protect customer personal information: - You use industry-standard encryption techniques to protect sensitive data like passwords and credit card details, and you use HTTPS to encrypt data transmitted between customers' browsers and your servers (source 4).
- You collect only the necessary personal information and avoid collecting unnecessary data (source 4).
- You have data retention policies in place to ensure personal information is deleted or anonymized when it's no longer needed (source 4).
- You conduct regular security audits and vulnerability assessments to identify and address potential security risks, and you have a comprehensive data breach response plan in place (source 5).
- You encourage customers to use strong, unique passwords and be cautious of phishing attacks, and to keep their software up-to-date (source 5).
---
Processing email: "What's the status of my order #12345?"
Routing intent "What's the status of my order #12345?" to order-management-agent ...
Final Response: [
  {
    text: 'Dear Customer,\n' +
      '\n' +
      "Thank you for reaching out regarding your order #12345. I'm happy to provide you with the details you requested.\n" +
      '\n' +
      'According to our records, your order containing a Widget A and Gadget B for a total of $150 has been successfully shipped. The tracking information for your shipment is as follows:\n' +
      '\n' +
      'Tracking Number: 1Z999AA1234567890\n' +
      'Estimated Delivery Date: June 10, 2023\n' +
      '\n' +
      "Please let me know if you need any additional information about the shipment tracking or delivery timeline for this order. I'm here to assist you and ensure you receive your items in a timely manner.\n" +
      '\n' +
      'Best regards,\n' +
      'Cat shop'
  }
]
Response from Order Management Agent:
According to the order lookup, your order #12345 containing a Widget A and Gadget B for a total of $150 has been shipped. Please let me know if you need any additional details on the shipment tracking or delivery timeline for this order.
---
Processing email: "Do you accept payment methods with credit cards"
Routing intent "Do you accept payment methods with credit cards" to customer-service-agent-bedrock ...
Final Response: [
  {
    text: 'Dear Customer,\n' +
      '\n' +
      "Thank you for your inquiry about our credit card payment options. I'm happy to confirm that we do accept credit card payments at our store. Specifically, we accept the following major credit cards: Visa, Mastercard, American Express, and Discover Card.\n" +
      '\n' +
      "Our goal is to provide a convenient and secure payment experience for all of our customers. If you have any other questions about our payment methods or policies, please don't hesitate to ask.\n" +
      '\n' +
      'Best regards,\n' +
      'Cat Shop'
  }
]
Response from Customer Service Agent BedRock:
Yes, we accept credit card payments. According to the search results, the store accepts the following credit card payment methods: Visa, Mastercard, American Express, and Discover Card.
---
Processing email: "What's the return policy of product?"
Routing intent "What's the return policy of product?" to customer-service-agent-bedrock ...
Final Response: [
  {
    text: 'Dear Customer,\n' +
      '\n' +
      'Thank you for providing the details on the return policy for the Cat Shop. To summarize:\n' +
      '\n' +
      '- Items must be returned within [number] days of the purchase date.\n' +
      '- Items must be in new, unused condition with all original tags and packaging. \n' +
      '- Certain items, such as personalized or custom-made products, may not be eligible for return.\n' +
      '- To initiate a return, customers must contact the customer service team at 0199.999.999 or catshop@catshop.com to obtain a return authorization number. \n' +
      '- The item must then be packaged securely and shipped to the provided return address.\n' +
      '- Once the returned item is received and its condition is verified, the customer will receive a refund for the full purchase price, excluding shipping and handling fees.\n' +
      '- Refunds may take [3] business days to process.\n' +
      '\n' +
      "Please let me know if you have any other questions about the return policy or the ordering process. I'm happy to provide additional information to ensure you have a smooth and satisfactory shopping experience.\n" +
      '\n' +
      'Best regards,\n' +
      'Cat Shop'
  }
]
Response from Customer Service Agent BedRock:
According to the search results, the return policy for the Cat Shop is as follows:
- Items must be returned within [number] days of the purchase date.
- Items must be in new, unused condition with all original tags and packaging.
- Certain items, such as personalized or custom-made products, may not be eligible for return. To initiate a return, customers must contact the customer service team at 0199.999.999 or catshop@catshop.com to obtain a return authorization number. The item must then be packaged securely and shipped to the provided return address.
Once the returned item is received and its condition is verified, the customer will receive a refund for the full purchase price, excluding shipping and handling fees. Refunds may take [3] business days to process.
---
Processing email: "What kind of products do you sell"
Routing intent "What kind of products do you sell" to customer-service-agent-bedrock ...
Final Response: [
  {
    text: 'Dear Customer,\n' +
      '\n' +
      'Thank you for your interest in our cat shop. Based on the information you provided, it seems that we offer a wide range of products and services to meet the needs of cat owners like yourself. \n' +
      '\n' +
      "Our cat food selection includes high-quality, nutritious options from trusted brands to ensure your feline friend stays healthy and happy. We also carry an extensive range of cat toys, scratching posts, and other accessories to stimulate your cat's natural instincts and provide enrichment.\n" +
      '\n' +
      "In addition to these essentials, we offer grooming supplies and professional grooming services to keep your cat's coat in top condition. Our knowledgeable staff can provide personalized recommendations and advice to help you choose the best products for your particular cat's needs.\n" +
      '\n' +
      "Please let me know if you have any other questions or if there is anything else I can assist you with. I'm happy to provide more details about our offerings or help you find the perfect items for your beloved cat.\n" +
      '\n' +
      'Best regards,\n' +
      'Cat shop'
  }
]
Response from Customer Service Agent BedRock:
According to the search results, the store sells a variety of cat products, including:
- Cat food
- Cat toys and accessories
- Cat trees and scratching posts
- Grooming supplies and services
---
```
