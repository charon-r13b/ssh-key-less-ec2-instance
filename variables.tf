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

variable "instance_type" {
  description = "EC2インスタンスタイプ"
  type        = string
  default     = "t2.micro"
}

variable "iam_instance_profile_name" {
  description = "作成するEC2インスタンスに与えるIAMインスタンスプロファイル名。指定しない場合は、必要最低限のIAMロールおよびIAMインスタンスプロファイルをモジュール側で作成する"
  type        = string
  default     = null
}

variable "module_creation_iam_role_name" {
  description = "このモジュール側でIAMロールを作成する場合の、IAMロール名"
  type        = string
  default     = "MySshKeyLessEc2Role"
}

variable "module_creation_iam_instance_profile_name" {
  description = "このモジュール側でIAMインスタンスプロファイルを作成する場合の、IAMインスタンスプロファイル名"
  type        = string
  default     = "MySshKeyLessEc2InstanceProfile"
}