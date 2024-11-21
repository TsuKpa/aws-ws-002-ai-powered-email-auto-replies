import { AmazonBedrockAgent, AmazonBedrockAgentOptions } from "multi-agent-orchestrator";
import { env } from "../environment";

export const customerServiceAgent = new AmazonBedrockAgent({
    name: "Customer Service Agent BedRock",
    description: "Handles general customer inquiries, account-related questions, and non-technical support requests. Uses comprehensive customer service knowledge base.",
    agentId: env.CUSTOMER_SERVICE_AGENT_ID,
    agentAliasId: env.CUSTOMER_SERVICE_AGENT_ALIAS_ID,
    saveChat: false,
    region: "us-east-1"
} as AmazonBedrockAgentOptions); 
