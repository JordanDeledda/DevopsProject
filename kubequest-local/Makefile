ANSIBLE_DIR=ansible
TF_DIR=terraform
ENV?=lab

deps:
\tansible-playbook -i $(ANSIBLE_DIR)/inventory.yaml $(ANSIBLE_DIR)/playbooks/01-install-deps.yaml
\tansible-playbook -i $(ANSIBLE_DIR)/inventory.yaml $(ANSIBLE_DIR)/playbooks/02-init-master.yaml
\tansible-playbook -i $(ANSIBLE_DIR)/inventory.yaml $(ANSIBLE_DIR)/playbooks/03-join-workers.yaml

tf-init:
\tcd $(TF_DIR) && terraform init

tf-apply:
\tcd $(TF_DIR) && terraform apply -auto-approve -var-file=envs/$(ENV)/terraform.tfvars

tf-destroy:
\tcd $(TF_DIR) && terraform destroy -auto-approve -var-file=envs/$(ENV)/terraform.tfvars

all: deps tf-init tf-apply