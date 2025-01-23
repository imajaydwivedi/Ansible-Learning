:<<'USING_MACOS_AS_ANSIBLE_CONTROL_HOST'

Using MacOS as Ansible Control Node
---------------------------------------

-> install ansible
brew install ansible

-> verify installation
ansible --version

# create ansible user

# hide GUI login for user
sudo dscl . create /Users/ansible IsHidden 1

# verify ansible user
id ansible
ssh-copy-id ansible@localhost

# Run following command without command line parameters
ansible all -a "ls -l /root"

USING_MACOS_AS_ANSIBLE_CONTROL_HOST


