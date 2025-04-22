:<<'CONFIGURE_MANAGED_HOSTS_HELP'

Procedure Overview
--------------------------------------------------

-> Create a dedicated user account. For example, a user "ansible"

-> Ensure this user has "sudo" privileges on at least the managed nodes.

-> Ensure that SSH-based based access to the managed nodes has been configured.

-> Install Python

-> Setup hostname resolving

-> Create an inventory file

-> Configure the ansible.cfg file. Contains default parameters that we are going
    to use with ansible commands

->


Required Lab Environment (Ubuntu)
-------------------------------------

-> On the control machine, create a user "ansible" and set the password to "ansible".
    Ensure this user has sudo privileges.

    sudo adduser ansible

    # in ubuntu
    echo 'ansible:ansible' | sudo chpasswd
    sudo passwd ansible

    # in rhel
    echo 'ansible' | sudo passwd --stdin ansible

    # create a group
    sudo addgroup sudo-nopw

    # Grant Passwordless sudo Access for all members of group sudo-nopw
    echo '%sudo-nopw ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/sudo-nopw > /dev/null

    sudo visudo
    or
    sudo nano /etc/sudoers.d/sudo-nopw

        %sudo-nopw ALL=(ALL:ALL) NOPASSWD:ALL

    # sudo access on Ubuntu
    sudo usermod -aG sudo-nopw ansible

    # sudo access on Ubuntu
    sudo usermod -aG sudo ansible

    # sudo access on Rhel
    sudo usermod -aG wheel ansible

    # To Restrict GUI login in lightdm (nologin)
    # https://askubuntu.com/a/575390
    sudo nano /var/lib/AccountsService/users/ansible

      [User]
      Session=
      Icon=/home/ansible/.face
      SystemAccount=true

      sudo systemctl restart accounts-daemon.service

    # add no password prompt while switching from saanvi to ansible user
    sudo visudo -f /etc/sudoers.d/saanvi

        saanvi ALL=(ansible) NOPASSWD:ALL
        saanvi ALL=(adwivedi) NOPASSWD:ALL

    # test access
    sudo -i -u ansible

-> On control, configure an /etc/hosts file to setup name resolution for each of the nodes.

-> Type "ansible --version" to verify software has been installed

-> On managed nodes, use "systemctl status sshd" to verify SSH is running and available.
  # Openssh-Server
  sudo apt install -y openssh-client openssh-server
  sudo systemctl enable ssh
  sudo systemctl status ssh
  sudo ufw allow ssh

-> Type "rpm -qa | grep python" (Red Hat Family) or "sudo dpkg --get-selections python" to
    verify Python is installed

-> If used, check your filewall to ensure it allows incoming SSH traffic.

-> Use "ssh server_centos" and "ssh server_rhel" to add the remote host key fingerprint.
    Do this step under user "adwivedi" or which ever is present on all the managed hosts.

    Use Ctrl+C when prompted for a password

-> Create a file with the name "inventory" in the current directory and enter the names of the Ansible-managed nodes in there.

    cat > inventory << EOF
    [redhat]
    pgprod
    server_ansible
    server_centos
    server_rhel

    [debian]
    server_ubuntu
    EOF

    [laptops]


-> Run "ping" test to ensure above steps completed successfully
    ansible -i inventory all -m ping
    ansible -i inventory all -u adwivedi -m ping

-> Create the user "ansible" on the remote hosts
    #under other user (it is similar to doing ssh adwivedi@server_ubuntu, and then running "sudo adduser ansible")

    # under root user
    ansible -i inventory debian -u root -k -m command -a "useradd ansible"

    # add ansible user for Debian distributions
    ansible -i inventory debian -u adwivedi -k -b -K -m command -a "adduser ansible"

    # add ansible user for Redhat distributions
    ansible -i inventory redhat -u adwivedi -k -b -K -m command -a "useradd ansible"

-> Set the password for user ansible (password = ansible)
    ansible -i inventory all -u root -k -m shell -a "echo ansible | passwd --stdin ansible"

    # set ansible password on redhat servers
    ansible -i inventory redhat -u adwivedi -k -b -K -m shell -a "echo ansible | passwd --stdin ansible"

    # set ansible password on debian servers
    ansible -i inventory debian -u adwivedi -k -b -K -m shell -a "echo 'ansible:ansible' | sudo chpasswd"


-> Verify
  ansible -i inventory all -u ansible -k -m command -a "whoami"

-> Check Privilege Escalation
  ansible -i inventory all -u ansible -k -m command -a "ls -l /root"

  # On control node
  sudo visudo /etc/sudoers.d/ansible

      ansible ALL=(ALL) NOPASSWD:ALL

-> Provide elevated access for "ansible" user on all managed hosts
  ansible -i inventory all -k -b -K -u adwivedi -m copy -a 'content="ansible ALL=(ALL) NOPASSWD:ALL" dest=/etc/sudoers.d/ansible'

--> Check Privileged Escalation again after "ssh-copy-id <managed_host>"
  ansible -i inventory all -b -m command -a "ls -l /root"

-> Remove "ansible" user from GUI Login Screen
  ansible -i inventory all -k -b -K -u adwivedi -m copy -a 'content="[User]
Session=
Icon=/home/ansible/.face
SystemAccount=true
" dest=/var/lib/AccountsService/users/ansible mode=0644'

--> Remove "adwivedi" user from GUI login screen on msi

  ansible -i inventory msi -k -b -K -u adwivedi -m copy -a 'content="[User]
Session=
Icon=/home/adwivedi/.face
SystemAccount=true
" dest=/var/lib/AccountsService/users/adwivedi mode=0644'

CONFIGURE_MANAGED_HOSTS_HELP

