:<<'USING_CONDITIONALS_COMMENTS'

Understanding Loops
---------------------------------

-> The "loop" keyword allows you to iterate a simple list of items.

-> Before Ansible 2.5, the "with_" keyword was used instead.

----------------------------------
- name: start some services
  service:
    name: "{{ item }}"
    state: started
  loop:
    - vsftpd
    - httpd
----------------------------------

Example:

ansible-playbook ansible-core-concepts-and-advanced-features/using-conditionals/loop_demo-1.yml


Using Variables to Define a Loop
--------------------------------------------

-> The list that "loop" is using can be defined by a variable:

----------------------------------
vars:
  my_services:
    - httpd
    - vsftpd
tasks:
  - name: start some services
    service:
      name: "{{ item }}"
      state: started
    loop: "{{ my_services }}"
----------------------------------

Example:

ansible-playbook ansible-core-concepts-and-advanced-features/using-conditionals/loop_demo-2.yml


Using Dictionaries in Loops
-----------------------------------

-> Each item in a loop can be a hash/dictionary with multiple keys in each hash/dictionary.

------------------
- name: create users using a loop
  hosts: all
  tasks:
    - name: create users
      user:
        name: "{{ item.uname }}"
        state: present
        groups: "{{ item.ugroups }}"
      loop:
        - uname: anna
          ugroups: wheel
        - uname: linda
          ugroups: users
------------------

Example:

ansible-playbook ansible-core-concepts-and-advanced-features/using-conditionals/loop_demo-3.yml


"loop" versus "with_"
---------------------------------------------

-> The "loop" keyword is the current keyword.

-> In previous versions of Ansible, the "with_*" keywords were used for the same purpose

-> Using "with_X" often is easier, but using plugins and filters offer more options.
  -> "with_items": equivalent to the "loop" keyword
  -> "with_file": the "item" contains a file which content is used to loop through
  -> "with_sequence": generates a list of values based on a numeric sequence

-> Look up "Migrating from with_X to loop" in the Ansible documentation for instructions
    on how to migrate.


Understanding Handlers
--------------------------------------

-> Handlers run only if the triggering task has changed something.

-> By using handlers, you can avoid unnecessary task execution.

-> In order to run the handler, a "notify" statement is used from the main task.

-> Handlers typically are used to restart processes or reboot hosts.

-----------------
- name: Copy index.html
  copy:
    src: /tmp/index.html
    dest: /var/www/html/index.html
  notify:
    - restart_web
handlers:
  - name: restart_web
    service:
      name: httpd
      state: restarted
-----------------

Example:

# create /tmp/index.html on managed host
ansible server_ansible -m file -a "path=/tmp/index.html state=touch"

# ensure dest directory exists
ansible server_ansible -m file -a "path=/var/www/html state=directory"

# cleanup file on destination if required
ansible server_ansible -m file -a "name=/var/www/html/index.html state=absent"

# run playbook
ansible-playbook ansible-core-concepts-and-advanced-features/using-conditionals/hander-1.yml


Using Handlers
-------------------------------------------

-> Handlers are executed after running all tasks in a play.

-> Use "meta: flush_handlers" to run handlers now.

-> Handlers will only run if a task has changed something.

-> If one of the next tasks in the play fails, the handler will not run, but this
    may be overwritten using "force_handlers: True"

-> One task may trigger more than one handler.

Example:

# create /tmp/index.html on managed host
ansible server_ansible -m file -a "path=/tmp/index.html state=touch"

# Run playbook
ansible-playbook ansible-core-concepts-and-advanced-features/using-conditionals/setup_web_server.yml

USING_CONDITIONALS_COMMENTS


