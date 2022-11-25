# Ansible set-up

The purpose of this document is to get up and running with Ansible with fixed directory structure. We will refer standard practices and initialization approach with Ansible to get new comers upto the speed. 

The directory structure that we are going to follow will be as below. 

## Ansible Directory Structure
```
mactest:ansible aniruddhajawanjal$ pwd
/Users/aniruddhajawanjal/Devops/Tools/ansible
mactest:ansible aniruddhajawanjal$ tree
.
├── README.md
├── Vagrantfile
├── ansible.cfg
├── inventory
│   ├── production
│   ├── staging
│   └── vagrant
├── playbook.yml
└── roles
    ├── common
    │   ├── ssh-devops
    │   │   ├── README.md
    │   └── sys-manager
    │       ├── README.md
    ├── custom
    └── galaxy

20 directories, 25 files
```

Where,

* README.md: This file
* Vagrantfile: Vagrantfile to test Ansible roles with Vagrant
* Inventory: This directory will contain the inventory files for each environment with server details where Ansible will run. 
* playbook.yml: This will be Ansible playbook. It can be environment specific such as staging.yml, production.yml or functionality specific such as webserver.yml, dbserver.yml. It can be decided depending on the requirement. 
* Roles: It contains all the roles required for Project. Each directory will have different goal.
		common: This directory will have roles which will be used for all servers  i.e. common roles
		custom: custom directory will contain specific roles created for project requirement. 
		galaxy: Roles downloaded from Ansible Galaxy.

--------------------------------------------------------------

## Ansible Config file

`ansible.cfg` file is INI format file which contains configuration options for Ansible run. We prefer to keep it in the directory where project code is kept. Ansible will look for ansible.cfg file in following order.

* `ANSIBLE_CONFIG` (environment variable if set)
* `ansible.cfg` (in the current directory)
* `~/.ansible.cfg` (in the home directory)
* `/etc/ansible/ansible.cfg`

Ansible will process the above list and use the first file found, all others are ignored. 

--------------------------------------------------------------


## Usefull Commands 

### Checking server reachability
```
ansible all -m ping
```

### Creating a new role
```
ansible-galaxy init test-role-1
```

### To install Ansible Galaxy role: 
```
ansible-galaxy install --roles-path . geerlingguy.apache
```

### Playbook dry run
```
ansible-playbook foo.yml --check --diff
```

### Limiting task with tags
```
ansible-playbook playbooks/PLAYBOOK_NAME.yml --tags 'install'
```

### Skip roles with Tags matching
```
ansible-playbook playbooks/PLAYBOOK_NAME.yml --skip-tags 'sudoers'
```

### Checking Synatax
```
ansible-playbook playbooks/PLAYBOOK_NAME.yml --syntax-check
```

--------------------------------------------------------------

## Ansible with Vagrant 

https://docs.ansible.com/ansible/latest/scenario_guides/guide_vagrant.html


We will be using vagrant provisioner. For the first time, you will need to do `vagrant up` to get vagrant started with Vagrantfile in place. 

One issue that I faced was, vagrant machine didn't have python installed which is required for Ansible. So, I had to do `vagrant ssh`, install python and do `vagrant provision` again. Every time we make any change to playbook.yml, we will need to run `vagrant provision`.

--------------------------------------------------------------

## Manipulating secrets in Ansible

We can either use Ansible Vault or AWS SSM or Hashicorp Vault depending on the project requirement. Better approach would be to use Ansible Vault as this is piece of configuration management solution. If we want to avoid any dependency on some specific tool, it would make more sense to use third party tool like Hashicorp Vault to store the secrets, credentials etc. 

--------------------------------------------------------------

### Ansible with Windows
There are various Server management tasks that can be accomplished using Ansible.

1. Installing softwares and updates
2. Running commands
3. Creating and running scheduled tasks
4. Installing package managers
5. Setting up users and groups

The example below demonstrates a specific package manager installation using Ansible on the Windows server.

 
### For managing Windows servers with Ansible, we need the following setup:

1. A controller node, that typically runs a Linux operating system, preferably CentOS 7 64 bit or Ubuntu 12.04 64 bit or a higher version.
`(This is the server where we will be installing and running the Ansible playbook in a virtual environment).`

2. A node running a windows7 or Windows10 equivalent instance, preferably Windows 2008 server or higher, with .NET framework 4.0 or higher, Powershell 3.0 or higher.
`(This is the server that we're going to manage using the Controller node).`

For Ansible to run, the main required component is Python, with version 2.7 or higher, but having Python version 3+ installed on our Linux Controller node is better. If it isn't, we can install it using 

`sudo yum install python3
`

* Assuming that we're mostly going to run the above mentioned nodes on AWS EC2 instances, we need to take care of a few things:

1. Instance type should be t3.medium or higher.

2. Try to keep the public IP's of both the nodes fixed, (use elastic IP's).

* To have a dedicated environment for our ansible setup to run, and also to avoid dependancy issues and package conflicts, we create a virtual environment on our Controller node:

`
sudo yum install python-virtualenv
`

* After installing the virtual environment. we can set it up by issuing the following command:

`
virtualenv <ansible_env_name> ----> (we can give any name to the environment).
`

* We then need to activate the environment:

`source <ansible_env_name>/bin/activate
`

Once activated the prompt now changes to the name that we gave the environment. 

* In the new (virtual) environment, we install ansible:

`
pip install ansible
`

* We then test our installation by trying to connect to the ansible server:

`
 ansible localhost -m ping
`

* Our installation makes sense if we get the following output:

`
localhost | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
`

* We need to define the Windows host (Windows node in our case) in a host file. We therefore create and edit the host file in the following path:

`
vim /etc/ansible/hosts
`

...and define the following in it:



 `[winhost]`

`15.206.186.162`

`[winhost:vars]`

`ansible_user=Administrator`

`ansible_password=.yU-QQs$YRB2!tndLEA)Vq)9zoq5D=IR`

`ansible_connection=winrm`

`ansible_winrm_server_cert_validation=ignore`


* Then we proceed further and install Windows Remote Management (Pywinrm):

`
 pip install pywinrm
`

* On the Linux Controller node end, we are done. 

--------------------------------------------------------------------------

Configuring the Windows host:
------------------------------

* WinRM (Windows Remote Management) can be installed using a script which you can find here: 
https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1

We copy-paste the entire script into notepad and save it as "ConfigureRemotingForAnsible.ps1" in the appropriate directory.
We right click on the script and select "run with powershell". Once it runs successfully, we try to connect to the Windows node using:

`
 ansible winhost -m win_ping
`

* We're going right if we see something like: 

`15.206.186.162 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}`


* We finally create a playbook, to control and manage tasks in the Windows node. 
Lets say we want to install the chocolatey package manager in our Windows instance.

`vim chocolatey.yml`

* we add the following configuration to it:


`---`

`- hosts: winhost`
  `gather_facts: no`
  `tasks:`
   `- name: Install Chocolatey on Windows10`
     `win_chocolatey: name=procexp  state=present`
     

* Lastly, we execute the playbook:

`ansible-playbook chocolatey.yml
`

We should see the output like:

`PLAY [winhost] *******************************************************************************************************************************`

`TASK [Install Chocolatey on Windows10] *******************************************************************************************************`
`[WARNING]: Chocolatey was missing from this system, so it was installed during this task run.`

`changed: [15.206.186.162]`

`PLAY RECAP ***********************************************************************************************************************************`
`15.206.186.162             : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0`

















