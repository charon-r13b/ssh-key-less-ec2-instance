# ssh-key-less-ec2-instance
Terraform configuration file to create an EC2 instance that can be accessed without an SSH key.

## Example

```hcl-terraform
module "instance" {
  source = "github.com/charon-r13b/ssh-key-less-ec2-instance"

  subnet_id = "[your-subnet-id]"
}
```
