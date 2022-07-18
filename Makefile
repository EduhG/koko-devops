dev:
	poetry run python manage.py

prod:
	poetry run gunicorn -c python:app.config.gunicorn manage:app

test:
	pytest -v

plan:
	cd devops/infra && terraform plan

apply:
	cd devops/infra && terraform apply

ssh-cicd:
	ssh -i ~/.ssh/aws-key ec2-user@$(shell terraform -chdir=devops/infra output -raw cicd-server-ip)

ssh-master:
	ssh -i ~/.ssh/aws-key ec2-user@$(shell terraform -chdir=devops/infra output -raw master-server-ip)