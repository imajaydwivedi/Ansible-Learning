:<<'USING_PLUGINS_COMMENTS'

Understanding Plugins
----------------------------------------

-> A plugin is an extension to the Ansible code that is written in Python.

-> Standard plugins are provided, and additional plugins can be added through content collections.

-> Some plugins need to be enabled in ansible.cfg.

-> A filter is a plugin type that allows you to modify data.

-> Filters are typically used to change variables before using them.

-> As there are many filters available, these are covered separately from other plugins in next lesson


Understanding Plugin Types
-------------------------------------------------

-> Plugins are provided to add different types of functionality:

  -> Filter plugins: used to modify text
  -> Cache plugins: plugins that allow caching of facts
  -> Inventory plugins: plugins that allow different types of dynamic inventory
  -> Lookup plugins: a very wide range of plugins that allow fetching data externally
  -> Callback plugins: plugins that are used to collect usage information about Ansible

-> There are different plugin types, each of which is documented independently

  -> Use "ansible-doc -t <plugin-type> -l" for a list


Common Ansible Plugin Types
-------------------------------------------

-> action: used behind the scenes when using modules from playbooks

-> cache: used to cache inventory or facts

-> callback: control playbook output

-> connection: defines how to connect to a host; uses ssh by default

-> filter: manipulates variable and text values

-> inventory: dynamically generated inventory

-> lookup: used to access data from external resources

-> test: used in conditional statements to perform specific tests


Exploring Lookup Plugins
------------------------------------------

-> Lookup plugins are created to use data from external sources like files and environment variables.

-> Many lookup plugins are provided.

-> Use "ansible-doc -t lookup -l" for complete list.

-> Use "ansible-doc -t lookup <plugin-name>" for documentation of a specific plugin.


Using Lookup Plugins
-------------------------------------

-> Lookup plugins can be called in two ways: "lookup" and "query"

  -> "lookup" is used to read file content into a variable.
  -> "query" is used to read file content into a variable, where file content is stored as a list.


Useful Lookup Plugins Overview
------------------------------------------

-> "file": reads content of files from the control node

-> "template": processes the contents of a template
    {{ lookup('template', 'mytemplate.j2') }}

-> "env": uses an environment variable that is set on the control node
    {{ lookup('env', 'DB_PASSWORD') }}

-> "url": gets the contents from a URL
    {{ lookup('url', 'http://example.com') }}

-> "pipe": returns the output of a command executed on the control host
    {{ query('pipe', 'ls files' }}

-> "k8s": fetches a Kubernetes object
    {{ lookup('k8s', kind='Deployment', namespace='default') }}


Using the file Lookup Plugin
-------------------------------------------------

-> The following example uses the "file" lookup plugin to read the contents of the
    file /etc/passwd into the variable myusers:

    vars:
      myusers: "{{ lookup('file', '/etc/passwd') }}

-> The file plugin can take multiple filenames as its argument, where each file
    name will be separated by a comma

    vars:
      myfiles: "{{ lookup('file', '/etc/hosts', '/etc/motd') }}"

-> Use query to store the contents of multiple files:

    vars:
      myfiles: "{{ query('file', '/etc/hosts', '/etc/motd') }}"

Example -

ansible-playbook ansible-core-concepts/using-plugins/read-keys.yaml
ansible-playbook ansible-core-concepts/using-plugins/url.yaml
ansible-playbook ansible-core-concepts/using-plugins/users-with-password.yaml


Lookup Plugins: Using env and template
-------------------------------------

-> The "env" lookup plugin is used to set a variable based on the value of a shell variable on
    the managed host.

-> Combined with the "default" filter this has nice potential to automatically modify content based
    on local settings.

-> In particular, when combined with the "template" lookup plugin it can be useful.

-> Notice that the "template" lookup plugin is not the same as the template module: the
    "template" plugin is used to generate text that can be used in modules like "copy".

Example -

ansible-playbook ansible-core-concepts/using-plugins/set-language.yaml


Lookup Plugins: Using pipe and lines
---------------------------------------------------

-> The "register" keyword can be used to register the result of any module, but it contains too
    much information.

-> The "pipe" and "lines" lookup plugins are used to return specific output only.

-> "pipe" shows raw (unformatted) output of a command.

-> "lines" shows the content of a file.

Example -

ansible-playbook ansible-core-concepts/using-plugins/lines.yaml



Using the fileglob Plugin
-----------------------------------------

-> The "fileglob" lookup plugin can be used to iterate over a list of files according to
    a globbing pattern

-> When used as "{{ lookup('fileglob', '*') }}" it will provide a string of command-separated
    values for all files in the output.

-> To force the lookup plugin to return a list of values instead of a string of comma-separated
    values, use the "query" keyword instead of "lookup".

    {{ query('fileglob', '*') }}

    -> In the output, you see that it's a list because the data is encapsulated by brackets.

Example -

ansible-playbook ansible-core-concepts/using-plugins/fileglob-string.yaml


Using fileglob with Wildcards
-----------------------------------------

-> The Ansible "copy" module doesn't support wildcards.

-> Use the "fileglob" filter in a loop if you want wildcard functionality

-> Notice that this is not recommended for copying many files, as for every single file
    the "copy" module will be called.

Example -

ansible-playbook ansible-core-concepts/using-plugins/wildcard-copy2.yaml
ansible-playbook ansible-core-concepts/using-plugins/wildcard-copy1.yaml


Plugins-based Inventory
--------------------------------------

-> Inventory can be written in ini format (old) as well as YAML format (new).

-> Inventory since Ansible 2.4 is managed through plugins, the ansible.cfg lists which plugins
    are used in the [inventory] section.

-> Using plugins allows Ansible to support new inventory format by just providing a new plugin:

  -> "ini" plugin supports old-style inventory format
  -> "script" plugin supports old-style dynamic inventory
  -> "yaml" plugin supports new style YAML format

-> Using plugins is preferred over using dynamic inventory scripts.


Using the Ini Plugin
------------------------------------------

-> Ini-based Inventory example:

[webservers]
server1.example.com
server2.example.com

[dbservers]
server3.example.com
server4.example.com

[allservers:children]
webservers
dbservers


Using the YAML Plugin
-------------------------------------------

-> YAML-based Inventory example:

allservers:
  children:
    webservers:
      server1.example.com
      server2.example.com
    dbservers
      server3.example.com
      server4.example.com


Converting ini Inventory
---------------------------------------------------

-> Use "ansible-inventory" to convert ini-based inventory to YAML-based inventory.

  ansible-inventory --yaml -i inventory --list --output inventory.yaml

-> IMPORTANT: when the ini-based inventory contains variables, these may be messed up
    after conversion. You'll need to manually fix this.

-> To avoid this, use the recommended approch of putting your variables in group_vars/ and hosts_vars/


Understanding Inventory Sources
---------------------------------------------------

-> Inventory is plugin-based.

-> Use "ansible-doc -t inventory -l" for a complete list.

-> The "[inventory] enable_plugins" option in ansible.cfg determines which plugins are enabled.

    enable_plugins = host_list, script, auto, yaml, init, toml

    -> Notice that legacy inventory scripts are still supported using the script plugin!

-> Additional inventory plugins can be added in project-based ansible.cfg

-> Use the fully qualified collection name if the plugin is part of a collection.


Using Fact Caching
--------------------------------------------

-> After fact gathering, facts are kept in memory and stay there for the duration of playbook execution.

-> Plugins can be used to enable fact caching.

-> when using a plugin, facts should be gathered manually or as a scheduled job that is executed
    after expiration of the fact cache.

-> Next, all playbooks can run without fact gathering and access facts from the fact cache.


Demo: Configuring the "redis" Plugin
--------------------------------------------
https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-22-04

-> Redis is an in-memory database that can be used to cache data. Install it on the controller node

    sudo dnf install -y redis
    sudo apt install -y redis

    sudo systemctl enable --now redis
    pip show redis
    sudo pip install redis

-> Use ansible.cfg to specify plugin use under [defaults] section

  fact_caching = redis
  fact_caching_timeout = 3600
  fact_caching_connection = localhost:6379:0

# generate facts and cache them
ansible all -m setup

# check if fact gathering is working
python ansible-core-concepts/using-plugins/check-cache.py

# check if facts are accessing without automating gathering
ansible-playbook ansible-core-concepts/using-plugins/check-facts.yaml


Fact Caching Caveats
------------------------------

-> Once the fact cache expires, all playbooks that require facts and have "gather_facts: False" will fact

-> Run a scheduled job to refresh the fact cache automatically

-> To ensure a playbook does NOT use cache (but gathers facts instead) use

    ansible-playbook whatever.yaml --flush-cache


Generate random passwords - Using the "password" Lookup Plugin
-----------------------------------------------------------------------

-> The "password" Lookup Plugin can be used to generate random passwords and store
    these passwords in a local file.

-> Notice that strictly, the "password" plugin generates a random string; using it as a password makes it a password.

-> Use it to define a variable:

    mypassword: "{{ lookup('password', 'credentials/'+item+'length=6') }}"

    -> This defines a directory with the name credentials, with a file that matches the username so the password
        can be handed out to the user later.

-> After defining the variable, use it as a password by applying the "password_hash" filter

ansible-playbook ansible-core-concepts/using-plugins/users-with-password.yaml

ansible localhost -m debug -a 'msg="inventory_dir: {{inventory_dir}} || playbook_dir: {{playbook_dir}}"'


The "test" Plugin
---------------------------------------------------------------

-> If you feel that when keyword doesn't give enough options, you should explore the "test" plugin.

-> This plugin allows to test input on many properties

-> Use "ansible-doc -t test -l" for a list.

ansible-playbook ansible-core-concepts/using-plugins/test-ip.yml




USING_PLUGINS_COMMENTS

