---
title : "Tạo Generate Email Func"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre : " <b> 8.2 </b> "
---
Đây là chức năng chính, với các nhiệm vụ:

- Nhận tin nhắn SQS
- Tạo nội dung email phản hồi bằng Amazon Bedrock và Multi-Agent Orchestrator framework
- Gửi dữ liệu đã tạo đến SQS.

#### Giới thiệu về Multi Agent Orchestration

**Multi-Agent Orchestrator** là một công cụ mạnh mẽ để triển khai các hệ thống AI phức tạp bao gồm nhiều agent chuyên biệt. Mục đích chính của nó là định tuyến thông minh các truy vấn của người dùng đến các agent phù hợp nhất trong khi vẫn duy trì nhận thức theo ngữ cảnh trong suốt quá trình tương tác.

![image](https://awslabs.github.io/multi-agent-orchestrator/flow.jpg)

Các tính năng chính

- 🧠 **Phân loại ý định thông minh** — Định tuyến động các truy vấn đến agent phù hợp nhất dựa trên ngữ cảnh và nội dung.
- 🌊 **Phản hồi agent linh hoạt** — Hỗ trợ cả phản hồi streaming và non-streaming từ các agent khác nhau.
- 📚 **Quản lý ngữ cảnh** — Duy trì và sử dụng ngữ cảnh hội thoại trên nhiều agent để có các tương tác mạch lạc.
- 🔧 **Kiến trúc mở rộng** — Dễ dàng tích hợp các agent mới hoặc tùy chỉnh các agent hiện có để phù hợp với nhu cầu cụ thể của bạn.
- 🌐 **Triển khai phổ quát** — Chạy ở mọi nơi - từ AWS Lambda đến môi trường cục bộ của bạn hoặc bất kỳ nền tảng đám mây nào.
- 🚀 **Thiết kế có thể mở rộng** — Xử lý nhiều cuộc trò chuyện đồng thời một cách hiệu quả, mở rộng từ các chatbot đơn giản đến các hệ thống AI phức tạp.
- 📊 **Phân tích chồng chéo agent** — Các công cụ tích hợp để phân tích và tối ưu hóa cấu hình agent của bạn.
- 📦 **Agent được cấu hình sẵn** — Các agent sẵn sàng sử dụng được hỗ trợ bởi các mô hình Amazon Bedrock.

Bạn có thể đọc chi tiết tại đây [here](https://awslabs.github.io/multi-agent-orchestrator/)

Ở workshop này thì tôi sử dụng bài blog của một AWS Community Builder [Link](https://community.aws/content/2lq6cYYwTYGc7S3Zmz28xZoQNQj/beyond-auto-replies-building-an-ai-powered-e-commerce-support-system) với 4 agents:

- 📦 **Order Management Agent**: Xử lý mọi thứ liên quan đến đơn hàng, lô hàng và trả lại (**Truy vấn DynamoDB để biết trạng thái**).
- 🏷️ **Product Information Agent**: Trả lời các câu hỏi về thông số kỹ thuật, khả năng tương thích và tình trạng còn hàng của sản phẩm.
- 💁 **Customer Service Agent**: Đối với tất cả các câu hỏi chung và vấn đề về tài khoản. Về cơ bản, đây là phiên bản kỹ thuật số của nhân viên bán hàng siêu hữu ích mà tất cả chúng ta đều mong muốn có **(Sử dụng knowledge base và Amazon Bedrock agent)**.
- 👤 **Human Agent**: Xử lý các vấn đề phức tạp đòi hỏi sự can thiệp của con người.

#### Các bước thực hiện

Bạn có thể thực hiện từ bước 8.1 để upload source code

Download tại [index.zip](https://d9akteslg4v3w.cloudfront.net/workshops/002/generate/index.zip) hoặc build từ source code [tại đây](https://github.com/TsuKpa/aws-ws-002-ai-powered-email-auto-replies/tree/master/resource/lambda/generate-email). Sau khi có file bạn có thể upload lên **Code** > **Upload from** > **.zip file**

Sự khác biệt là biến môi trường, IAM role (`GenerateEmailFunctionRole`) và memory là lớn hơn.

| Key                               | Value                          | Description                                             |
| --------------------------------- | ------------------------------ | ------------------------------------------------------- |
| `CUSTOMER_SERVICE_AGENT_ID`       | YOUR_AGENT_ID                  | The ID of the Amazon Bedrock Knowledge Base Agent       |
| `CUSTOMER_SERVICE_AGENT_ALIAS_ID` | YOUR_AGENT_ALIAS_ID            | The alias ID of the Amazon Bedrock Knowledge Base Agent |
| `KNOWLEDGE_BASE_ID`               | YOUR_KNOWLEDGE_BASE_ID         | The ID of the Amazon Bedrock Knowledge Base             |
| `RESPONSE_QUEUE_NAME`             | `sqs-send-email-to-customer-queue` | The name of the SQS queue for sending email responses   |

Chúng ta cần thêm memory và timeout

{{< img src="images/8.lambda/35.png" title="lambda35" >}}

Điều chỉnh thành `1024` và timeout là `30`s, Chọn **Save**
{{< img src="images/8.lambda/36.png" title="lambda36" >}}

#### Thông tin chi tiết

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

2. Local test, file này có thể dùng để test local, bạn có thể đọc `README.md` để biết cách sử dụng.

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

5. Product management agent, agent này sẽ đọc file faqs.txt để trả lời,...

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

6. Cuối cùng là Customer Service Agent. Agent này sẽ sử dụng dịch vụ mà chúng ta đã tạo ở mục 6

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