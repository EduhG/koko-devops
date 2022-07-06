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

resource "aws_security_group" "cicd_sg" {
  name   = "${var.project_prefix}-cicd-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Jenkins web access from anywhere"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow outbound traffic"

  }

  tags = merge(local.tags, { Name = "${var.project_title} CICD SG" })
}

resource "aws_instance" "cicd" {
  ami = data.aws_ami.amazon_linux_x86_64.id

  instance_type               = var.cicd_instance_type
  subnet_id                   = data.aws_subnet.default.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.profile.id

  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  key_name               = aws_key_pair.ssh_key.key_name

  root_block_device {
    volume_type = "gp3"
    volume_size = var.volume_size
  }

  user_data_replace_on_change = true
  user_data                   = data.template_cloudinit_config.cicd_config.rendered

  tags = merge(local.tags, { Name = "${var.project_title} CICD Server" })
}
