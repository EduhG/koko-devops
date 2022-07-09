variable "region" {
  description = "Default Region"
  default     = "eu-west-3"
}

variable "aws_access_key_id" {
  description = "AWS Access Key Id"
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Sectret Access Key"
  sensitive   = true
}

variable "iam_profile" {
  description = "IAM Profile to run terraform with"
  default     = "default"
}

variable "project_prefix" {
  description = "Name to use prefix all resource names with"
  default     = "koko-devops"
}

variable "project_title" {
  description = "Project title"
  default     = "Koko Devops"
}

variable "public_key_path" {
  description = "Location of public ssh key to use"
}

variable "private_key_path" {
  description = "Location of private ssh key to use in cicd server"
}

variable "cicd_instance_type" {
  description = "EC2 instance type"
  default     = "t3a.micro"
}

variable "volume_size" {
  description = "Attached EBS Volume size"
  type        = number
  default     = 20
}

variable "master_instance_type" {
  description = "EC2 instance type"
  default     = "t3a.micro"
}

variable "worker_instance_type" {
  description = "EC2 instance type"
  default     = "t3a.micro"
}

variable "workers_count" {
  description = "Number of workers to launch"
  default     = 0
}
