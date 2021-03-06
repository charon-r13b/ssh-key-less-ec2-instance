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
  count              = var.create_iam ? 1 : 0
  name               = var.creation_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy" "systems_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.create_iam ? 1 : 0
  role       = aws_iam_role.role[count.index].name
  policy_arn = data.aws_iam_policy.systems_manager.arn
}

resource "aws_iam_instance_profile" "systems_manager" {
  count = var.create_iam ? 1 : 0
  name  = var.creation_iam_instance_profile_name
  role  = aws_iam_role.role[count.index].name
}

resource "aws_instance" "this" {
  ami                  = var.ami != null ? var.ami : data.aws_ami.linux.image_id
  instance_type        = var.instance_type
  iam_instance_profile = var.create_iam ? aws_iam_instance_profile.systems_manager[0].name : var.iam_instance_profile_name
  subnet_id            = var.subnet_id

  vpc_security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : [aws_security_group.this[0].id]

  user_data = var.user_data != null ? var.user_data : null

  root_block_device {
    volume_size = var.root_block_volume_size
  }
}

resource "aws_security_group" "this" {
  count = length(var.security_group_ids) == 0 ? 1 : 0

  name   = var.creation_security_group_name
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "egress" {
  count = length(var.security_group_ids) == 0 ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this[0].id
}
