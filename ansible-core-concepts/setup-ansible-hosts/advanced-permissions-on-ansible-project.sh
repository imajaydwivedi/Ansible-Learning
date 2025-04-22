# Add users to dba group
sudo usermod -aG dba adwivedi
sudo usermod -aG dba ansible

# change group owner to "dba" for Ansible-Learning git repo folder
sudo chgrp -R dba /stale-storage/GitHub/Ansible-Learning

# change permissions for Ansible-Learning git repo folder
sudo chmod -R 775 /stale-storage/GitHub/Ansible-Learning

# set SGID for Ansible-Learning git repo folder. Runs the file as Group Owner of file & Sets ownership of newly created items as the group owner of that directory
sudo chmod -R g+s /stale-storage/GitHub/Ansible-Learning

# set sticky bit for Ansible-Learning git repo folder. Allows a user to delete files if a) the user is file owner b) the user is directory owner
sudo chmod -R +t /stale-storage/GitHub/Ansible-Learning