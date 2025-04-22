:<<'USING_MODULE_DOCUMENTATION_COMMENTS'

Using ansible-doc
-------------------------------

-> "ansible-doc" provides information about modules and much more.

-> It lists all available module arguments, as well as some examples of how to use
    the modules in a playbook.

-> Use "ansible-doc -l" for a list of all modules

-> Use "ansible-doc modulename" for all information about "modulename"

-> Use "ansible-doc -s modulename" to see arguments that can be used while working
    with a module.

-> Use "ansible-doc -t" to get documentation for different Ansible features, like
    keywords, plug-ins, filters, and more


ansible-navigator Documentation
------------------------------------------

-> "ansible-navigator" includes module documentation.

-> use "ansible-navigator doc modulename" to access it.


USING_MODULE_DOCUMENTATION_COMMENTS

# Get all keywords & filter for "become"
ansible-doc -t keyword -l | grep -C 1 become

ansible-navigator