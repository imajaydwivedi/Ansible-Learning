:<<'USING_ADHOC_COMMANDS_HELP'

Adhoc Commands vesus Playbooks
----------------------------------------------

-> The best way to work with Ansible, is by writing playbooks that define the desired state.

-> Playbooks can be written considering complex dependency relations.

-> Ad-hoc commands can be used for quick tasks that don't have dependencies and
    that don't need to be reproducable.

-> They also come handy for testing.


Understanding Ansible Modules
-----------------------------------

-> Ansible modules are provided to access a wide range of tasks
  -> The ansible-core package provides a minimal amount of modules
  -> Additional modules are installed using content collections

-> Modules are written in Python, and used in ad-hoc commands and Ansible playbooks.

-> "command, shell and raw" are pretty basic and non-specific, many specialized
    modules exist as well.

-> Use "ansible-doc -l" to get a list of all modules that are installed.

-> Install additional modules as content collections from https://galaxy.ansible.com

-> Knowing Ansible = knowing modules.


Using Modules in Ad-hoc Commands
-------------------------------------

-> An ad-hoc command is a command where all required command parameters are provided
    on the command line.

-> Ad-hoc commands have different elements:
    -> Name or names of target hosts
    -> Name of the module to be used
    -> Name of the module arguments between double quotes
    -> Other elements may be required if not set in ansible.cfg

-> Example 01

ansible all -i inventory -m user -a "name=lisa"

-> Example 02

ansible ubuntu -i inventory -u student -b -K -m package -a "name=nmap"


Demo: Running Ad-hoc commands
-----------------------------------

-> As user "ansible" on control, make sure you are in the directory that has inventory and ansible.cfg files

-> Type "ansible all -m ping"

-> Type
ansible all -m user -a "name=anant"

-> Observe the command output

-> Type
ansible all -m command -a "id anant"

-> Type
ansible all -m user -a "name=anant state=absent"

-> Type
ansible all -m copy -a "src=/etc/hosts dest=/etc/hosts"



USING_ADHOC_COMMANDS_HELP





# examples of adhoc commands. Here, we already have "ansible.cfg" and "inventory"
ansible all -m command -a "whoami"
ansible all -m command -a "la -l /root"
ansible all -m ping

# get all available modules
ansible-doc -l

# create a user and check status
ansible all -m user -a "user=anant"
ansible all -m command -a "id anant"

# remove above created user
ansible all -m user -a "user=anant state=absent"

# check existence of user "adwivedi" on all hosts in inventory
ansible all -m command -a "id adwivedi"

# copy /etc/hosts from control node to managed hosts
ansible all -m copy -a "src=/etc/hosts dest=/etc/hosts"

