# 📌 Use Case Documentation: Voice Synthesis Application

## 1️⃣ Overview
The Voice Synthesis Application is a **React-based web application** hosted on **Amazon EC2**. It allows users to input text and generate synthesized speech using **Amazon Polly**. Users can select different languages, voice engines, and **SSML (Speech Synthesis Markup Language)** features for better speech control.

Previously synthesized audio is **stored in Amazon S3**, with **metadata in Amazon DynamoDB** for efficient retrieval.

## 2️⃣ System Architecture
The architecture ensures **scalability, security, and high availability** using AWS services.

### **🎨 Frontend (React Application)**
- Hosted on **Amazon EC2** within a **private subnet**.
- Part of a **Target Group** managed by an **Auto Scaling Group**.
- Secured with **Security Groups**.
- Provides a UI for users to input text and synthesize speech.

### **🌐 Load Balancing & User Access**
- Users access the application through an **Application Load Balancer (ALB)**.
- **AWS WAF** is attached to the ALB to **protect against common web threats**.
- **Amazon Cognito** manages authentication:
  - **Authenticated users** (Cognito User Pools) can synthesize and retrieve previous voices.
  - **Anonymous users** (Cognito Identity Pools) can only synthesize voices without storage.

### **⚙ Backend (AWS Lambda & Polly)**
- The frontend calls **AWS Lambda** via **Amazon API Gateway**.
- The Lambda function processes text and sends it to **Amazon Polly**.
- Polly returns the synthesized speech as an **audio file**.

### **💾 Data Storage & Retrieval**
- **Synthesized audio is stored in Amazon S3** instead of DynamoDB (to handle large files).
- **DynamoDB stores metadata** (audio file paths, user details).
- Users retrieve **stored voices** via API Gateway.

### **🔗 Network Enhancements**
- **NAT Gateway** is added to **allow EC2 instances in private subnets** to access AWS services (e.g., API Gateway, Polly, S3) **without exposing them to the public internet**.

## 3️⃣ User Workflow
1. **🔐 User Authentication**  
   - The user logs in via **Amazon Cognito**.

2. **📝 Text Input & Voice Synthesis Request**  
   - The user enters text and selects synthesis options.
   - The request is sent to **Lambda** via **API Gateway**.

3. **⚡ Processing the Request**  
   - Lambda sends the request to **Amazon Polly**.
   - Polly returns the synthesized speech.

4. **📂 Storing the Audio File**  
   - The Lambda function **stores the audio file in Amazon S3**.
   - **Metadata is saved in DynamoDB**.

5. **🔊 Retrieving Stored Voices**  
   - Users can fetch previously synthesized voices via API Gateway.

## 4️⃣ Security Considerations
- **🛡 AWS WAF** protects the **ALB from malicious traffic** (e.g., SQL injection, XSS).
- **🔒 EC2 runs in a private subnet** for security.
- **🚪 Security Groups** limit inbound/outbound traffic.
- **🔑 IAM Roles and Policies** restrict access for Lambda, Polly, and DynamoDB.
- **🌍 NAT Gateway** ensures **private EC2 instances can access AWS services securely**.

## 5️⃣ Scalability & Performance
- **📈 Auto Scaling Group** ensures **EC2 instances scale based on demand**.
- **⚡ AWS Lambda is serverless**, automatically handling concurrent requests.
- **🎵 Amazon S3 scales storage capacity** for audio files.
- **📊 DynamoDB provides fast metadata retrieval**.

## 6️⃣ AWS Services Used

| Service              | Purpose                                      |
|----------------------|----------------------------------------------|
| **EC2**             | Hosts the React frontend in a private subnet |
| **ALB**             | Routes user traffic to EC2                   |
| **AWS WAF**         | Protects the application from threats        |
| **Amazon Cognito**  | Manages user authentication                  |
| **AWS Lambda**      | Processes requests & interacts with Polly    |
| **Amazon Polly**    | Converts text into speech                    |
| **Amazon API Gateway** | Routes frontend requests to the backend   |
| **Amazon S3**       | Stores synthesized audio files               |
| **Amazon DynamoDB** | Stores metadata for fast retrieval           |
| **NAT Gateway**     | Allows private EC2 instances to access AWS services |
| **Security Groups** | Restrict access to EC2 and other resources   |

## 7️⃣ Conclusion
This updated architecture improves **security, scalability, and efficiency** by:
- Storing **large audio files in Amazon S3** instead of DynamoDB.
- Adding **AWS WAF** to protect the web tier.
- Using a **NAT Gateway** for secure AWS service access.

This design ensures **high availability, cost efficiency, and strong security** while providing an optimized voice synthesis experience.
