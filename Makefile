dev:
	poetry run python manage.py

prod:
	poetry run gunicorn manage:app --workers 2 --bind 0.0.0.0:5000 --timeout 30 --log-level=DEBUG

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