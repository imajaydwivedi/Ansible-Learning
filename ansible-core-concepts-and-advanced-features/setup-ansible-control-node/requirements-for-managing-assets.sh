:<<'ANSIBLE_ASSET_REQUIREMENTS_DETAILS'

Managed Asset Requirements
---------------------------

-> Remote connectivity: SSH on Linux

-> Remote connectivity: WinRM on Windows

-> Python packages installed

-> A user that can use privilege escalation


About "sudo" Privileges
---------------------------

-> To get your started in an easy way, "sudo" privilege escalation will be configured
  with the "NOPASSWD" option

  More help on -
  https://github.com/imajaydwivedi/Linux-Learning/blob/main/Fundamentals/configuring-sudo.sh

-> This option should never be used in real life, as it makes your configuration insecure.

-> To securely escalate privileges using passwords, add the following to /etc/sudoers

    # Increase sudo Password Timeout to 4 Hours
    Defaults timestamp_type=global, timestamp_timeout=240


ANSIBLE_ASSET_REQUIREMENTS_DETAILS
