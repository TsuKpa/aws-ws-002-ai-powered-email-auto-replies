import { BedrockLLMAgent, BedrockLLMAgentOptions, ConversationMessage, ParticipantRole } from "multi-agent-orchestrator";
import { orderLookup, returnProcessor, shipmentTracker } from "../db";

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
