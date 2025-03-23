:<<'WORKING_WITH_VARIABLES'

Good Programming
-------------------------------

-> In generic programming, program code should be portable and site-specific
    information should not be in the code

-> For configuration as code, this is no different

-> Variables allow us to separate site-specific configuration from generic code.

-> In Ansible, user-defined variables can be used for any purpose.

-> Apart from that, Ansible provides Ansible facts, which are system properties
    that are discovered while running the playbook.


Understanding Where to Define Variables
-----------------------------------------------

-> While writing playbooks, it is not good practice to include site-specific data
    in the playbooks.

-> Playbooks that define variables within the playbook are less portable

-> To make variable use more flexible, they should be defined in a file which is
    included in the play header using "vars_files".

-> See "ansible-doc -t keyword vars_files" for a short description.

-> The variables file itself contains variable definitions in "key: value" format.


Using Host Variables
------------------------------

-> Host variables are variables that are specific to a host only.

-> They are defined in a YAML file that has the name of the inventory and are stored
    in the "host_vars" directory in the current project directory.

-> To apply variables to host groups, a file with the inventory name of the host group
    should be defined in the "group_vars" directory in the current project directory.

-> Host variables defined this way will be picked up by the hosts automatically.

-> Host variables can also be set in the inventory, but this is not deprecated.

ansible-playbook ansible-core-concepts/working-with-variables/variables-using-group_vars-ansible_vms.yml
ansible-playbook ansible-core-concepts/working-with-variables/variables-using-group_vars-redhat.yml

ansible ansible_vms -m shell -a "echo && tail -5 /etc/passwd"


Understanding Facts
----------------------------------

-> Ansible facts are variables that are automatically set and discovered by Ansible on managed hosts.

-> Facts contain information about hosts that can be used in conditionals:
    -> Available memory
    -> IP address
    -> Distribution and distribution family
    -> and much more

-> Using facts allows you to perform actions only if certain conditions are true.

# Get hosts available in inventory file
ansible all --list-hosts
ansible-inventory --list

# Read facts for a particular host
ansible msi -m setup | less

TIP! While using gathered facts, we skip "ansible_" keyword from 2nd level variables.
Example, "ansible_all_ipv4_addresses" should be referred as "all_ipv4_addresses"


Managing Fact Gathering
----------------------------------

-> By default, playbooks gather facts before running the actual plays

-> Use "gather_facts: no" in the play header to disable.

-> Even if fact gathering is disabled, it can be enabled again by running the "setup" module in a task.

-> You can also run fact gathering in an adhoc command using the "setup" module.

-> To show facts, use the debug module to print the value of the "ansible_facts" variable.

-> Notice that in facts, a hierarchical relation is shown where you can use the dotted format
  to refer to a specific fact.

Example -
ansible-playbook ansible-core-concepts/working-with-variables/get_facts.yml


Troubleshooting Slow Fact Collection
------------------------------------------

-> If you're experiencing slow fact gathering, ensure that hostname resolution is set up on
    all hosts.

-> Ensure that each managed host has an /etc/hosts file that allows for name resolution between
    all managed hosts.

-> If fact collection is slow because you're working against lots of hosts, you can use a
    fact cache.

Examples -
ansible-playbook ansible-core-concepts/working-with-variables/ip_fact.yml


Using set fact
-----------------------------------

-> set_fact module can be used to define a fact at global scope within a playbook

Example:
ansible-playbook ansible-core-concepts/working-with-variables/setting_facts.yml


Understanding Fact Organization
---------------------------------------------------------------

-> In Ansible 2.4 and before, Ansible facts were stored as individual variables, such as "ansible_hostname"
    and "ansible_interfaces", containing different sub-variables stored in a dictionary.

-> To refer to the next-tier variables, dots were used as a separator: "ansible_date_time.date"

-> In Ansible 2.5 and later, all facts are stored in one dictionary variable with the name "ansible_facts",
    and referring to specific facts happens in a different way: "ansible_facts['hostname']"

Example:

ansible_date_time.date
ansible_facts.date_time.date
ansible_facts['date_time']['date']

ansible-playbook ansible-core-concepts/working-with-variables/ip_fact.yml


Using multi-valued variables or Understanding Array and Dictionary
---------------------------------------------------------------------------

-> Multi-valued variables can be used in playbooks and can be seen in output, such as Ansible facts.

-> When using a multi-valued variable, it can be written as an array (list), or as a dictionary (hash).

-> Each of these has their own specific use cases:
    -> Dictionaries are used in Ansible facts
    -> Arrays are common for multi-valued variables, and easy support loops
    -> Loops are not supported on dictionaries


Dictionaries versus Arrays
-------------------------------------------

-> Dictionaries and arrays in Ansible are based on Python dictionaries and arrays.

-> An array (list) is an ordered list of values, where each value can be addressed individually.

List = ["one", "two", "three"]
print(List[0])

-> A dictionary (hash) is an unordered collection of values, which is stored as a key-value pair.

Dict = {1: 'one', 2: 'two', 3: 'three'}
print(Dict)

-> Notice that a dictionary can be included in a list, and a list can be part of a dictionary.

ansible localhost -m setup | less


Understanding Dictionary (Hash)
---------------------------------------------

-> Dictionaries can be written in two ways:

  users:
    linda:
      username: linda
      shell: /bin/bash
    lisa:
      username: lisa
      shell: /bin/sh

-> Or as:

  users:
    linda: { username: 'linda', shell: '/bin/bash' }
    lisa: { username: 'lisa', shell: '/bin/bash' }

-> To address items in a dictionary, you can use two notations:

  -> variable_name['key'], as in users['linda']['shell']
  -> variable_name.key, as in users.linda.shell

-> Dictionaries are used in facts, arrays are used in conditionals.


Using Arrays (List)
---------------------------------------------------

-> Arrays provide a list of items, where each item can be addressed separately.

  users:
  - username: linda
    shell: /bin/bash
  - username: lisa
    shell: /bin/sh

-> Individual items in the array can be addressed, using the {{ var_name[0] }} notation.

-> Use arrays for looping, not dictionaries.

-> To access all variables, you can use "with_items" or "loop"


Recognizing Arrays and Dictionaries
----------------------------------------------------

-> In output like facts, a list is always written between [ ].

-> Dictionaries are written between { }.

-> And if the output is just showing " ", it is a string.

-> As an example, check "ansible_mounts" in the facts, which actually presents a list of dictionaries.

Example:

ansible server_ansible -m setup -a "filter=ansible_mounts"


Using Magic Variables
---------------------------------------

Some variables known as "Magic Variables" are builtin and cannot be used for anything else:

-> hostvars: a dictionary that contains all variables that apply to a specific host

-> inventory_hostname: inventory name of the current host

-> inventory_hostname_short: short host inventory name

-> groups: all hosts in inventory, and groups these hosts belong to

-> group_names: list of groups that current host is a part of

-> ansible_check_mode: boolean that indicates if play is in check mode

-> ansible_play_batch: active hosts in the current play

-> ansible_play_hosts: same as ansible_play_batch

-> ansible_version: current Ansible version


Understanding Register
------------------------------

-> "register" is used to record the result of a command or task and store it in a variable.

-> Using "register" is convenient to work with variables that have a dynamic value.

Example:

ansible-playbook ansible-core-concepts/working-with-variables/reg_var.yml


Using Vault to Store Sensitive Information
----------------------------------------------------

-> Some modules require sensitive data to be processed.

-> This may include webkeys, passwords, and more.

-> To process sensitive data in a secure way, Ansible Vault can be used.

-> Ansible Vault is used to encrypt and decrypt file.

-> To manage this process, the "ansible-vault" command is used.


Demo: Using Vault
-----------------------------------

-> To create an encrypted file, use
    ansible-vault create sensitive_values

    ---
    ansible-vault create private/creds
        # Here it would ask for "vault password". So remember this password
        # Inside file, enter secrets in following "key: value" pair
    PG_SUPERUSER_PWD: SomeStrongPassword
    ---

-> To view a vault encrypted file, use
    ansible-vault view sensitive_values

-> To edit, use
    ansible-vault edit sensitive_values

-> Use below to encrypt an existing file
    ansible-vault encrypt sensitive_values
-> Use below to decrypt an encrypted file
    ansible-vault decrypt sensitive_values

-> To change a password on an existing file, use
    ansible-vault rekey sensitive_values


Using Playbooks with Vault
-----------------------------------------------

-> To use a vault-encrypted file, include the vault file using "vars_files"

-> To run a playbook that uses a vault encrypted file, use --ask-vault-pass

-> Alternatively, you can store the password as a single-line string in a password file,
    and access that using the "--vault-password-file=vault-pass" option.

echo password > vault-pass


Managing Vault Files
-----------------------------------------------

-> When setting up projects with Vault encrypted files, it makes sense to use separate
    files to store encrypted and non-encrypted variables.

-> To store host or host-group related variables files, you can use the following structure:

-------------------------------
| - group_vars
|   | -- redhat
|        | - vars
|        | - vault
|   | -- ansible_vms
|        | - vars
|        | - vault
-------------------------------

-> This replaces the solution where all variables are stored in a file with the
    name of the host or host group.

Example:

# create vault password in a file. Ensure this "vault-pass" file is added to .gitignore
echo 'password' > vault-pass
chmod 600 vault-pass

ansible-playbook --vault-password-file=ansible-core-concepts/working-with-variables/vault-pass \
    ansible-core-concepts/working-with-variables/create-user.yml



WORKING_WITH_VARIABLES




:<<'MAGIC_VARIABLES'

Role-Specific Auto/Magic Variables
==============================================

+----------------+---------------------------------------------+
| Variable       | Description                                 |
+----------------+---------------------------------------------+
| role_name      | Name of the current role                    |
| role_path      | Absolute path to the role directory         |
| role_vars      | Variables defined in role's vars directory  |
| role_defaults  | Variables defined in role's defaults dir    |
+----------------+---------------------------------------------+

Playbook-Related Auto/Magic Variables
==============================================

+------------------------+-------------------------------------------------------------+
| Variable               | Description                                                 |
+------------------------+-------------------------------------------------------------+
| playbook_dir           | Directory of the executing playbook (absolute path)         |
| inventory_dir          | Directory of the inventory source                           |
| inventory_file         | Path of the inventory file being used                       |
| group_names            | List of groups the current host is in                      |
| groups                 | Dictionary of groups and their hosts from inventory         |
| inventory_hostname     | Current host's name in the inventory                        |
| ansible_play_hosts     | List of all hosts in the current play                      |
| ansible_play_batch     | Hosts in the current play that haven't failed               |
| ansible_playbook_python| Python interpreter path running the playbook                |
+------------------------+-------------------------------------------------------------+


Host-Related Auto/Magic Variables
===========================================

+------------------------------+-----------------------------------------------------+
| Variable                     | Description                                         |
+------------------------------+-----------------------------------------------------+
| ansible_hostname             | Short hostname of the target machine               |
| ansible_facts                | Facts gathered from the host                       |
| ansible_distribution         | OS distribution of the host                        |
| inventory_hostname_short     | Shortened version of inventory_hostname            |
| hostvars                     | Dictionary of variables for all hosts              |
| ansible_all_ipv4_addresses   | List of all IPv4 addresses of the host             |
+------------------------------+-----------------------------------------------------+


Task-Related Magic Variables
=============================================

+----------------------------+-------------------------------------------------------+
| Variable                   | Description                                           |
+----------------------------+-------------------------------------------------------+
| ansible_check_mode         | true if playbook is running in check mode            |
| ansible_delegated_vars     | Information about a delegated host                   |
| ansible_failed_result      | Result of last failed task (rescue/always use cases)  |
| ansible_loop               | Info about the current loop iteration                |
| ansible_skip_tags          | Tags skipped in the current play                     |
+----------------------------+-------------------------------------------------------+


Block and Include-Related Magic Variables
===================================================

+------------------------------+-----------------------------------------------------+
| Variable                     | Description                                         |
+------------------------------+-----------------------------------------------------+
| block                        | Block task structure when using block keyword       |
| include_role                 | Info about an included role                        |
| include_tasks                | Info about an included task file                   |
| ansible_parent_role_names    | List of parent roles in the inclusion chain         |
+------------------------------+-----------------------------------------------------+


Connection and Execution Info Variables
===================================================

+-------------------------------------+---------------------------------------------+
| Variable                            | Description                                 |
+-------------------------------------+---------------------------------------------+
| ansible_connection                  | Connection type (ssh, local, winrm, etc.)   |
| ansible_user                        | User account used for the connection        |
| ansible_host                        | Hostname/IP address for the connection      |
| ansible_port                        | Port used for the connection                |
| ansible_ssh_private_key_file        | SSH key used for the connection             |
+-------------------------------------+---------------------------------------------+


Common Path Variables Quick Reference
===================================================

+----------------+--------------------------------------+
| Variable       | Path Description                     |
+----------------+--------------------------------------+
| playbook_dir   | Playbook file's directory            |
| role_path      | Current role’s directory             |
| inventory_dir  | Directory of the inventory source    |
| inventory_file | Path of the inventory file           |
+----------------+--------------------------------------+


Example Usage in Tasks
=======================

- name: Show role path
  debug:
    msg: "Current role path is {{ role_path }}"

- name: Show playbook directory
  debug:
    msg: "Playbook is running from {{ playbook_dir }}"

- name: Show inventory file
  debug:
    msg: "Inventory file used is {{ inventory_file }}"




MAGIC_VARIABLES


