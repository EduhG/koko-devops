output "cicd-server-ip" {
  value = aws_instance.cicd.public_ip
}

output "cluster-server-ip" {
  value = aws_instance.master.public_ip
}
