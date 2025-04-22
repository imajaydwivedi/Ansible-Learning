:<<'USING_ROLES_COMMENTS'

Understanding Roles
-----------------------------------------

-> Some tasks are used a lot in Ansible.

-> Instead of defining these tasks yourself, Ansible Roles can be used.

-> A role is a set of ready-to-use tasks that is easily integrated in a playbook.

-> Community roles are available at https://galaxy.ansible.com

-> Roles can also be installed through packages, such as rhel-system-roles.rpm package.

-> Alternatively, users can develop custom roles.


Installing Roles
----------------------------------------

-> Before using roles, they need to be installed.

-> Roles are typically installed in one of the following:

    -> /usr/share/ansible/roles
    -> /etc/ansible/roles
    -> ./roles

-> Use the "roles_path" option in ansible.cfg to define an alternative roles path.

-> After installing roles, they can be used from playbooks.


Goto galaxy.ansible.com > Roles. Filter for Download count.

# install in user home directory by default
ansible-galaxy role install geerlingguy.nginx

# install in roles directory in current path
ansible-galaxy role install geerlingguy.nginx -p roles


Playbook Role Processing Order
--------------------------------------------------

-> By default, roles are executed before all tasks in the playbook.

-> To force tasks to be executed before the roles, use the "pre_tasks" statement.

-> To force tasks to be executed after the roles, use "post_tasks".


Example -

ansible-playbook ansible-core-concepts/using-roles/nginx-role.yml
ansible-navigator run ansible-core-concepts/using-roles/nginx-role.yml


Role Organization
------------------------------------------------

-> Roles are organized in a well-defined way, where specific content is written to specific directories.

-> It's easy to create this directory structure: use "ansible-galaxy role init" to create it.

-> Notice that you don't have to create directories for content types you're not using.


mkdir ./ansible-core-concepts/using-roles/roles
cd ./ansible-core-concepts/using-roles/roles

# create a dummy role
ansible-galaxy role init demo-role
tree demo-role

# create role for motd
ansible-galaxy role init motd
tree motd

cd motd
# create template file
vim ./templates.motd.j2
# define default global variables that could be overwritten in play later
vim ./defaults/main.yml
# define tasks for role
vim ./tasks/main.yml
# create a playbook using the motd role
cd ..
vim motd-role.yml

# run playbook
ansible-playbook ansible-core-concepts/using-roles/motd-role.yml
ansible ansible_vms -a "cat /etc/motd"


System Roles
----------------------------------

-> The linux-system-roles package provides different roles that were developed for common tasks.

-> On RHEL, these roles are provided in the rhel-system-roles.rpm package or by using
    the redhat.rhel_system_roles collection

-> A collection-based version of the roles can be installed through fedora.linux_system_roles.

-> While installing the rhel-system-roles.rpm package, the redhat.rhel_system_roles collection is installed
    and provides access to the roles.

-> After installing the role, you can access its documentation which includes examples:

    -> In /usr/share/doc/rhel-system-roles if installed through the RPM
    -> In $COLLECTION_PATH/ansible_collections/fedora/linux_system_roles/doc if installed using collections

-> The redhat.rhel_system_roles collection can also be installed directly using
    ansible-galaxy collection install

-> Use "ansible-galaxy collection list" to see which collection you are using, and adopt
    the FQCNs accordingly.


Example -

# On Ubuntu
ansible-galaxy collection install fedora.linux_system_roles

# On RHEL
sudo dnf install rhel-system-roles -y

# Get installed directory
  # ubuntu. Run below command, and cd to collections directory of interest
ansible-galaxy collection list

# check all roles available in "linxu_system_roles" collection
~/.ansible/collections/ansible_collections/fedora/linux_system_roles/roles

# On Ubuntu, To get help on a particular role, check **.md file in the role directory
less ~/.ansible/collections/ansible_collections/fedora/linux_system_roles/roles/firewall/README.md

# On RHEL, to get help on a particular role, check **.mf file in the docs directory
less ~/.ansible/collections/ansible_collections/redhat/rhel_system_system_roles/docs/README_firewall.md

Assignment
-----------------------------------

Write a playbook that uses the Nginx role to install Nginx on all the RHEL family hosts.
Make sure that before using the role, the following is done:
- If installed and running, Apache is removed.
- Perform an update of all packages

After running the role, remove the yum package cache

ansible-galaxy role list
ansible-galaxy role install geerlingguy.nginx

cd ~/.ansible/roles/geerlingguy.nginx/
less README.md

ansible-playbook ansible-core-concepts/using-roles/lab-exercise-nginx-role.yml

USING_ROLES_COMMENTS

