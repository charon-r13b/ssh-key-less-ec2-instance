variable "ami" {
  description = "作成するEC2のAMI。OSの種類から最新のAMIを選ぶ場合は、ami_os_typeで指定する"
  type        = string
  default     = null
}

variable "ami_os_type" {
  description = "作成するEC2をどのOSで行うか。amazon2、ubuntu、centosの3つが指定可能で、最新のAMIを選択する"
  type        = string
  default     = "amazon2"
}

variable "subnet_id" {
  description = "このEC2インスタンスを配置するサブネットID"
  type        = string
}

variable "security_group_ids" {
  description = "このEC2インスタンスに付与する、セキュリティグループ。指定しない場合は、アウトバウンドのみを許可するセキュリティグループを作成して付与する"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "このEC2インスタンスを配置する、VPC ID。セキュリティグループをモジュール側で作成する場合、必須"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User Dataを指定する"
  type        = string
  default     = null
}

variable "creation_security_group_name" {
  description = "このモジュール側でセキュリティグループを作成する場合の、セキュリティグループ名"
  type        = string
  default     = "my-ssh-key-less-instance-sg"
}

variable "instance_type" {
  description = "EC2インスタンスタイプ"
  type        = string
  default     = "t2.micro"
}

variable "root_block_volume_size" {
  description = "EC2のルートボリュームサイズ"
  type        = number
  default     = null
}

variable "iam_instance_profile_name" {
  description = "作成するEC2インスタンスに与えるIAMインスタンスプロファイル名。指定しない場合は、必要最低限のIAMロールおよびIAMインスタンスプロファイルをモジュール側で作成する"
  type        = string
  default     = null
}

variable "create_iam" {
  description = "このモジュールでIAMロール、インスタンスプロファイルを作成する場合はtrueを指定する"
  type        = bool
  default     = true
}

variable "creation_iam_role_name" {
  description = "このモジュール側でIAMロールを作成する場合の、IAMロール名"
  type        = string
  default     = "MySshKeyLessEc2Role"
}

variable "creation_iam_instance_profile_name" {
  description = "このモジュール側でIAMインスタンスプロファイルを作成する場合の、IAMインスタンスプロファイル名"
  type        = string
  default     = "MySshKeyLessEc2InstanceProfile"
}