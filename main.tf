locals {
  ami_query_conditions = {
    amazon2 = {
      owners = ["amazon"],
      queries = [
        {
          name = "name",
          values = [
            "amzn2-ami-hvm-2.0.*-x86_64-gp2" # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/finding-an-ami.html
          ]
        }
      ]
    },
    ubuntu = {
      owners = ["099720109477"],
      queries = [
        {
          name = "name"
          values = [
            "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" # https://cloud-images.ubuntu.com/locator/ec2/
          ]
          # values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]  # Ubuntu Linux 18.04
        }
      ]
    },
    centos = {
      owners = ["aws-marketplace"],
      queries = [
        {
          name = "product-code",
          values = [
            "aw0evgkw8e5c1q413zgy5pjce" # CentOS 7, https://wiki.centos.org/Cloud/AWS
          ]
        }
      ]
    }
  }
}

data "aws_ami" "linux" {
  most_recent = true

  owners = local.ami_query_conditions[var.ami_os_type]["owners"]

  dynamic "filter" {
    for_each = local.ami_query_conditions[var.ami_os_type]["queries"]

    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  count              = var.iam_instance_profile_name != null ? 0 : 1
  name               = var.module_creation_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy" "systems_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.iam_instance_profile_name != null ? 0 : 1
  role       = aws_iam_role.role[count.index].name
  policy_arn = data.aws_iam_policy.systems_manager.arn
}

resource "aws_iam_instance_profile" "systems_manager" {
  count = var.iam_instance_profile_name != null ? 0 : 1
  name  = var.module_creation_iam_instance_profile_name
  role  = aws_iam_role.role[count.index].name
}

resource "aws_instance" "this" {
  ami                  = var.ami != null ? var.ami : data.aws_ami.linux.image_id
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile_name != null ? var.iam_instance_profile_name : aws_iam_instance_profile.systems_manager[0].name
  subnet_id            = var.subnet_id
}
