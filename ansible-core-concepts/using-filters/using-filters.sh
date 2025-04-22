:<<'USING_FILTERS_COMMENTS'

<< Read => ../using-plugins.sh >>

Filter and Collections
---------------------------------------------

-> Filters (like other plugins) are provided by collections.

-> use "ansible-doc -t filter -l" for a list of current installed filters, including the collection they come from.

-> To refer to filters in an unambiguous way, use the FQCN.

-> Custom filters can be created by users.

-> To make these available, they can be provided as plugins in an Ansible Content Collection.

-> By providing filters in content collections, users can extend the core functionality of Ansible.


Demo: Using Custom Filters
------------------------------------

-> The repo has the directory <current-proj>/my_collection, which contains a complete collection directory structure.

-> use "tree" to investigate the structure.

-> use "cat my_collection/plugins/filters/phone_format.py" to check the Python script behind the filter.

-> Use "ansible-galaxy collection build my_collection" to build your collection.

-> Use "ansible-galaxy collection install mynamespace-my_collection[Tab]" to install the collection.

-> Use "cat phonenumber.yml" to see how the filter is used.

-> Run it, using "ansible-playbook phonenumber.yml"


Understanding Filters
----------------------------------------

-> A filter is a lookup plugin that allows you to manipulate data.

-> Many filters are available in Ansible.

-> Apart from that, Jinja2 filters can be used in Ansible; these are a part of the Jinja2 templating language.

-> Filters process the value of a variable on the control host before further using it in the playbook.

-> While using filters, it is important to know which variable type you're dealing with.


Understanding Variable Types
-----------------------------------------

-> String: sequence of characters - the default type in Ansible
-> Numbers: numeric value, treated as integer or float. When placing a number in quotes it is treated as a string.
-> Booleans: true/false values (yes/no, y/n, on/off also supported)
-> Dates: calendar dates.
-> Null: undefined variable type.
-> List or Arrays: a sorted collection of values.
-> Dictionary or Hash: a collection of key/value pairs.

Recognizing Variable Types
----------------------------------------

-> In the output of, for instance, fact gathering, different variable types can be recognized
    by the way in which they are written.

    -> String: a value between quotes:
        "config_mode": "enforcing"
    -> Numbers: a value that is not between quotes:
        "serial": 0
    -> Booleans: Booleans are set in inventory and ansible.cfg
    -> Date: "date": "2021-12-30"
    -> Null: undefined variable type - only occurs on undefined variables.


Processing Variables with Filters
---------------------------------------------

-> Filters allow variables to be processed before using them in Ansible.

-> Filters do not change the value of a variable, they just change how the variable is being
    used and for that reason you may have to use the same filter multiple times.

-> Use "{{ varname | filter }}" to identify the filter to be used.

-> See int_filter.yaml and storage_filter.yaml for example.


Exploring Common Filters
----------------------------------------------

-> "mandatory" fails a play if a variable does not have a value:
    {{ my_var | mandatory }}

-> "default" will set a variable without value to a default value. Add the optional True to also set the
    variable if it has an empty string or boolean False as its value:
    {{ my_var | default(myvalue, True) }}

-> "capitalize" will capitalize a string

-> "int" will convert a variable to an integer

-> "float" converts a variable to a float

-> "+ - / *" perform basic calculations:
    {{ ( vgsize | int) - 1 }}

-> "union" create a single list based on multiple input lists

-> "random" extracts a random element from a list:
    {{ [a,b,c] | random }}

-> "sort" will sort a list:
    {{ [4,8,2,6] | sort }}

-> "password_hash" generates a hashed password

-> "quote" is used to put command output between quotes so that is is sanitized.

Example -

ansible-playbook ansible-core-concepts/using-filters/password_hash.yaml
ansible server_ansible -m user -a "name=sharon state=absent"


Understanding the ipaddr Filter
-------------------------------------------
https://docs.ansible.com/ansible/latest/collections/ansible/utils/ipaddr_filter.html

-> The "ipaddr" filter works on IP addresses to show specific IP address related output.

-> Before using, install the "netaddr" as well as "dnspython" package on Ubuntu.
-> Before using, install the "python3-netaddr" as well as "python3-dns" package on Redhat family.

-> It has different arguments that allow you to perform specific manipulations:

    -> "address" validates that input contains valid IP addresses
    -> "net" validates that input values are network ranges
    -> "host" ensures that IP addresses conform to CIDR prefix format
    -> "prefix" returns the network address prefix
    -> and many more

-> Look for "ipaddr filter" in the documentation for a complete list.
-> To use it in a playbook, specify: ansible.utils.ipaddr.

ansible-galaxy collection install ansible.netcommon
ansible-galaxy collection install ansible.utils

Example -

ansible-playbook ansible-core-concepts/using-filters/network.yaml


Understanding the "map" Filter
-----------------------------------------

-> The "map" filter is used to lookup an attribute.

-> It is useful when dealing with list of objects where you're only interested in one specific value

    -> If, for instance, the "find" module is used to find files, multiple attributes are shown
        and "map" can be used to filter just one of them.
    -> "map" can work with optional arguments, such as the "relpath" function, which is useful in
        displaying filenames relative to a directory.

-> Notice that "map" returns a list by default. To show the output as a single line, use the "join" filter as well.

# ansible server_ansible -m shell -a 'touch /var/www/html/{one,two,three}'
# ansible server_ansible -a 'mkdir /var/www/html/alerts'
# ansible server_ansible -a 'touch /var/www/html/alerts/cpu'
# ansible-playbook ansible-core-concepts/using-filters/filemap.yaml


Understanding the "flatten" Filter
----------------------------------------------

-> "flatten" recursively searches list items and flattens them into one list.

-> This is useful when a variable contains a nested list.

-> Have a look at flatlist.yml for a simple example.


Understanding the "subelements" Filter
-----------------------------------------------

-> The "subelements" filter allows you to create a new list based on subelements in complex data structures.

-> A subelement is a list within a list, and while using subelements the top level item in the list
    is referred to as "item.0" and the second level item in the list as "item.1".

Example -

ansible-playbook ansible-core-concepts/using-filters/subelements.yml


Understanding the "dict2items" Filter
----------------------------------------------

-> You cannot use "loop" over a dictionary.

-> Use "dict2items" to transform a dictionary into a list and allow looping over it.

Example -

ansible-playbook ansible-core-concepts/using-filters/dict2items.yaml


Using the "selectattr" Filter
------------------------------------------------

-> The "selectattr" filter is used to select elements from a list based on their attributes.

-> For instance, if a list of users has the attribute group set to the value sales, you can use
    it to show only those users where the attribute matches the specific value.

Example -

ansible-playbook ansible-core-concepts/using-filters/selectattr.yaml


Lab Exercise
------------------------------------------

Write a playbook that configures firewall rules. The playbook should define variables to
specify what should happen in the firewall regarding specific services. Make sure you work
with the name of the service, the state you need this server to be in, and the firewall zone
in which it should be configured.

Also make sure that if the state is not specified for a service, then default state "enabled"
will be used, and make sure that if the zone is not specified, it will be omitted.

--------
firewall_services:
  - name: ssh
    state: enabled
    zone: public
  - name: http
  - name: https
    state: disabled
  - name: dns
    zone: internal
--------

ansible-playbook ansible-core-concepts/using-filters/lab_using_filters.yml






USING_FILTERS_COMMENTS


