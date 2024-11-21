import {
  BedrockClassifier,
  MultiAgentOrchestrator
} from 'multi-agent-orchestrator';
import { humanAgent } from './agents/human';
import { orderManagementAgent } from './agents/order-management';
import { productInfoAgent } from './agents/product-info';
import { customerServiceAgent } from './agents/customer-service';

const customBedrockClassifier = new BedrockClassifier({
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

export default orchestrator;