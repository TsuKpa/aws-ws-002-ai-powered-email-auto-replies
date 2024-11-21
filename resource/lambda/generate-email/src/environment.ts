import * as dotenv from "dotenv";
dotenv.config();

export const env = {
    ENV: process.env.ENV || "prod",
    CUSTOMER_SERVICE_AGENT_ID: process.env.CUSTOMER_SERVICE_AGENT_ID || "",
    CUSTOMER_SERVICE_AGENT_ALIAS_ID: process.env.CUSTOMER_SERVICE_AGENT_ALIAS_ID || "",
    KNOWLEDGE_BASE_ID: process.env.KNOWLEDGE_BASE_ID || "",
    RESPONSE_QUEUE_NAME: process.env.RESPONSE_QUEUE_NAME || ""
}
