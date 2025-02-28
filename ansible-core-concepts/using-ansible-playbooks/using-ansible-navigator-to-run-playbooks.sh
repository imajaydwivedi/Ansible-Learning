:<<'USING_ANSIBLE_NAVIGATOR_TO_RUN_PLAYBOOK'

Using ansible-navigator to Run Playbooks
---------------------------------------------

-> "ansible-navigator run -m stdout --pp never vsftpd.yml" will run the playbook using navigator,
  -> "-m stdout" will write output to STDOUT instead of using interactive mode
  -> "--pp never" will not check for newer container images

ansible-navigator run -m stdout ./ansible-core-concepts/using-ansible-playbooks/example.yml

-> "ansible-navigator run --pp never vsftpd.yml" will run the playbook in interactive mode
  -> Use the indicated numbers to get more details about each step

ansible-navigator run ./ansible-core-concepts/using-ansible-playbooks/example.yml

USING_ANSIBLE_NAVIGATOR_TO_RUN_PLAYBOOK

