import { Agent, ConversationMessage, ParticipantRole } from "multi-agent-orchestrator";

export class HumanAgent extends Agent {
    async processRequest(inputText: string, userId: string, sessionId: string, chatHistory: ConversationMessage[]): Promise<ConversationMessage> {
        console.log(`Human agent received request: ${inputText}`);
        const humanResponse = await this.simulateHumanResponse(inputText);
        return {
            role: ParticipantRole.ASSISTANT,
            content: [{ text: humanResponse }]
        };
    }

    private async simulateHumanResponse(input: string): Promise<string> {
        console.log(`Sending email to SQS queue: "${input}"`);
        return `Your request has been received and will be processed by our customer service team. We'll get back to you as soon as possible.`;
    }
}

export const humanAgent = new HumanAgent({
    name: "Human Agent",
    description: "Handles complex inquiries, complaints, or sensitive issues requiring human expertise.",
    saveChat: false,
});
