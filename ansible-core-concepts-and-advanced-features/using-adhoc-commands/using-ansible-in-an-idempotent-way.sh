:<<'USING_ANSIBLE_IN_IDEMPOTENT_WAY_HELPTEXT'

Using Ansible in an Idempotent Way
---------------------------------------------

-> Idempotency means that regardless the state of the managed machine, running the
    same module should always lead to the same results.

-> Most Ansible modules were developed with idempotency in mind.

-> Generic modules like "command", "shell" and "raw" are not idempotent.

-> Always develop Ansible content for idempotency, or you will get failing modules.

-> If an Ansible module fails, further execution on that host stops.


USING_ANSIBLE_IN_IDEMPOTENT_WAY_HELPTEXT

# create user with adhoc command
ansible ansible_vms -m command -a "useradd paulo"


:<<'COMMAND_OUTPUT'

(base) ----- [2025-Jan-22 22:21:32] saanvi@ryzen9 (Ansible-Learning)
|------------$ ansible ansible_vms -m command -a "useradd anant"
server_ubuntu | CHANGED | rc=0 >>

server_centos | CHANGED | rc=0 >>
useradd: warning: the home directory /home/anant already exists.
useradd: Not copying any file from skel directory into it.
Creating mailbox file: File exists
server_rhel | CHANGED | rc=0 >>
useradd: warning: the home directory /home/anant already exists.
useradd: Not copying any file from skel directory into it.
Creating mailbox file: File exists
server_ansible | CHANGED | rc=0 >>
useradd: warning: the home directory /home/anant already exists.
useradd: Not copying any file from skel directory into it.
Creating mailbox file: File exists
(base) ----- [2025-Jan-22 22:22:07] saanvi@ryzen9 (Ansible-Learning)
|------------$ 
(base) ----- [2025-Jan-22 22:22:09] saanvi@ryzen9 (Ansible-Learning)
|------------$ ansible ansible_vms -m command -a "useradd anant"
server_ubuntu | FAILED | rc=9 >>
useradd: user 'anant' already existsnon-zero return code
server_rhel | FAILED | rc=9 >>
useradd: user 'anant' already existsnon-zero return code
server_centos | FAILED | rc=9 >>
useradd: user 'anant' already existsnon-zero return code
server_ansible | FAILED | rc=9 >>
useradd: user 'anant' already existsnon-zero return code
(base) ----- [2025-Jan-22 22:22:13] saanvi@ryzen9 (Ansible-Learning)
|------------$ 

(base) ----- [2025-Jan-22 22:22:43] saanvi@ryzen9 (Ansible-Learning)
|------------$ ansible ansible_vms -m user -a "name=anant"
server_ubuntu | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "append": false,
    "changed": false,
    "comment": "",
    "group": 1002,
    "home": "/home/anant",
    "move_home": false,
    "name": "anant",
    "shell": "/bin/sh",
    "state": "present",
    "uid": 1002
}

COMMAND_OUTPUT

