:<<'COMMONLY_USED_ANSIBLE_MODULES_COMMENTS'

Commonly Used Ansible Modules
---------------------------------

-> "command": runs arbitrary commands without using a shell

-> "shell": runs arbitrary commands while using a shell

-> "raw": runs commands directly on top of SSH without requiring Python

-> "copy": copies files or lines of text to files

-> "package": manages software packages on any managed Linux hosts

-> "yum": manages software packages on yum-based systems
-> "dnf": manages software packages on dnf-based systems

-> "apt": manages software packages on apt-based systems

-> "service": manages current state of packages

-> "ping": verifies host availability

-> "file": manages files

-> "user": manages users


Demo: Command versus Shell
------------------------------------------------

-> Use
ansible server_ansible -m command -a "rpm -qa | grep python"

-> Observe the command output, did it work? Notice if "grep" command was able to filter the result or not?

-> Use
ansible server_ansible -m shell -a "rpm -qa | grep python"

-> Use below command to Displaying banner after login on managed hosts
ansible all -m copy -a 'content="Hello! Hope you are enjoying Ansible." dest=/etc/motd'

  :<<'ABOVE_COMMAND_VERIFICATION'

  (base) ----- [2025-Jan-22 18:24:23] saanvi@ryzen9 (Ansible-Learning)
  |------------$ ssh ansible@server_ansible
  Hello! Hope you are enjoying Ansible.
  Last login: Wed Jan 22 18:23:49 2025 from 192.168.100.1
  [ansible@serveransible ~]$ exit
  logout
  Connection to server_ansible closed.
  (base) ----- [2025-Jan-22 18:24:37] saanvi@ryzen9 (Ansible-Learning)

ABOVE_COMMAND_VERIFICATION

-> Use
ansible ansible_vms -m package -a "name=nmap state=latest"

-> Use
ansible ansible_vms -m service -a "name=httpd state=started enabled=yes"


COMMONLY_USED_ANSIBLE_MODULES_COMMENTS

