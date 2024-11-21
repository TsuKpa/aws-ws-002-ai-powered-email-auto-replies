import { BedrockLLMAgent, BedrockLLMAgentOptions } from "multi-agent-orchestrator";

export const emailFormatAgent = new BedrockLLMAgent({
    name: "Email Format Agent",
    description: "Format response to email, the format will be, 'Dear Customer, \n YOUR_RESPONSE_WILL_BE_HERE. \n 'Best regards,\n' Cat shop \n'",
    modelId: "anthropic.claude-3-haiku-20240307-v1:0",
    region: "us-east-1",
    saveChat: false
} as BedrockLLMAgentOptions); 
