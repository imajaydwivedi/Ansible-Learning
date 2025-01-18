:<<'USING_MACOS_AS_ANSIBLE_CONTROL_HOST'

Using MacOS as Ansible Control Node
---------------------------------------

-> install ansible
brew install ansible

-> verify installation
ansible --version

# Run following command without command line parameters
ansible all -a "ls -l /root"

USING_MACOS_AS_ANSIBLE_CONTROL_HOST


