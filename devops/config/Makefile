default:
	ansible-playbook -i aws_ec2.yaml playbooks/ping.yaml
	ansible-playbook -i aws_ec2.yaml playbooks/dependencies.yaml
	ansible-playbook -i aws_ec2.yaml playbooks/master_node.yaml
	ansible-playbook -i aws_ec2.yaml playbooks/worker_nodes.yaml
