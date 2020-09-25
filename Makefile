ansible:
	ansible-playbook -i .inv .playbook

terraform-apply:
	cd terraform && \
	terraform init && \
	terraform apply -var-file=.vars
