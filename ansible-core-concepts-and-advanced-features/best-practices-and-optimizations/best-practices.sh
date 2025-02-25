:<<'BEST_PRACTICES_AND_OPTIMIZATIONS'

Using "include" and "import"
-------------------------------------------

-> As playbook grow larger, it is common to develop them in a modular way

-> Roles are part of that strategy, where an entire role is easily called from a playbook.

-> Alternatively, plays and tasks can be called either dynamically or statically

-> Use "include" if you need a dynamic process, for instance, to run code based
    on the results of a conditional,

    -> Included code is only processed at the moment that include is reached.

-> Use "import" if you need a static process,

    -> Imported code is preprocessed when the playbook is read

Example -

ansible-playbook ansible-core-concepts-and-advanced-features/best-practices-and-optimizations/users-advanced.yml


Configuring Security - Making Secure Connections
-----------------------------------------------------

-> Too often, SSH connections Ansible uses are insecure

    -> passphraseless SSH keys are used to connect to remote hosts
    -> "become = true" is used as a standard setting

-> Easy options for increased security are not convenient

    -> "-b -K" when needed for privilege escalation
    -> "-k" instead of SSH keys

-> Do NOT configure passphraseless solutions as a standard!

-> Securing SSH connections:

    -> Use "ssh-keygen" to generate an SSH key that is protected with a password
    -> Use "eval ssh-agent $SHELL" to start the SSH agent after login
    -> Use "ssh-add ~/.ssh/id_rsa" to add your identity to the agent
    -> Verify using "ssh-add -l"

-> Consider automating by putting all in ~/.bash_profile

    -> You will be prompted for the keyphrase password at first use
    -> Next, the password is cached for the remaining duration of your session

    -----------
    if [ -z "$SSH_AUTH_SOCK" ] ; then
        eval ` ssh-agent -s `
        ssh-add
    fi
    -----------


Securing Privilege Escalation
-----------------------------------------------------

-> Do NOT use the "NOPASSWD" option in /etc/sudoers

-> Instead, increase the "timestamp" option in /etc/sudoers to decrease the frequency
    that you'll have to enter a password

    -> Defaults timestamp_type=global,timestamp_timeout=60
    -> "timestamp_type=global" keeps an authentication token for passwordless priviledge
        escalation, no matter which terminal a user is coming from
    -> "timestamp_timeout=60" keeps the token for 60 minutes

-> These options are needed on ALL managed servers

    -> Consider using "line_in_file" to get them in /etc/sudoers

-> On first contact, use "-K" to prompt for privilege escalation password

-> In all sebsequent commands, omit the "-K" option until you see an error

-> After token expiration, use "-K" again to refresh the token


Demo: Security Ansible
-------------------------------------------------

-> On Control, use "ssh-keygen" and set a passphrase for the Ansible user

-> eval ssh-agent /bin/bash

-> ssh-add ~/.ssh/id_rsa

-> Use "ssh-copy-id" to copy the new public key to managed hosts

-> Create a playbook that uses "lineinfile" to replace the "Default" section in
    /etc/sudoers on all the managed hosts. Hints:

      -> regex: '^Defaults'
      -> line: 'Defaults\
         timestamp_type=global,timestamp_timeout=60'
      -> validate: /usr/sbin/visudo -cf %s

-> Run the playbook with the "-b -K" options

# At first, write the token settings
ansible-playbook ansible-core-concepts-and-advanced-features/best-practices-and-optimizations/secure-hosts.yml -b -K

# Test if become is successful. Ideally it should fail
ansible ansible_vms -a "ls -l /root"

# Rerun any ansible command again with "-b -K" to save the auth token
ansible-playbook ansible-core-concepts-and-advanced-features/best-practices-and-optimizations/secure-hosts.yml -b -K

# Test again if become is successful.
ansible ansible_vms -a "ls -l /root"

# Validate all servers for ssh token line entry in /etc/sudoers
ansible ansible_vms -m shell -a "sudo awk '/^Defaults timestamp/ {count=2} count-->0' /etc/sudoers"

# Check which managed host got "NOPASSWD" entry for remote user
ansible ansible_vms -m shell -a "ls -l /etc/sudoers.d/ansible"


Using Tags
-----------------------------------------

-> 




BEST_PRACTICES_AND_OPTIMIZATIONS

