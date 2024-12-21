---
title : "Setup Amazon Bedrock"
date :  "`r Sys.Date()`" 
weight : 6 
chapter : false
pre : " <b> 6. </b> "
---


{{< img src="images/6.bedrock/amazon-bedrock.webp" title="amazon bedrock logo" >}}

### Overview

🤖 Amazon Bedrock is a fully managed service that makes leading foundation models (FMs) from Amazon and third-party providers accessible via an API. It enables developers to:

✨ **Key Features:**
- Access a choice of high-performing foundation models from leading AI companies through a single API
- Build and scale generative AI applications securely with private customizations 
- Leverage enterprise-grade security and privacy controls
- Create agents that can execute complex business tasks by combining foundation models with business logic
- Fine-tune models with your own data while maintaining data privacy
- Deploy models with high availability and performance at scale

🎯 **Key capabilities include:**
- Text generation
- Code generation 
- Image generation
- Embeddings
- Question answering
- Summarization
- Classification
- Knowledge bases for RAG applications

🚀 **Foundation models available through Bedrock include:**
- Amazon Titan
- Anthropic Claude
- AI21 Labs Jurassic
- Stability AI
- Cohere Command

🔧 **Enterprise features:**
- Private customization and fine-tuning
- Model evaluation and testing
- Monitoring and observability
- Security and access controls
- Cost optimization

### Retrieval Augmented Generation (RAG)

{{< img src="images/6.bedrock/rag.jpg" title="rag" >}}

**Retrieval-Augmented Generation (RAG)** is the process of optimizing the output of a large language model, so it references an authoritative knowledge base outside of its training data sources before generating a response. In this workshop we will use this technical to create an customer service agent based on our faqs document.

#### Benefits of RAG:

- **Improved Accuracy**: RAG helps reduce hallucinations by grounding responses in verified knowledge sources

- **Up-to-date Information**: Allows models to access current information beyond their training cutoff date

- **Domain Expertise**: Can incorporate specialized knowledge bases and documentation for domain-specific responses

- **Cost Efficiency**: More efficient than fine-tuning models since only the knowledge base needs to be updated

- **Data Privacy**: Keeps sensitive data in controlled knowledge bases rather than embedding it in model weights

- **Verifiable Sources**: Responses can be traced back to source documents for validation

- **Customization**: Easy to customize model outputs by modifying the knowledge base

- **Reduced Training**: No need to retrain or fine-tune models when information changes

- **Scalability**: Knowledge bases can be updated independently of the model

- **Compliance**: Better control over information sources for regulatory compliance

#### Prompt Engineering

**Prompt engineering** is the art of designing and refining prompts to elicit the desired response from an AI model. A prompt template will be:

1. **Clear Instructions**
- Be specific and explicit about the desired output
- Break complex tasks into smaller steps
- Include examples when helpful

2. **Context Setting**
- Provide relevant background information
- Define the role/persona the model should adopt
- Specify the format of the expected response

3. **Constraints and Parameters**
- Set boundaries for the response
- Specify any limitations or requirements
- Include validation criteria

```txt
Role: {specify the role/persona}
Context: {provide relevant background}
Task: {clear instruction of what to do}
Format: {specify output format}
Constraints: {list any limitations}
Examples: {provide sample input/output}
```
Example:
```txt
Role: Act as a technical documentation writer specializing in cloud computing
Context: Writing AWS service documentation for a beginner audience
Task: Create a step-by-step guide explaining how to launch an EC2 instance
Format: Numbered steps with bullet points for sub-steps, include relevant AWS console screenshots
Constraints: 
- Keep language simple and beginner-friendly
- Maximum 10 main steps
- Include security best practices
- Focus only on Linux instances
Examples:
Input: Need instructions for launching EC2
Output:
1. Sign in to AWS Console
   • Navigate to console.aws.amazon.com
   • Enter your credentials
2. Open EC2 Dashboard
   • Click "Services" dropdown
   • Select "EC2" under Compute
[etc...]
```

For more complex, you can add an history chat with an user to the prompt, but this required more token. In this workshop, for simple i just create an simple prompt to do something and then response via email.

### Content

6.1. [Request models](6.1-request-model/)\
6.2. [Create Knowledge base](6.2-create-knowledge-base/)\
6.3. [Create Agent Alias](6.3-create-agent-alias/)
