:<<'MANAGING_FILES_COMMENTS'
** Frequently Asked Questions **
https://docs.ansible.com/ansible/latest/reference_appendices/faq.html

** How do I loop over a list of hosts in a group, inside of a template? **
https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#how-do-i-loop-over-a-list-of-hosts-in-a-group-inside-of-a-template


Manipulating Files
----------------------------------

-> "ansible.builtin.copy" is used to copy files from the control host to a managed host.

-> "ansible.posix.synchronize" synchronizes file contents and is more efficient.

-> "ansible.builtin.fetch" will fetch a file from a managed host to the control host.

-> "ansible.builtin.stat" gets status of files.


Using "copy" module
----------------------------------

-> Use "ansible.builtin.copy" as an Ansible alternative to Linux cp.

-> It can copy over individual files, as well as directories.

-> Use the "contents" argument to copy a line of text into a new destination file.


Using "synchronize" module
-----------------------------------

-> "ansible.posix.synchronize" is using the "rsync" command to synchronize files from
    the control host to managed hosts.

-> "ansible.posix.synchronize" is more efficient for copying large amount of files than
    "ansible.builtin.copy".

-> It does require the "rsync" software to be installed on all the hosts involved.

-> Use the "delegate_to" argument to change the source host to a host different than localhost.


Using "fetch" module
-------------------------------

-> "ansible.builtin.fetch" can be used to fetch a file from a managed machine and store it on
    the control host.

-> It will store files by appending hostname/path/to/file ot the fetched file.

-> Use the "flat" argument to override this behavior and store just the filename.


Example -

ansible-doc -t module ansible.builtin.blockinfile
ansible-playbook ansible-core-concepts/managing-files/copy.yml


Changing File contents
--------------------------------

-> "ansible.builtin.copy" can be used to create files with simple contents.

-> "ansible.builtin.replace" is used for simple replacements.

-> "ansible.builtin.lineinfile" can be used to manipulate single lines in a text file.

-> "ansible.builtin.blockinfile" is useful for manipulating complete blocks of text.


Using "copy" and "replace"
---------------------------------

-> "ansible.builtin.copy" and "ansible.builtin.replace" can be used for simple operations.

-> Use the "content" argument to the "copy" module to copy a string into a destination file.

    ansible all -m copy "content=hello dest=/temp/hellofile"

-> The "replace" module allows you to replace file contents based on regular expression.

  -> Use "regexp" to identify the regular expression you want to replace.
  -> Use "replace" to specify the replacement text.
  -> Omit the "replace" argument if you just want to remove text.


Using "lineinfile" and "blockinfile"
-----------------------------------------

-> Use "lineinfile" to add a single line to a file.

-> Use "blockinfile" to add multiple lines to a file.

Example -

ansible-playbook ansible-core-concepts/managing-files/add_custom_facts.yml
ansible all -m setup -a 'filter=ansible_local'


Using the "find" Module
-----------------------------------------

-> The "ansible.builtin.find" module is used to perform operations on multiple files.

-> It is similar to the Linux "find" command.

-> Use it with regular expressions, or in combination with "lineinfile" to perform modifications
    on multiple files.

-> When using the "register" keyword together with "find", you can easily build a playbook to
    change files regardless of their exact location.

Example -

ansible-playbook ansible-core-concepts/managing-files/change_config.yml



Understanding Jinja2 Template
-----------------------------------------------

-> Jinja2 is a templating engine for Python.

-> It is used to generate dynamic content based on Python expressions within templates.

-> Ansible uses Jinja2 for different purposes:

    -> To process variables
    -> To control the flow of a playbook using conditional statements
    -> In templates
    -> In filters to change how variables are interpreted


Understanding Templates
-----------------------------------------------
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_lookup.html

-> A template is a sample configuration file that is combined with Jinja2 variables to
    produce site-specific configuration files.

-> Templates are based on the Jinja2 templating language.

-> In advanced templates, conditional structures as well as loop structures can be used.

Example -

ansible-playbook ansible-core-concepts/managing-files/vsftpd-template.yml


Using Conditional Statements in Templates
------------------------------------------------

-> In Jinja2, variables and logic expressions are placed between delimiters.

-> To evaulate a variable, it is placed between {{  }}

-> Logic expressions are written as, {% EXPR %} and are used for control structures or loops.

-----------------
{% for file in myfiles %}
  {{ file }}
{% endfor %}
-----------------

-----------------
{% for user in myusers if not user == "root" %}
User {{ myuser }} has number {{ loop.index }}
{% endfor %}
-----------------

https://docs.ansible.com/ansible/latest/reference_appendices/faq.html

Example -

ansible-playbook ansible-core-concepts/managing-files/hosts_info.yml
ansible ansible_vms -a "cat /tmp/hosts"


Reusing Jinja2 generated content
-------------------------------------------
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_lookup.html

-> Result of Jinja2 template can be pulled, and used with other modules using "lookup" method.

----------
- name: show templating results
  ansible.builtin.debug:
    msg: "{{ lookup('ansible.builtin.template', './some_template.j2') }}"

- name: show templating results with different variable start and end string
  ansible.builtin.debug:
    msg: "{{ lookup('ansible.builtin.template', './some_template.j2', variable_start_string='[%', variable_end_string='%]') }}"

- name: show templating results with different comment start and end string
  ansible.builtin.debug:
    msg: "{{ lookup('ansible.builtin.template', './some_template.j2', comment_start_string='[#', comment_end_string='#]') }}"
-----------

Example -

ansible-playbook ansible-core-concepts/managing-files/configure_etc_hosts.yml
ansible ansible_vms -a 'cat /tmp/etc_hosts'

MANAGING_FILES_COMMENTS


