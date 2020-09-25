# terraform-aws-scylla

Terraform module for building CockroachDB cluster infrastructure on AWS.

# Usage

Build and execute infrastructure with Terraform:

    $ cd terraform

Define variables in `.vars`:

    aws_access_key = ""
    aws_secret_key = ""
    aws_region = "eu-north-1"
    owner = "user"
    cluster_user_cidr = ["your_ip_address/32"]

Execute:

    $ terraform apply -var-file=.vars

Destroy:

    $ terraform destroy

Setup CockroachDB with Ansible:

1. Create an inventory file based on `inventory-example.yaml`
2. Create a playbook file based on `playbook-example.yaml`
3. Execute:

    $ ansible-playbook -i inventory.yaml playbook.yaml
    
# Note on the single disk raid

If you are using single NVMe with MDADM please patch ansible role
by adding a flag `-force` to `ansible-mdadm/tasks/arrays.yml`:
    
    shell: "yes | mdadm --create /dev/{{ item.name }} --level={{ item.level }} --raid-devices={{ item.devices|count }} {{ item.devices| join (' ') }}"
    
    as in
    
    shell: "yes | mdadm --create /dev/{{ item.name }} --level={{ item.level }} --force --raid-devices={{ item.devices|count }} {{ item.devices| join (' ') }}"
