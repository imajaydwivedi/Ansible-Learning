# ERROR: Ansible requires the locale encoding to be UTF-8; Detected ISO8859-1.
  # To fix the error, copy output of "locale" of user where "ansible --version" is working to file /etc/default/locale
sudo nano /etc/default/locale

    LANG=en_US.UTF-8
    LANGUAGE=en_IN:en
    LC_CTYPE="en_US.UTF-8"
    LC_NUMERIC="en_US.UTF-8"
    LC_TIME="en_US.UTF-8"
    LC_COLLATE="en_US.UTF-8"
    LC_MONETARY="en_US.UTF-8"
    LC_MESSAGES="en_US.UTF-8"
    LC_PAPER="en_US.UTF-8"
    LC_NAME="en_US.UTF-8"
    LC_ADDRESS="en_US.UTF-8"
    LC_TELEPHONE="en_US.UTF-8"
    LC_MEASUREMENT="en_US.UTF-8"
    LC_IDENTIFICATION="en_US.UTF-8"
    LC_ALL=

  # Also for current "ansible" user, add following lines to ~/.profile file
    export LANG=en_US.UTF-8
    export LANGUAGE=en_US
    export LC_ALL=en_US.UTF-8


# [WARNING]: Platform linux on host pgprod is using the discovered Python interpreter at /usr/bin/python3.13, but future installation of another Python interpreter could change the meaning of that path.
    # See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.

  |------------$ cat > ansible.cfg << EOF
  > [defaults]
  > interpreter_python = auto_legacy_silent
  > EOF

