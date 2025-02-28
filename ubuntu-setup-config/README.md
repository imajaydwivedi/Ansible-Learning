https://stackoverflow.com/a/58644752

# Configure password less ssh
ssh-keygen
ssh-copy-id ansible@server_desktop

# enable password sudo for ansible user
ansible server_desktop -m copy -a"src=/etc/sudoers.d/ansible dest=/etc/sudoers.d/ansible" -K

# 


