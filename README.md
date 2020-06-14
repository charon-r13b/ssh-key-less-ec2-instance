# ssh-key-less-ec2-instance
Terraform configuration file to create an EC2 instance that can be accessed without an SSH key.

## Example

```hcl-terraform
module "instance" {
  source = "github.com/charon-r13b/ssh-key-less-ec2-instance"

  vpc_id = "[your-vpc-id]"

  subnet_id = "[your-subnet-id]"

  # ami_os_type = "amazon2"  # default
  # ami_os_type = "ubuntu
}
```
