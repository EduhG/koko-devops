output "cicd-server-ip" {
  value = aws_instance.cicd.public_ip
}

output "master-server-ip" {
  value = aws_instance.master.public_ip
}

output "ecr-repo-url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}
