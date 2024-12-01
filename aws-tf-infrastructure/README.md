# Infrastructure for the Text-to-Speech App  

This directory contains the Terraform files that define the infrastructure for the application.  

## modules  
- **`modules/`**: Contains reusable Terraform modules that define specific infrastructure components.  

## Outputs  
The **`output.tf`** file provides the following outputs:  
- **`cognito_identity_pool_id`**: The ID of the Cognito Identity Pool.  
- **`api_gateway_endpoint`**: The endpoint for the API Gateway.  

These outputs should be passed to the React app as environment variables.  

### Setting Environment Variables  
- You can **manually copy** the output values into the React app's configuration.  
- Alternatively, in a **CI/CD pipeline**, you can use a configuration management tool like **Ansible** to set them automatically.

## Variables  
The **`variables.tf`** file contains a single variable:  
- **`region`**: Specifies the AWS region where the infrastructure will be deployed.

## Provisioning the Infrastructure  
To provision the infrastructure, navigate to the `aws-tf-infrastructure` folder and run:

```bash
terraform apply
