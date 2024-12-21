---
title : "Create Generate Email Func"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre : " <b> 8.2 </b> "
---

This is the main function, with missions: 

- Received SQS messages
- Generate response email content using Amazon Bedrock and Multi-Agent Orchestrator framework
- Send generated data to SQS.

#### Multi Agent Orchestration introduction

The Multi-Agent Orchestrator framework is a powerful tool for implementing sophisticated AI systems comprising multiple specialized agents. Its primary purpose is to intelligently route user queries to the most appropriate agents while maintaining contextual awareness throughout interactions.

![image](https://awslabs.github.io/multi-agent-orchestrator/flow.jpg)

Key Features

- 🧠 **Intelligent Intent Classification** — Dynamically route queries to the most suitable agent based on context and content.
- 🌊 **Flexible Agent Responses** — Support for both streaming and non-streaming responses from different agents.
- 📚 **Context Management** — Maintain and utilize conversation context across multiple agents for coherent interactions.
- 🔧 **Extensible Architecture** — Easily integrate new agents or customize existing ones to fit your specific needs.
- 🌐 **Universal Deployment** — Run anywhere - from AWS Lambda to your local environment or any cloud platform.
- 🚀 **Scalable Design** — Handle multiple concurrent conversations efficiently, scaling from simple chatbots to complex AI systems.
- 📊 **Agent Overlap Analysis** — Built-in tools to analyze and optimize your agent configurations.
- 📦 **Pre-configured Agents** — Ready-to-use agents powered by Amazon Bedrock models.

You can read more about this framework and sample [here](https://awslabs.github.io/multi-agent-orchestrator/)

In this workshop i will use a blog sample from An AWS Community Builder [Link](https://community.aws/content/2lq6cYYwTYGc7S3Zmz28xZoQNQj/beyond-auto-replies-building-an-ai-powered-e-commerce-support-system) with 4 Agents:

- 📦 **Order Management Agent**: Handles everything related to orders, shipments, and returns (**Query DynamoDB to get statuses**).
- 🏷️ **Product Information Agent**: Answers questions about product specifications, compatibility, and availability.
- 💁 **Customer Service Agent**: For all those general inquiries and account stuff. It's basically a digital version of that super-helpful store clerk we all wish we had **(Using Amazon Bedrock knowledge base and agent)**.
- 👤 **Human Agent**: Handles complex issues that require human intervention.

#### Let's create the lambda function

Repeat the step 8.1 to upload lambda source code.

You can download it [index.zip](https://d9akteslg4v3w.cloudfront.net/workshops/002/generate/index.zip) or you can build them with my github repository [here](https://github.com/TsuKpa/aws-ws-002-ai-powered-email-auto-replies/tree/master/resource/lambda/generate-email). After got that file, you need to upload it to lambda **Code** > **Upload from** > **.zip file**

The difference are the environment variables, the IAM role (`GenerateEmailFunctionRole`) and the memory is larger than. We need to config environment variables for our function to interact with other service

| Key                               | Value                          | Description                                             |
| --------------------------------- | ------------------------------ | ------------------------------------------------------- |
| `CUSTOMER_SERVICE_AGENT_ID`       | YOUR_AGENT_ID                  | The ID of the Amazon Bedrock Knowledge Base Agent       |
| `CUSTOMER_SERVICE_AGENT_ALIAS_ID` | YOUR_AGENT_ALIAS_ID            | The alias ID of the Amazon Bedrock Knowledge Base Agent |
| `KNOWLEDGE_BASE_ID`               | YOUR_KNOWLEDGE_BASE_ID         | The ID of the Amazon Bedrock Knowledge Base             |
| `RESPONSE_QUEUE_NAME`             | `sqs-send-email-to-customer-queue` | The name of the SQS queue for sending email responses   |

We will add more memory and timeout

{{< img src="images/8.lambda/35.png" title="lambda35" >}}

Then adjust to `1024` and timeout is `30`s, choose **Save**
{{< img src="images/8.lambda/36.png" title="lambda36" >}}

#### Details about our function

| Configuration | Value                       | Description                                                                |
| ------------- | --------------------------- | -------------------------------------------------------------------------- |
| function_name | `GenerateEmailLambda`       | The unique name identifier for the Lambda function                         |
| role          | `GenerateEmailFunctionRole` | IAM role that defines the permissions and access policies for the function |
| runtime       | nodejs20.x                  | The execution environment and version for the Lambda function (Node.js 20) |
| handler       | index.handler               | The entry point for the function                                           |
| memory_size   | 1024                        | Amount of memory allocated to the function in MB (1024MB)                  |
| timeout       | 30                          | Maximum execution time allowed for the function in seconds                 |

1. Orchestrator class

```ts
import {
  BedrockClassifier,
  MultiAgentOrchestrator
} from 'multi-agent-orchestrator';
import { humanAgent } from './agents/human';
import { orderManagementAgent } from './agents/order-management';
import { productInfoAgent } from './agents/product-info';
import { customerServiceAgent } from './agents/customer-service';

const customBedrockClassifier = new BedrockClassifier({ // set default classifier
  modelId: 'anthropic.claude-3-haiku-20240307-v1:0',
  region: "us-east-1",
  inferenceConfig: {
    maxTokens: 500,
    temperature: 0.7,
    topP: 0.9
  }
});

// Create and export the orchestrator
const orchestrator = new MultiAgentOrchestrator({ classifier: customBedrockClassifier });

orchestrator.addAgent(orderManagementAgent);
orchestrator.addAgent(productInfoAgent);
orchestrator.addAgent(humanAgent);
orchestrator.addAgent(customerServiceAgent);

export default orchestrator; // Export for local and handle index
```

2. Local test, this file can be call from your host, you can see `README.md` at the lambda function for setting up and demo

```ts
import { ConversationMessage } from 'multi-agent-orchestrator';
import { emailFormatAgent } from './agents/email-format.js';
import orchestrator from './orchestrator.js';

// WARN: You must request access model in Amazon Bedrock console

async function testOrchestrator() {
  const testEmails = [
    { text: "How your shop protecting customer personal information?", userId: "user2", sessionId: "session2" },
    { text: "What's the status of my order #12345?", userId: "user1", sessionId: "session1" },
    { text: "Do you accept payment methods with credit cards", userId: "user3", sessionId: "session3" },
    { text: "What's the return policy of product?", userId: "user4", sessionId: "session4" },
    { text: "What kind of products do you sell", userId: "user5", sessionId: "session5" }
  ];

  for (const email of testEmails) {
    console.log(`Processing email: "${email.text}"`);
    const response = await orchestrator.routeRequest(email.text, email.userId, email.sessionId);
    const finalResponse = await emailFormatAgent.processRequest(response.output as string, "user", "session", []) as ConversationMessage;
    console.log("Final Response:", finalResponse.content as unknown as string);
    console.log(`Response from ${response.metadata.agentName}:`);
    console.log(response.output);
    console.log('---');
  }
}
testOrchestrator().catch(console.error);
```

3. Format email agent

```ts
export const emailFormatAgent = new BedrockLLMAgent({
    name: "Email Format Agent",
    description: "Format response to email, the format will be, 'Dear Customer, \n YOUR_RESPONSE_WILL_BE_HERE. \n 'Best regards,\n' Cat shop \n'", // This is the prompt to final format response before send it to SQS
    modelId: "anthropic.claude-3-haiku-20240307-v1:0",
    region: "us-east-1",
    saveChat: false
} as BedrockLLMAgentOptions); 
```
4. Order management agent

```ts
const orderManagementToolConfig = [
    {
        toolSpec: {
            name: "OrderLookup",
            description: "Retrieve order details from the database",
            inputSchema: {
                json: {
                    type: "object",
                    properties: {
                        orderId: { type: "string", description: "The order ID to look up" }
                    },
                    required: ["orderId"]
                }
            }
        }
    },
    {
        toolSpec: {
            name: "ShipmentTracker",
            description: "Get real-time shipping information",
            inputSchema: {
                json: {
                    type: "object",
                    properties: {
                        orderId: { type: "string", description: "The order ID to track" }
                    },
                    required: ["orderId"]
                }
            }
        }
    },
    {
        toolSpec: {
            name: "ReturnProcessor",
            description: "Initiate and manage return requests",
            inputSchema: {
                json: {
                    type: "object",
                    properties: {
                        orderId: { type: "string", description: "The order ID for the return" }
                    },
                    required: ["orderId"]
                }
            }
        }
    }
];

export async function orderManagementToolHandler(response: ConversationMessage, conversation: ConversationMessage[]) {
    const responseContentBlocks = response.content as any[];
    let toolResults: any = [];

    if (!responseContentBlocks) {
        throw new Error("No content blocks in response");
    }

    for (const contentBlock of responseContentBlocks) {
        if ("toolUse" in contentBlock) {
            const toolUseBlock = contentBlock.toolUse;
            const toolUseName = toolUseBlock.name;
            let result;

            switch (toolUseName) {
                case "OrderLookup":
                    result = orderLookup(toolUseBlock.input.orderId);
                    break;
                case "ShipmentTracker":
                    result = shipmentTracker(toolUseBlock.input.orderId);
                    break;
                case "ReturnProcessor":
                    result = returnProcessor(toolUseBlock.input.orderId);
                    break;
            }

            if (result) {
                toolResults.push({
                    "toolResult": {
                        "toolUseId": toolUseBlock.toolUseId,
                        "content": [{ json: { result } }],
                    }
                });
            }
        }
    }

    const message: ConversationMessage = { role: ParticipantRole.USER, content: toolResults };
    conversation.push(message);
}

export const orderManagementAgent = new BedrockLLMAgent({
    name: "Order Management Agent",
    description: "Handles order-related inquiries including order status, shipment tracking, returns, and refunds. Uses order database and shipment tracking tools.",
    toolConfig: {
        useToolHandler: orderManagementToolHandler,
        tool: orderManagementToolConfig,
        toolMaxRecursions: 5
    },
    modelId: "anthropic.claude-3-sonnet-20240229-v1:0",
    region: "us-east-1",
    saveChat: false
} as BedrockLLMAgentOptions);

```

5. Product management agent, this agent will read our faqs.txt document for response about shop policies, payment,...

```ts
const productInfoRetriever = new AmazonKnowledgeBasesRetriever(
    new BedrockAgentRuntimeClient({ region: "us-east-1" }),
    { knowledgeBaseId: env.KNOWLEDGE_BASE_ID }
);

export const productInfoAgent = new BedrockLLMAgent({
    name: "Product Information Agent",
    description: "Provides detailed product information, answers questions about specifications, compatibility, and availability.",
    retriever: productInfoRetriever,
    modelId: "anthropic.claude-3-haiku-20240307-v1:0",
    region: "us-east-1",
    saveChat: false
} as BedrockLLMAgentOptions); 
```

6. And final is Customer Service Agent. This agent will use the agent we created from step 6

```ts
export const customerServiceAgent = new AmazonBedrockAgent({
    name: "Customer Service Agent BedRock",
    description: "Handles general customer inquiries, account-related questions, and non-technical support requests. Uses comprehensive customer service knowledge base.",
    agentId: env.CUSTOMER_SERVICE_AGENT_ID,
    agentAliasId: env.CUSTOMER_SERVICE_AGENT_ALIAS_ID,
    saveChat: false,
    region: "us-east-1"
} as AmazonBedrockAgentOptions); 
```