output "knowledge_base_id" {
  value = aws_bedrockagent_knowledge_base.email_auto_reply_kb.id
  description = "Knowledge base id used for generate email content lambda"
}

output "agent_id" {
    value = aws_bedrockagent_agent.customer_service_agent.agent_id
    description = "Agent id used for generate email content lambda"
}

output "alias_id" {
    value = aws_bedrockagent_agent_alias.email_agent_alias.agent_alias_id
    description = "Alias id used for generate email content lambda"
}
