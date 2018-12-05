This is the README file and might be out of date.

----------------------------------------------------------------------
BEFORE ANYTHING
----------------------------------------------------------------------

In this work the linux box should have installed ansible, pip and boto. 
This list below works fine in ubuntu 16.04 (xenial) and debian 9 
(stretch) although other versions may work as well.

The shell script will try to install it first, but keep these in mind
these versions and packs:

ansible  2.6.3 (from ppa source)
python3  2.7.13
pip 18	

These below is a python lib list defined in the role base_AWS vars 
in which pip ansible module will try to install:
boto3    1.9.0
boto     2.49.0
botocore 1.12.0

AWS RDS instances have some issues with python3 (or boto??), so used 
python2.

----------------------------------------------------------------------
GENERAL STRUCTURE
----------------------------------------------------------------------
Basically an ansible with some external configs to SSH access - check 
\*.sh

The inventory is defined by the file “hosts” and the main playbook 
YAML file is Site.yml. Other files are important as well:

 - Files:

   - hosts - inventory for the site.

   - Site.yml - main playbook to get everything up and running.

   - AWS.yml - playbook used to build server, DB instance, sec 
     groups, etc.

   - base_AWS.yml - this playbook try to install basics like boto\*

   - Uninstall.yml - just to clean the server and restart  from scratch

   - aws.sh - runs base_AWS.yml and AWS.yml playbooks. After running 
     base_AWS.yml, it may be commented out.

   - site.sh - runs Site.yml playbook to build the site after aws.sh 
     is successful.

   - uninst.sh - runs the playbook to clean the server (Uninstall.yml)

 - Folder hierarchy (roles):

   - roles/
   - roles/AWS
   - roles/Backup
   - roles/base
   - roles/base_AWS
   - roles/common
   - roles/DB_adm
   - roles/Dolibar
   - roles/Drupal
   - roles/finals
   - roles/gitcfg
   - roles/phpcfg
   - roles/python
   - roles/Restore
   - roles/SSLcrt
   - roles/uninst
   - roles/users
   - roles/\*/{defaults,tasks,vars,templates,handlers}

 - Other folders:

   - group_vars - from ansible best practices - define vars for 
     each group of servers in an inventory 

   - vars_hosts - again from best practices - for specific hostnames

   - vars_files - used for specific vars files

   - facts.d - all data from AWS after deploying the platform

   - conf.d - SSH files built by AWS playbook - mandatory

   - test - self explanatory - unused by now

   - secret - sensitive data (apart from this dir level)

 - Other files:

   - conf.d/linux-key.pem - The key to SSH to login to site

   - conf.d/ssh_config - SSH client config with hostname and keypath

----------------------------------------------------------------------
BASIC RUNNING (helped by shell scripts)
----------------------------------------------------------------------

Probably the server (here named server2) is up and running. A first 
run of the playbook might be right to check it, as soon as all tasks
returns "ok".

Just do:

	prompt$ sh aws.sh
	prompt$ sh site.sh

To destroy just the server and start again:

	prompt$ sh uninst.sh

And again you may run the first two shell scripts to start over:

	prompt$ sh aws.sh
	prompt$ sh site.sh

----------------------------------------------------------------------
EXTRA VARIABLES SUPPLIED (--extra-vars) AND CURRENT CHOICES
----------------------------------------------------------------------

 - gather_y_n: false
   Up to now there is no need
 
 - update_cache_y_n: yes
   The module apt uses this variable. It's off in the script for a 
   while to speed things.

 - purge_y_n: false
   When uninstalling a package we may choose to purge

 - autoremove_y_n: false
   The same as above, we may uninstall the whole dependency tree

----------------------------------------------------------------------
VARIABLES OF MAIN INTEREST IN group_vars or vars_files and so on
----------------------------------------------------------------------

 - www_basedir: if using other than the default /var/www.

 - web_service: if using other package than nginx.

 - remove_list: when removing, if not using nginx nor mysql, should 
   alter here.

 - cert_base_path and key_base_path: change according to your needs.

 - cert_params_hash{C, ST, L, O, OU, etc}: change according to your 
   location.

 - drupal_version: in a future upgrade

 - drupal_basename: base site name within web rootdir.

 - db_list{admuser, admpass, host, user, pass, etc}: change to fit 
   your servers.

 - composer_required: the same as for drupal_version above - future 
   upgrade.

 - civicrm_download_url: when upgrading civicrm module.

 - drupal_private_files_dir and civicrm_extensions_dir: you may 
   choose any folder location.

----------------------------------------------------------------------
TEMPLATES
----------------------------------------------------------------------

All of them are mandatory to be checked. Templates are very particular 
to one site. They can be found here:

 - roles/Drupal/templates
 - roles/base/templates
 - roles/finals/templates

And

 - roles/AWS/templates

for AWS playbook. It defines the ssh_config using ssh_config.j2 template.

----------------------------------------------------------------------
THE PLAYBOOKs
----------------------------------------------------------------------
Here the output of "ansible-playbook -i hosts --list-tasks Site.yml" 
command:

----
playbook: Site.yml

  play #1 (webservers): webservers	TAGS: []
    tasks:
      common : Install python if not installed -------------------	TAGS: [bootstrap_python]
      common : Update cache and upgrade (may take a time) --------	TAGS: [update_repository]
      common : Install vary basic packages to run ansible --------	TAGS: [install_dep_pkg]
      base : Install dependency packages -----------------------	TAGS: [install_dep_pkg]
      base : Ensure directories dir_file_tmpl_list.types=dir ---	TAGS: [config_files, deploy_templates]
      base : Remove undesired files (absent in item.types) -----	TAGS: [config_files, deploy_templates]
      base : Deploy templates dir_file_tmpl_list.types=tmpl ----	TAGS: [config_files, deploy_templates]
      base : Make proper links dir_file_tmpl_list.types=link ---	TAGS: [config_files]
      base : Upload some files from a list when action=upload --	TAGS: [config_files, copy_files]
      base : Restart service after tmpl/file/link change -------	TAGS: [config_files, copy_files]
      base : Set some ini type files ---------------------------	TAGS: [config_files]
      base : Configure cron ------------------------------------	TAGS: [cron_config]
      base : Ensure services are started and enabled -----------	TAGS: [install_dep_pkg]
      users : Create some general purpose users -----------------	TAGS: [base_users]
      users : Retrieve priv key from list of users --------------	TAGS: [auth_keys, base_users]
      users : Fill in authorized_keys to each user of a list ----	TAGS: [auth_keys, base_users]
      gitcfg : Grant repodir permissions to git user -------------	TAGS: [git_config]
      gitcfg : Create some git projects on server ----------------	TAGS: [git_config]
      phpcfg : Set composer packs if required (PHP) --------------	TAGS: [php_config]
      phpcfg : Composer create-project using command line --------	TAGS: [php_config]
      python : Install local python dependencies via pip ---------	TAGS: [python_config]
      SSLcrt : Generate private key for account and csr ----------	TAGS: [acme_account, ssl_certificate]
      SSLcrt : Create local CSR certificate ----------------------	TAGS: [ssl_certificate]
      SSLcrt : Create ACME account with respective email ---------	TAGS: [acme_account, ssl_certificate]
      SSLcrt : Create certificate - 1st step challenge -----------	TAGS: [ssl_certificate]
      SSLcrt : Create directory structure for challenge ----------	TAGS: [ssl_certificate]
      SSLcrt : Copy resource to web site to complete the 2nd step	TAGS: [ssl_certificate]
      SSLcrt : Create certificate - 2nd step challenge -get certs-	TAGS: [ssl_certificate]
      SSLcrt : Copy new cert and key to web server's place -------	TAGS: [ssl_certificate, test2]
      SSLcrt : Download cert and key files if needed -------------	TAGS: [key_cert_copy_only, ssl_certificate, test2]
      DB_adm : Create DBs on respective hosts --------------------	TAGS: [create_databases, databases]
      DB_adm : Grant user privileges in DBs ----------------------	TAGS: [databases, grant_privileges]
      Drupal : Download Drupal using drush pm-download (dl) ------	TAGS: [drupal_site]
      Drupal : Download and extract civiCRM ----------------------	TAGS: [drupal_site]
      Drupal : Install Drupal site using drush site-install (si) -	TAGS: [drupal_site]
      Drupal : Install CiviCRM module with drush civicrm-install -	TAGS: [drupal_site]
      Drupal : Enable some modules with drush --------------------	TAGS: [drupal_site]
      Drupal : Run pm-update to update database if necessary -----	TAGS: [drupal_site]
      finals : Deploy later specific templates -------------------	TAGS: [config_files, deploy_templates]
      finals : Create later directories and set permissions ------	TAGS: [config_files]
      finals : Add or change line in config files ----------------	TAGS: [config_files]
      finals : Ensure services are started and enabled -----------	TAGS: [install_dep_pkg]
----

The hiphens o minus signs are used just to make the output easier to 
understand.

Everything is based in few distinct blocks as can be noted in 
roles/\*/tasks folders.

Special attention should be paid to AWS, base and SSLcrt tasks
in which case have some more included task files like this:

AWS:
	10-base.yml
	20-create.yml
	30-modify.yml
	40-delete.yml
	90-last.yml

base:
	10-base.yml
	20-specific.yml
	30-cron.yml
	90-last.yml

SSLcrt:
	10-first.yml
	20-challenge.yml
	30-save.yml

This is just to organize. In the future it may lead to separate
roles.

And now the AWS playbook:

----
playbook: AWS.yml

  play #1 (localhost): localhost	TAGS: []
    tasks:
      common : Install python if not installed -------------------	TAGS: [bootstrap_python]
      common : Update cache and upgrade (may take a time) --------	TAGS: [update_repository]
      common : Install vary basic packages to run ansible --------	TAGS: [install_dep_pkg]
      AWS : Ensure aws config dir -------------	TAGS: [base_config]
      AWS : Set AWS config ini style file -----	TAGS: [base_config]
      AWS : Gather default VPC facts ----------	TAGS: [create_aws_instances, create_ec2_instances, create_security_groups, gather_default_vpc]
      AWS : Ensure base output dir ------------	TAGS: [create_aws_instances, create_ec2_instances, create_security_groups, gather_default_vpc]
      AWS : Copy default VPC facts ------------	TAGS: [gather_default_vpc]
      AWS : Gather default subnets ------------	TAGS: [create_aws_instances, create_ec2_instances, create_security_groups, gather_default_vpc]
      AWS : Copy default subnets facts --------	TAGS: [gather_default_vpc]
      AWS : Create security groups ------------	TAGS: [change_state_all_ec2_instances, change_state_all_instances, create_aws_instances, create_ec2_instances, create_rds_instances, create_security_groups]
      AWS : Create EC2 key pairs --------------	TAGS: [create_aws_instances, create_ec2_instances, create_key_pairs, create_rds_instances]
      AWS : Create EC2 instances --------------	TAGS: [create_aws_instances, create_ec2_instances]
      AWS : Create RDS instances --------------	TAGS: [create_aws_instances, create_rds_instances]
      AWS : Create EFS file systems -----------	TAGS: [create_aws_instances, create_efs_instances]
      AWS : Reboot RDS instance by name -------	TAGS: [reboot_instance, reboot_rds_instance]
      AWS : Start/stop EC2 instances by tag ---	TAGS: [change_state_ec2_instance, change_state_instance]
      AWS : Start/stop all EC2 instances ------	TAGS: [change_state_all_ec2_instances, change_state_all_instances]
      AWS : Delete RDS instance by name -------	TAGS: [delete_aws_instances, delete_rds_instances]
      AWS : Delete EC2 instances --------------	TAGS: [delete_aws_instances, delete_ec2_instances]
      AWS : Remove key pair by its name -------	TAGS: [delete_keys]
      AWS : Copy security groups facts --------	TAGS: [change_state_all_ec2_instances, change_state_all_instances, create_aws_instances, create_ec2_instances, create_rds_instances, create_security_groups]
      AWS : Gather EC2 instances facts --------	TAGS: [change_state_all_ec2_instances, change_state_all_instances, create_aws_instances, create_ec2_instances, gather_ec2]
      AWS : Gather RDS instances facts --------	TAGS: [change_state_all_instances, create_aws_instances, create_rds_instances, gather_rds]
      AWS : Gather EFS filesystems facts ------	TAGS: [change_state_all_instances, create_aws_instances, create_efs_instances, gather_efs]
      AWS : Copy EC2 instances facts ----------	TAGS: [change_state_all_ec2_instances, change_state_all_instances, create_aws_instances, create_ec2_instances, gather_ec2]
      AWS : Copy RDS instances facts ----------	TAGS: [change_state_all_instances, create_aws_instances, create_rds_instances, gather_rds]
      AWS : Copy EFS filesystems facts --------	TAGS: [change_state_all_instances, create_aws_instances, create_efs_instances, gather_efs]
      AWS : Copy EC2 instances IP/DNS ---------	TAGS: [change_state_all_ec2_instances, change_state_all_instances, create_aws_instances, create_ec2_instances, gather_ec2]
      AWS : Copy RDS instances useful data ----	TAGS: [change_state_all_instances, create_aws_instances, create_rds_instances, gather_rds]
      AWS : Deploy templates for inventory ----	TAGS: [config_ansible_host_file, config_files]
----

In roles/AWS/vars/main.yml you may define a list of keys to be
created - they you be downloaded on creation. Also may specify 
a list of different security group to set.

May stop and start an instance, except for DB which is not 
implemented bu AWS services. In this case, the public IP
will change. Use with parsimony.

All instances facts will be copied to facts.d subdir - even
the IP address when changing.

The secret subdir contains the sensitive data to access AWS endpoints.

----------------------------------------------------------------------
PLAYING WITH THE BOOK
----------------------------------------------------------------------

To run each playbook some extra-vars are needed as summarized above. 
A shell script with some definitions must be settled:

This is the expected header in each shell script:

-----
#!/bin/sh

PLAYDIR="`dirname $0`"

cd "$PLAYDIR"

BASEDIR="`pwd`"
CONFDIR="${BASEDIR}/conf.d"
SSHCONF="${CONFDIR}/ssh_config"

export BASEDIR CONFDIR SSHCONF

export DISPLAY_SKIPPED_HOSTS="false"

export ANSIBLE_SSH_ARGS="-C -o ControlMaster=auto -o ControlPersist=60s -F ${SSHCONF}"
-----

And this is the playbook command itself:

	ansible-playbook --extra-vars "basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" _PLAYBOOK_.yml

As explained above, some other extra-vars may be used, but all have 
their own default values already defined in roles/\*/defaults/main.yml.

It is possible to run just the git parts:

(after the shell script header!!)
$ ansible-playbook \ 
    --extra-vars \
    "basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" \
    --tags "git_config" \
    Site.yml

----------------------------------------------------------------------
GIT 
----------------------------------------------------------------------
The simplest way to build a git server is with ssh and a pair of keys.

The playbook creates the git user, the repository outside git homedir 
and can create projects from the variable named project_list 
in group_vars/server2.yml file.

Find the private key to connect in 

	conf.d/git_priv_key 

and use it in you ~/.ssh/config. A simple example will look like:

----
Host mydomain.com
User git
ConnectTimeout 600
Compression yes
IdentityFile ~/.ssh/git_priv_key
----

Then move to a more clean directory and try:
	git clone ssh://git@mydomain.com/repos/test.git

It should retrieve the complete repository of this ansible job 
including this README file.
