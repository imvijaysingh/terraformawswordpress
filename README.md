# terraformawswordpress
Terraform->AWS->Wordpress

About:

Following will get provision using Terraform.

  1. VPC and it's components
  2. Subnets, Route Tables, Internet Gateway, Nat Gateway.
  3. EC2 instance
  4. EIP for NAT Gateway
  5. Mariadb sql EC2 instance and wordpress EC2 instance
  6. Security Groups to access both EC2 and SQL

Usage: Provision:

terraform init
terraform plan
terraform apply -auto-approve

Destroy:
terraform destroy -auto-approve
