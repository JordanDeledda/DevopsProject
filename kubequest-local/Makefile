ANSIBLE_DIR=ansible
TF_DIR=terraform
ENV?=lab

deps:
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.yaml $(ANSIBLE_DIR)/playbooks/01-install-deps.yaml
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.yaml $(ANSIBLE_DIR)/playbooks/02-init-master.yaml
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.yaml $(ANSIBLE_DIR)/playbooks/03-join-workers.yaml

tf-init:
	cd $(TF_DIR) && terraform init

tf-apply:
	cd $(TF_DIR) && terraform apply -auto-approve -var-file=envs/$(ENV)/terraform.tfvars

tf-destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve -var-file=envs/$(ENV)/terraform.tfvars

all: deps tf-init tf-apply