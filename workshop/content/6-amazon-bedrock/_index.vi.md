---
title : "Cấu hình Amazon Bedrock"
date :  "`r Sys.Date()`" 
weight : 6 
chapter : false
pre : " <b> 6. </b> "
---


{{< img src="images/6.bedrock/amazon-bedrock.webp" title="amazon bedrock logo" >}}

### Tổng quan

🤖 Amazon Bedrock là một dịch vụ dẫn đầu về foundation models (FMs) từ Amazon và third-party providers thông qua API.

✨ **Các tính năng chính:**
- Truy cập nhiều mô hình nền tảng hiệu suất cao từ các công ty AI hàng đầu thông qua một API duy nhất
- Xây dựng và mở rộng quy mô các ứng dụng AI tạo ra một cách an toàn với các tùy chỉnh riêng tư
- Tận dụng các biện pháp kiểm soát bảo mật và quyền riêng tư cấp doanh nghiệp
- Tạo các tác nhân có thể thực hiện các tác vụ kinh doanh phức tạp bằng cách kết hợp các mô hình nền tảng với logic kinh doanh
- Tinh chỉnh các mô hình bằng dữ liệu của riêng bạn trong khi vẫn duy trì quyền riêng tư của dữ liệu
- Triển khai các mô hình có tính khả dụng và hiệu suất cao ở quy mô lớn

🎯 **Các khả năng chính bao gồm:**
- Tạo văn bản
- Tạo mã
- Tạo hình ảnh
- Nhúng
- Trả lời câu hỏi
- Tóm tắt
- Phân loại
- Knowledge base cho các ứng dụng RAG

🚀 **Foundation models**
- Amazon Titan
- Anthropic Claude
- AI21 Labs Jurassic
- Stability AI
- Cohere Command

🔧 **Tính năng doanh nghiệp:**
- Tùy chỉnh và tinh chỉnh riêng tư
- Đánh giá và thử nghiệm mô hình
- Giám sát và khả năng quan sát
- Kiểm soát bảo mật và truy cập
- Tối ưu hóa chi phí

### Retrieval Augmented Generation (RAG)

{{< img src="images/6.bedrock/rag.jpg" title="rag" >}}

**Retrieval-Augmented Generation (RAG)** là quá trình tối ưu hóa đầu ra của một mô hình ngôn ngữ lớn, do đó nó tham chiếu đến một knowledge base có thẩm quyền bên ngoài các nguồn dữ liệu đào tạo của nó trước khi tạo ra phản hồi. Trong workshop này, chúng ta sẽ sử dụng kỹ thuật này để tạo ra một agent dịch vụ khách hàng dựa trên tài liệu faqs.

#### Lợi ích của RAG:

- **Độ chính xác được cải thiện**: RAG giúp giảm sai lệch thông tin bằng cách đưa phản hồi vào các nguồn kiến ​​thức đã được xác minh

- **Thông tin cập nhật**: Cho phép các mô hình truy cập thông tin hiện tại sau ngày kết thúc đào tạo của chúng

- **Chuyên môn về miền**: Có thể kết hợp các knowledge base chuyên biệt và tài liệu cho các phản hồi cụ thể theo miền

- **Hiệu quả về chi phí**: Hiệu quả hơn so với việc tinh chỉnh các mô hình vì chỉ cần cập nhật knowledge base

- **Quyền riêng tư dữ liệu**: Lưu trữ dữ liệu nhạy cảm trong các knowledge base được kiểm soát thay vì nhúng dữ liệu đó vào trọng số mô hình

- **Các nguồn có thể xác minh**: Các phản hồi có thể được truy ngược lại các tài liệu nguồn để xác thực

- **Tùy chỉnh**: Dễ dàng tùy chỉnh đầu ra của mô hình bằng cách sửa đổi knowledge base

- **Giảm đào tạo**: Không cần đào tạo lại hoặc tinh chỉnh các mô hình khi thông tin thay đổi

- **Khả năng mở rộng**: Có thể cập nhật knowledge base độc lập với mô hình

- **Tuân thủ**: Kiểm soát tốt hơn các nguồn thông tin để tuân thủ quy định

#### Prompt Engineering

**Prompt engineering** là kĩ thuật dùng để thiết kế và điều chỉnh prompt khi sử dụng với AI model. Một propmt template sẽ có:

1. **Hướng dẫn rõ ràng**
- Cụ thể và rõ ràng về đầu ra mong muốn
- Chia nhỏ các nhiệm vụ phức tạp thành các bước nhỏ hơn
- Bao gồm các ví dụ khi hữu ích

2. **Thiết lập ngữ cảnh**
- Cung cấp thông tin cơ bản có liên quan
- Xác định vai trò/nhân vật mà mô hình nên áp dụng
- Chỉ định định dạng của phản hồi mong đợi

3. **Ràng buộc và tham số**
- Đặt ranh giới cho phản hồi
- Chỉ định bất kỳ hạn chế hoặc yêu cầu nào
- Bao gồm tiêu chí xác thực

```txt
Role: {specify the role/persona}
Context: {provide relevant background}
Task: {clear instruction of what to do}
Format: {specify output format}
Constraints: {list any limitations}
Examples: {provide sample input/output}
```
Ví dụ:
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

Đối với những yêu cầu phức tạp hơn, bạn có thể thêm lịch sử trò chuyện với người dùng vào prompt, nhưng điều này cần nhiều token hơn. Trong workshop này, để đơn giản và giảm chi phí, tôi chỉ tạo một prompt ngắn để thực hiện một việc gì đó và sau đó trả lời qua email.

### Nội dung

6.1. [Request models](6.1-request-model/)\
6.2. [Tạo Knowledge base](6.2-create-knowledge-base/)\
6.3. [Tạo Agent Alias](6.3-create-agent-alias/)
