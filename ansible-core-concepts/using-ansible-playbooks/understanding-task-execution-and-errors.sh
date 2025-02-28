:<<'UNDERSTANDING_TASK_EXECUTION_AND_ERRORS'

Playbook Errors
----------------------------------

-> If the playbook syntax has an error, the playbook will not run and you'll be notified.

-> If playbook syntax is correct, specific tasks may still result in an error.

-> If a task cannot run successfully and produces an error, further execution
    of the entire play on the failing host is stopped.

-> If this is undesired, use "ignore_error: true" in the play header or in the task.

Example:-

ansible-playbook ./ansible-core-concepts/using-ansible-playbooks/with_error.yml

UNDERSTANDING_TASK_EXECUTION_AND_ERRORS



