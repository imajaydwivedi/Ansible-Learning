:<<'USING_ANSIBLE_CONTENT_COLLECTIONS'

-> The ansible-core package has a limited number of modules.

-> Ansible Content Collections are used to provide access to additional modules.

-> Contents Collections can be installed from galaxy.ansible.com

-> When using Ansible Content Collections, a Fully Qualified Collection Name (FQCN)
    should be used to refer to a specific module.

-> Use "ansible-doc -l" for an overview of currently installed modules and the FQCN they have.

[!TIP] In some cases it may make sense to avoid using FQCN, for instance to write a playbook
    that uses a module from a supported collection if that is available, and from
    the community collection otherwise.


The Need for FQCN
-------------------------------------

-> If different collections installed on your system use the same module names, the
    module FQCN should be used.

-> If short module names are unique on a system, short module names may be used.

-> If a short module name is used, but the module name exists in different collections,
    inpredictable results will occur.




USING_ANSIBLE_CONTENT_COLLECTIONS

# get installed modules
ansible-doc -l

# Ansible Collection targeting POSIX and POSIX-ish platforms.
ansible-galaxy collection install ansible.posix

# A collection of PostgreSQL community modules for Ansible
  # https://github.com/ansible-collections/community.postgresql
ansible-galaxy collection install community.postgresql

# Ansible collection using PowerShell to configure and maintain SQL Server.
ansible-galaxy collection install lowlydba.sqlserver

# Ansible collection for core Windows plugins.
  # https://docs.ansible.com/ansible/latest/collections/ansible/windows/index.html#modules
ansible-galaxy collection install ansible.windows

# check installed modules
ansible-doc -l

#
ansible server_ansible -m ansible.posix.selinux -a "policy=targeted state=permissive"

# Get installed collections list
ansible-galaxy collection list

    :<<'COMMAND_OUTPUT'
  |------------$ ansible-galaxy collection list

  # /home/saanvi/.ansible/collections/ansible_collections
  Collection           Version
  -------------------- -------
  ansible.posix        2.0.0
  ansible.windows      2.6.0
  community.postgresql 3.10.0
  lowlydba.sqlserver   2.5.0

COMMAND_OUTPUT

# Find collections having setup module
ansible-doc -l | grep setup



