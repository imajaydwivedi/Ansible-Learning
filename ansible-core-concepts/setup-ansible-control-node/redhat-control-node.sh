:<<'INSTALLING_ANSIBLE_ON_RHEL'

Installing Ansible on RHEL
---------------------------

-> On the control node: use "sudo subscription-manager repos --list" to verify
    the name of the latest available repository

-> Use "sudo subscription-manager repos --enable=rhel-9-for-x86_64-appstream.rpms"
    to enable the repository

-> Use "sudo subscription-manager repos --list | grep automation-platform" to
    find the appropriate version and use that in the next command

-> Use "sudo subscription-manager repos --enable ansible-automation-platform-2.4-for-rhel-9-x86_64-rpms"
    to add the Ansible repository

-> Use "sudo dnf install ansible-core" to install the Ansible software

-> Use "sudo dnf install ansible-navigator" to install the Ansible Automation Content
    Navigator

-> Use "ansible --version" to verify the ansible command works as expected

INSTALLING_ANSIBLE_ON_RHEL

