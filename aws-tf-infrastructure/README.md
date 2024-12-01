# <span style="color:#4CAF50;">Infrastructure for the Text-to-Speech App</span>  

This directory contains the Terraform files that define the infrastructure for the application.  

## <span style="color:#673AB7;">modules</span>  
- <span style="color:#009688;"><strong>`modules/`</strong></span>: Contains reusable Terraform modules that define specific infrastructure components.  

## <span style="color:#673AB7;">Outputs</span>  
The <span style="color:#009688;"><strong>`output.tf`</strong></span> file provides the following outputs:  
- <span style="color:#FF5722;"><strong>`cognito_identity_pool_id`</strong></span>: The ID of the Cognito Identity Pool.  
- <span style="color:#FF5722;"><strong>`api_gateway_endpoint`</strong></span>: The endpoint for the API Gateway.  

These outputs should be passed to the React app as environment variables.  

### <span style="color:#FF5722;">Setting Environment Variables</span>  
- You can <span style="color:#FF9800;"><strong>manually copy</strong></span> the output values into the React app's configuration.  
- Alternatively, in a <span style="color:#FF9800;">CI/CD pipeline</span>, you can use a configuration management tool like <span style="color:#009688;"><strong>Ansible</strong></span> to set them automatically.

## <span style="color:#673AB7;">Variables</span>  
The <span style="color:#009688;"><strong>`variables.tf`</strong></span> file contains a single variable:  
- <span style="color:#FF5722;"><strong>`region`</strong></span>: Specifies the AWS region where the infrastructure will be deployed.

## <span style="color:#673AB7;">Provisioning the Infrastructure</span>  
To provision the infrastructure, navigate to the <span style="color:#FF5722;"><strong>`aws-tf-infrastructure`</strong></span> folder and run:

```bash
terraform apply
