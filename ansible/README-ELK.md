Using Ansible To Deploy ELK on RHEL 7.7.

1. Prerequisites
    1.1. Downloading Elasticsearch 
        - https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.0-x86_64.rpm
        - Rename to "elasticsearch-${version}.rpm"
        - Move to roles/elasticsearch/files/elasticsearch-${version}.rpm

    1.2 Downloading Kibana 
       - https://artifacts.elastic.co/downloads/kibana/kibana-7.9.0-x86_64.rpm 
       - Rename to "kibana-${version}.rpm"
       - Move to roles/kibana/files/kibana-${version}.rpm

    1.3 Downloading logstash 
      - https://artifacts.elastic.co/downloads/logstash/logstash-7.9.0.rpm  
      - Rename to "logstash-${version}.rpm"
      - Move to roles/logstash/files/logstash-${version}.rpm

    1.4. Using Ansible Vault to Store Credentials

      1.4.1 command to create vault

         # ansible-vault create secrets.yml
           
      1.4.2 command to edit secrets.yml file
           
         # ansible-vault edit secrets.yml
           
      1.4.3 create a variable password which will be used to create users
        
         - contents of secrests.yml
           |> 
            password: "secret-vaule"
            encryption_key: "min length 32"
            elastic_user: "elastic_admin"
            cluster_name: "Ansible-ELK"

 2. Usage

    2.1> Default Variables
        - version: "7.8.1"
        - elastic_user: "elastic_admin" #dont create elastic or admin user  
        - password: "secret" # use ansible-vault seacrets.yml file
        - encryption_key: "secret" # length of the password must be >= 32 
     
	  2.2> sample-playbook.yml
	+++++++++++++++++++++++++++++++++
	---

	- hosts: ELK
	  name: "Installing ELK on RHEL"
	  become: yes
	  become_user: root
	  vars_files:
	     - defaults/main.yml
	  roles:
	    - {role: java}
      - {role: certificate}
	    - {role: elasticsearch}
      - {role: kibana}
      - {role: logstash}
	++++++++++++++++++++++++++++++++++

	  2.3> Running Playbook
	     
       # ansible-playbook  -i inventory main.yml -e "@secrets.yml" --ask-vault-pass

3. After successfull installation open up browser 
   and go to http://${ip}:5601 you should be able to login to kibana using the credentials.
	    




