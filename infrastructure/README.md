# Running Terraform Locally with AWS Credentials

This guide explains how to set up and run Terraform locally using AWS credentials stored as environmental variables.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
- An AWS account with appropriate permissions

## Setting Up AWS Credentials

To run Terraform with your AWS account, you need to provide your AWS credentials. For security reasons, it's recommended to use environmental variables instead of hardcoding these credentials in your Terraform files.

### Step 1: Set Environmental Variables

Open your terminal and set the following environmental variables from your AWS account:

```bash
export AWS_ACCESS_KEY_ID="your_access_key_id"
export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
export AWS_DEFAULT_REGION="your_preferred_region"
```

Replace `your_access_key_id`, `your_secret_access_key`, and `your_preferred_region` with your actual AWS credentials and preferred region (e.g., `us-west-2`).

## Running Terraform

Once your credentials are set up, you can run Terraform commands as usual:

1. Navigate to your Terraform project directory:

   ```bash
   cd /path/to/your/terraform/project
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Plan your infrastructure:

   ```bash
   terraform plan
   ```

4. Apply your configuration:
   ```bash
   terraform apply
   ```

## Best Practices

- Never commit AWS credentials to version control
- Rotate your AWS access keys regularly
- Use least-privilege permissions for your AWS user/role
- Consider using AWS IAM roles for production environments

## Troubleshooting

If you encounter authentication issues:

- Ensure your environmental variables are correctly set (`env | grep AWS`)
- Check that your AWS credentials are valid and have the necessary permissions
- Verify that your Terraform AWS provider configuration matches your setup

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

Remember to always follow security best practices when handling AWS credentials!
