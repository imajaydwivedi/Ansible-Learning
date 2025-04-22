:<<'UNDERSTANDING_PLAYBOOK_STRUCTURE_COMMENTS'

Why Use Playbooks
-----------------------------

-> Ansible playbooks are used to run multiple tasks against managed hosts in
    a scripted way.

-> They describe the desired state, which is next compared to the current state.

-> In playbooks, many advanced Ansible features can be used.

-> In playbooks, one or multiple plays are started.
    -> Each play runs one or more tasks.
    -> In these tasks, different modules are used to perform the actual work.

-> Playbooks are written in YAML and have the .yml or .yaml extension.


Understanding YAML
--------------------------------

-> YAML is an easy-to-read format to structure tasks/items that need to be created.

-> In YAML files, items are using indentation with spaces (no tabs!) to indicate
    the structure of data.

-> Data elements at the same level should have the same indentation.

-> Child items are indented more than the parent items.

-> There is no strict requirement about the number of spaces that should be used,
    but 2 is common.


Playbook Development Strategy
----------------------------------------

-> Start by designing the workflow procedure in the playbook.

-> To avoid having to think about specific modules, at this point use the debug
    module with the msg argument to describe what needs to be done in this task.

-> After defining the generic structure of the playbook, focus on specific modules
    and their arguments.


Running Your First Playbook
--------------------------------------

-> Use "ansible-playbook vsftpd.yml" to tun the playbook, or "ansible-navigator run vsftpd.yml"
    if you prefer working with naviagor.

-> A successful run requires a functional ansible.cfg and inventory file to be available;
    alternatively, required options can be provided as command line arguments.


Sample-

ansible-playbook ./ansible-core-concepts/using-ansible-playbooks/example.yml


UNDERSTANDING_PLAYBOOK_STRUCTURE_COMMENTS




