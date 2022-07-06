init:
	terraform init

plan:
	terraform plan

apply:
	terraform apply

ssh-cicd:
	ssh ec2-user@$(shell terraform -chdir=. output -raw cicd-server-ip)
