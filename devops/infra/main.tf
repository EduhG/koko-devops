provider "aws" {
  region  = var.region
  profile = var.iam_profile
}

resource "aws_default_vpc" "default" {}

# ====================================================================
# EC2 INSTANCES
# ====================================================================

resource "aws_iam_role" "role" {
  name               = "${var.project_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = merge(local.tags, { Name = "${var.project_title} IAM Role" })
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.project_prefix}-profile"
  role = aws_iam_role.role.name

  tags = merge(local.tags, { Name = "${var.project_title} EC2 Instance Profiile" })
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.project_prefix}-ssh-key"
  public_key = file(var.public_key_path)

  tags = merge(local.tags, { Name = "${var.project_title} SSH Key" })
}
