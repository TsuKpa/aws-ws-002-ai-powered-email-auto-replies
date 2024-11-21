import { BedrockAgentRuntimeClient } from '@aws-sdk/client-bedrock-agent-runtime';
import { AmazonKnowledgeBasesRetriever, BedrockLLMAgent, BedrockLLMAgentOptions } from "multi-agent-orchestrator";
import { env } from '../environment';

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
