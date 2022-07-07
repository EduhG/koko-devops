init:
	terraform init

plan:
	terraform plan

apply:
	terraform apply

ssh-cicd:
	ssh -i ~/.ssh/aws-key ec2-user@$(shell terraform -chdir=. output -raw cicd-server-ip)

ssh-master:
	ssh -i ~/.ssh/aws-key ec2-user@$(shell terraform -chdir=. output -raw master-server-ip)
