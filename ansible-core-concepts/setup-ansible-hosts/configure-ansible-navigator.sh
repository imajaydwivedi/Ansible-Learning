:<<'CONFIGURE_ANSIBLE_NAVIGATOR_REMARKS'

Install Ansible-Navigator on Ubuntu
------------------------------------
-> Run "pip install ansible-navigator"

-> Verify "ansible-navigator --version"

-> Run "ansible-navigator" to download the container image


Install Ansible-Navigator on Redhat
------------------------------------

-> Login to redhat registry using Redhat developer account
podman login registry.redhat.io

->
podman search ansible-automation-platform

->
podman search ansible-automation-platform-24

->
podman pull registry.redhat.io/ansible-automation-platform-24/ee-supported-rhel9:latest


Managing Settings for Ansible-Navigator
------------------------------------------

-> Settings for "ansible-navigator" can be specified in a specific file.

-> Define "~/.ansible-navigator.yml" for generic settings.

-> If an ansible-navigator.yml" file is found in the current project directory, this
    will have higher priority.

-> Recommended Settings:
  -> "pull.policy: missing" will only contact the container registory if no container
    image has been pulled yet

  -> "playbook-artifact.enable: false" is required when a playbook prompts for a password


Using ansible-navigator
------------------------------

-> If default values are not provided by a configuration file, they must be specified
    on the command line.

-> By default, "ansible-navigator" runs in a text-based user interface, use "-m stdout"
    to have it write output to the console.

-> To run a playbook,  use "ansible-navigator run playbook.yml"

ansible-navigator run ansible-core-concepts/install_and_start_httpd.yaml -m stdout


Artifact Files
--------------------------

-> While running a playbook with "ansible-navigator", it creates an artifact file
    in the current directory.

-> To re-run a previous play, use "ansible-navigator replay" or the ":replay" command
    from interactive mode

-> If while running playbooks, "ansible-navigator" needs to prompt for passwords,
    playbook artifacts must be disabled.


Providing Required Collections for "ansible-navigator"
-------------------------------------------------------

-> By default, some collections are included in "ansible-navigator"

-> Use "ansible-navigator collections" to show a list of current collections.

-> Collections are a part of the execution environment that "ansible-navigator" uses.

-> To use collections that are not currently available, there are two options:
    - Start "ansible-navigator" with "--eei" option to refer to another execution
      environment that is available
    - Create a collections directory in the current project directory, and use
      "ansible-galaxy collection install" to install the collection to that directory.

-> Alternatively, the "ansible-builder" utility can be used to create custom execution environments.



Demo: Working with Execution Environments
------------------------------------------------

-> Use "ansible-navigator images". This will list currently installed execution environments.

-> Use "pod pull registry.redhat.io/ansible-automation-platform-25/ee-minimal-rhel9:latest" to install an alternative
    execution environment.

-> use "ansible-navigator images" to verify it has been installed.

-> Type "ansible-navigator --eei registry.redhat.io/ansible-automation-platform-24/ee-minimal-rhel9:latest --pp never"

-> From the interactive interface, type "collections" to verify that only the ansible.builtin collection is available.

-> Clone the course Git repository,
    https://github.com/sandervanvugt/ansiblebg and use "cd ansible_ccat" to activate the cloned directory.


Ansible-Navigator Configuration
--------------------------------------

-> "ansible-navigator" can be configured by creating a configuration file ansible-navigator.yml file.

-> If this file is placed in the current project directory, it has highest priority.

-> Alternatively, put the .ansible-navigator.yml file in your home directory.

-> Use "ansible-navigator settings --sample > ansible-navigator-sample.yml" to generate a
    sample file with example settings
  -> Writing the output to ansible-navigator.yml in the current directory is not supported,
      write to a diffect filename and move that.


Common Settings
------------------------------

-> execution-environment: defines which execution environment and how to use it.

-> pull: policy: defines when to pull a new execution environment image.

-> mode: set to stdout if you don't want to use the interactive mode

-> playbook-artifact: enable: false prevents generation of playbook artifact files
    (which is necessary if playbooks are prompting for anything)


CONFIGURE_ANSIBLE_NAVIGATOR_REMARKS

# Search Execution Environment (ee) images
podman search ee

# Enforce the new collection "enforce-selinux.yml"
ansible-navigator run enforce-selinux.yml --eei registry.redhat.io/ansible-automation-platform-25/ee-minimal-rhel9

    :<<'COMMAND_OUTPUT'
    0│ERROR! the playbook: enforce-selinux.yml could not be found

    collection ansible.posix not found
COMMAND_OUTPUT

# create directory to keep collections
mkdir collections

# download "ansible.posix" collection into collections directory created above
ansible-galaxy collection install ansible.posix -p collections

# 





