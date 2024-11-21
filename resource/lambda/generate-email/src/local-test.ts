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
