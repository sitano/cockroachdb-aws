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
    node_instance_type = "i3en.2xlarge"
    loaders_instance_type = "c5.4xlarge"
    cluster_user_cidr = ["your_ip_address/32"]
    loaders = 5
    monitor = 1
    user_tags = {keep = "alive"}

Execute:

    $ terraform apply -var-file=.vars

Destroy:

    $ terraform destroy

Setup CockroachDB with Ansible:

1. Install community modules with:

    $ ansible-galaxy collection install community.general

2. Create an inventory file based on `inventory-example.yaml`
3. Create a playbook file based on `playbook-example.yaml`
4. Execute:

    $ ansible-playbook -i inventory.yaml playbook.yaml

5. Init cluster with

    $ cockroach init --insecure

# Custom user tags

    user_tags = {keep = "alive"}

# Note on the single disk raid

If you are using single NVMe you don't need MDADM:

    - name: configure storage
      hosts: nodes
      become: yes
      tasks:
        - community.general.filesystem:
            dev: '/dev/nvme1n1'
            fstype: 'xfs'
        - mount:
            src: '/dev/nvme1n1'
            path: '/var/lib/cockroachdb'
            fstype: xfs
            opts: 'noatime,nofail'
            state: mounted
      tags:
        - fs

If you are using single NVMe with MDADM please patch ansible role
by adding a flag `-force` to `ansible-mdadm/tasks/arrays.yml`:

    shell: "yes | mdadm --create /dev/{{ item.name }} --level={{ item.level }} --raid-devices={{ item.devices|count }} {{ item.devices| join (' ') }}"

    as in

    shell: "yes | mdadm --create /dev/{{ item.name }} --level={{ item.level }} --force --raid-devices={{ item.devices|count }} {{ item.devices| join (' ') }}"
