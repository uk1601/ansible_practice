sys-manager
=========

This role would configure the system as part of standard best practices.

Requirements
------------

Just access to system. This role will install all the required packages like telnet, vim. htop, smem, tcpdump etc. 
Also, manage the required system parameters like 

Role Variables
--------------

status: enable || disable

If enabled, 

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

aniruddha.jawanjal[at]outlook.com
