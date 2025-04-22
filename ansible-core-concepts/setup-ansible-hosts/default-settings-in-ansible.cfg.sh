:<<'DEFINING_DEFAULT_SETTINGS_HELP'

Defining Default Settings in ansible.cfg
---------------------------------------------

-> Default settings can be provided through /etc/ansible/ansible.cfg

-> If this generic ansible.cfg exists, it applied to all Ansible projects.

-> A more specific ansible.cfg can be provided in the Ansible project directory.

-> If a more specific ansible.cfg exists, its settings will be used and the generic
    ansible.cfg in /etc/ansible will be ignored.

-> To override settings from ansible.cfg, they can be specified as command line options.

-> Use "ansible --version" to find out which ansible.cfg is used.

[!TIP] Use "ansible-config init -t all > example-ansible.cfg" to generate an example
    file containing all parameters.


DEFINING_DEFAULT_SETTINGS_HELP

# get ansible.cfg content in current project
cat ansible.cfg

    :<<'ANSIBLE_CFG_CONTENT'

[defaults]
interpreter_python = auto_legacy_silent

remote_user = ansible
host_key_checking = false
inventory = inventory

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = false


ANSIBLE_CFG_CONTENT

# Run following command without command line parameters
ansible all -a "ls -l /root"

    :<<'ANSIBLE_COMMAND_OUTPUT'
  (base) ----- [2025-Jan-18 17:18:27] saanvi@ryzen9 (Ansible-Learning)
  |------------$ ansible all -a "ls -l /root"
  pgprod | CHANGED | rc=0 >>
  total 8
  -rw-------. 1 root root 688 Jan  5 10:41 anaconda-ks.cfg
  -rw-r--r--. 1 root root 733 Jan  5 10:43 initial-setup-ks.cfg
  server_rhel | CHANGED | rc=0 >>
  total 4
  -rw-------. 1 root root 706 Dec  5 17:47 anaconda-ks.cfg
  server_ansible | CHANGED | rc=0 >>
  total 4
  -rw-------. 1 root root 706 Dec  7 12:54 anaconda-ks.cfg
  server_centos | CHANGED | rc=0 >>
  total 4
  -rw-------. 1 root root 1023 Dec  5 17:42 anaconda-ks.cfg
  server_ubuntu | CHANGED | rc=0 >>
  total 4
  drwx------ 7 root root 4096 Jan 17 15:23 snap
  msi | UNREACHABLE! => {
      "changed": false,
      "msg": "Failed to connect to the host via ssh: ssh: connect to host msi port 22: No route to host",
      "unreachable": true
  }
  (base) ----- [2025-Jan-18 17:18:34] saanvi@ryzen9 (Ansible-Learning)

ANSIBLE_COMMAND_OUTPUT


