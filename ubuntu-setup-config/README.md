https://stackoverflow.com/a/58644752

# Configure password less ssh
ssh-keygen
ssh-copy-id ansible@server_desktop

# enable password sudo for ansible user
ansible server_desktop -m copy -a"src=/etc/sudoers.d/ansible dest=/etc/sudoers.d/ansible" -K

ansible server_desktop -m copy -a"src=ubuntu-mate-desktop/files/dconf-mate-panel dest=/tmp/dconf-mate-panel"


# Edit mate-panel layout with command line
https://ubuntu-mate.community/t/edit-mate-panel-layout-with-command-line/25381/2

# Dump MATE config to file
dconf dump /org/mate/ > ubuntu-mate-desktop/files/dconf-org_mate.ini

# Apply MATE config from file
dconf load /org/mate/ < ubuntu-mate-desktop/files/dconf-org_mate.ini

