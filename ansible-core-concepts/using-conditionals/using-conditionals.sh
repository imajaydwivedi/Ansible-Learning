:<<'USING_CONDITIONALS_COMMENTS'

https://spacelift.io/blog/ansible-loops
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html


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

ansible-playbook ansible-core-concepts/using-conditionals/loop_demo-1.yml


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

ansible-playbook ansible-core-concepts/using-conditionals/loop_demo-2.yml


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

ansible-playbook ansible-core-concepts/using-conditionals/loop_demo-3.yml


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
ansible-playbook ansible-core-concepts/using-conditionals/hander-1.yml


Using Handlers
-------------------------------------------

-> Handlers are executed after running all tasks in a play.

-> Use "meta: flush_handlers" to run handlers now.

-> Handlers will only run if a task has changed something.

-> If one of the next tasks in the play fails, the handler will not run, but this
    may be overwritten using "force_handlers: True"

-> One task may trigger more than one handler.

Example:

# create /tmp/index.html on controller node
ansible localhost -m file -a "path=/tmp/index.html state=touch"

# Run playbook
ansible-playbook ansible-core-concepts/using-conditionals/setup_web_server.yml

# Enable "force_handlers" attribute

# Re-run the playbook with force_handlers enabled
ansible-playbook ansible-core-concepts/using-conditionals/setup_web_server.yml

# To trigger handler, a change in task is required. So remove the dest file
ansible server_ansible -m file -a "name=/var/www/html/index.html state=absent"


Using ansible.builtin.meta module
-------------------------------------------------

-> Handlers are executed at the end of the play

-> To change this behaviour, the "ansible.builtin.meta" module can be used.

-> This module specifies options to influence the Ansible internal execution order:
    -> flush_handlers: will run all notified handlers now
    -> refresh_inventory: refreshes inventory at the moment it is called
    -> clear_facts: removes all facts
    -> end_host: ends playbook execution for this host


Using when to Run Tasks in Specific Situations
-----------------------------------------------------------

-> "when" statements are used to run a task conditionally.

-> "when" can be used to run a task only if specific conditions are true.

-> Playbook variables, registered variables, and facts can be used to check conditions in "when" statements.

-> For instance, check if a task has run successfully, a certain amount if memory is available,
    a file exists, etc.

-> When using "when", it is important to address the right variable type.


Example Conditionals
------------------------------

ansible_machine == "x86_64"                 :  Variable value is a string
ansible_distribution_version == "8"         :  Variable value is a string
ansible_memfree_mb == 1024                  :  Variable value is equal to integer
ansible_memfree_mb < 256                    :  Variable value is smaller than integer
ansible_memfree_mb > 256                    :  Variable value is bigger than integer
ansible_memfree_mb <= 256                   :  Variable value is smaller than or equal to integer
ansible_memfree_mb != 512                   :  Variable value is not integer
my_variable is defined                      :  Variable exists (nice for facts)
my_variable is not defined                  :  Variable does not exist
my_variable                                 :  Variable is Boolean true
ansible_distribution in supported_distros   :  Variable contains another variable



Understanding Variables Types
---------------------------------------------

-> String: sequence of characters - the default variable type in Ansible
-> Numbers: numeric value, treated as integer or float. A number placed in quotes is treated as a string.
-> Booleans: true/false values (yes/no, y/n, on/off also supported)
-> Dates: calender dates
-> Null: undefined variable type
-> List or Arrays: a sorted collection of values
-> Dictionary or Hash: a collection of key/value pairs


Using Filters to Enforce Variable Types
---------------------------------------------------

-> While working with variables in a "when" statement, the variable type may be interpreted wrongly.

-> To ensure that a variable is treated as a specific type, filters can be  used
  -> int (integer)
      when vgsize | int > 5
  -> bool (boolean)
      when runme | bool

-> Using a filter does not change the variable type, it only changes the way it is interpreted.

Example -

ansible server_ansible -m setup -a "filter=ansible_date_time"
ansible-playbook ansible-core-concepts/using-conditionals/distro.yml
ansible-playbook ansible-core-concepts/using-conditionals/weekday_test.yml


Testing Multiple Conditions
-----------------------------------------

-> "when" can be used to test multiple conditions as well.

-> use "and" or "or" and group the conditions with parentheses.

------------
when: ansible_distribution == "CentOS" or ansible_distribution == "Redhat"
when: ansible_machine == "x86_64" and ansible_distribution == "CentOS"
------------

-> The "when" keyword also supports a list and when using a list, all of the conditions must be true.

-> Complex conditional statements can be group conditions using parentheses.

Example -

ansible-playbook ansible-core-concepts/using-conditionals/when_multiple.yml

ansible-playbook ansible-core-concepts/using-conditionals/if_size.yml


Using Register Conditionally
-------------------------------------------------

-> The "register" keyword is used to store the results of a command or tasks.

-> Next, "when" can be used to run a task only if a specific result was found.

-------------
- name: show register on random module
  user:
    name: "{{ username }}"
  register: user
- name: show register results
  debug:
    var: user
  when: user is defined
-------------

Example:

ansible-playbook ansible-core-concepts/using-conditionals/register.yml
ansible-playbook ansible-core-concepts/using-conditionals/find_user.yml


Using Blocks
-------------------------

-> A block is a logical group of tasks

-> It can be used to control how tasks are executed.

-> For instance, one block can be enabled using a single "when".

-> Notice that "items" cannot be used on blocks.

-> Blocks can be used in error condition handling:
  -> Use "block" to define the main tasks to run.
  -> Use "rescue" to define tasks that run if tasks defined in the block fail.
  -> Use "always" to define tasks that will always run

----------------
- name: using blocks
  hosts: ansible_vms
  tasks:
  - name: intended to be successful
    block:
    - name: remove a file
      shell:
        cmd: rm /var/www/html/index.html
    rescue:
    - name: create a file
      shell:
        cmd: touch /tmp/rescuefile
----------------  

Example -

ansible all -m setup -a "filter=ansible_os_family"
ansible all -m setup | grep -i family
ansible all -m setup | less

ansible-playbook ansible-core-concepts/using-conditionals/blocks.yml
ansible-playbook ansible-core-concepts/using-conditionals/blocks-2.yml


Using the "assert" Module
--------------------------------------

-> The "assert" module can be used to show a message on success and on failure.

-> It's a bit like the "fail" module, but with more advanced options.

Example -

ansible server_ansible -m stat -a 'path=/etc/hosts'
ansible-playbook ansible-core-concepts/using-conditionals/assertstat.yml
ansible-playbook ansible-core-concepts/using-conditionals/assertsize-wrong.yml

USING_CONDITIONALS_COMMENTS


