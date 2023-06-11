# AWS Cloud Practice

This repository consist of my hands on examples to learn and practice the AWS services.

**Learning Tips:**

- Use AWS Management Console to complete each lab
- Then write Terraform code to provision the infrastructure
- Then `terraform destroy` to clean up

# Terraform Code Structure

Depends on different labs, we will choose different code structure. See more [Terraform code structure](https://www.terraform-best-practices.com/examples/terraform)

## Small-size infrastructure

Everything is simple and a good start for proof of concepts, hobby projects and resource modules.

- Perfect to get started and refactor as you go
- Perfect for small resource modules
- Good for small and linear infrastructure modules (eg, terraform-aws-atlantis)
- Good for a small number of resources (fewer than 20-30)

## Medium-size infrastructure

- Perfect for projects where infrastructure is logically separated (separate AWS accounts)
- Good when there is no is need to modify resources shared between AWS accounts (one environment = one AWS account = one state file)
- Good when there is no need in the orchestration of changes between the environments
- Good when infrastructure resources are different per environment on purpose and can't be generalized (eg, some resources are absent in one environment or in some regions)

## Large-size infrastructure

- Perfect for projects where infrastructure is logically separated (separate AWS accounts)
- Good when there is no is need to modify resources shared between AWS accounts (one environment = one AWS account = one state file)
- Good when there is no need for the orchestration of changes between the environments
- Good when infrastructure resources are different per environment on purpose and can't be generalized (eg, some resources are absent in one environment or in some regions)

# Tools

- [Terraform](https://www.terraform.io/)
- [Draw.io](https://www.draw.io/)
- [Cloudcraft](https://www.cloudcraft.co/)
- [tflint](https://github.com/terraform-linters/tflint)
