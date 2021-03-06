#!/bin/sh

PLAYDIR="`dirname $0`"

cd "$PLAYDIR"

BASEDIR="`pwd`"
CONFDIR="${BASEDIR}/conf.d"
SSHCONF="${CONFDIR}/ssh_config"

# Warning: There are particular/private local passwords or keys
# that should be copied (or linked) in $CONFDIR

# Ensure priv keys in conf.d dir are protected
chmod go-w,o-rwx ${CONFDIR}/*

export BASEDIR CONFDIR SSHCONF

export DISPLAY_SKIPPED_HOSTS="false"

#export ANSIBLE_SSH_ARGS="-C -o ControlMaster=auto -o ControlPersist=60s -F ${SSHCONF}"

# Use --tags "__TAG_NAME__" to restrict ansible-playbook in the following useful tags:
#  - install_dep_pkg
#  - base_users
#  - auth_keys
#  - deploy_templates
#  - cron_config
#  - config_files
#  - ssl_certificate
#  - databases
#  - php_config,drupal_site
# From common: (these first two must be called when python is missing)
#  - install_base_pkg
#  - bootstrap_python
#  - update_repository
# To run or not apt update AND apt upgrade
# update_cache_y_n=yes or no

# This is equivalent to apt update && apt upgrade -y
#ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=yes basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "update_repository" Site.yml

#ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "deploy_templates" Site.yml
#ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "php_config" Site.yml
#ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "php_config,drupal_site,deploy_templates,config_files" Site.yml
#ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "python_bootstrap,install_dep_pkg,deploy_templates,cron_config,git_config,base_users,auth_keys,ssl_certificate" Site.yml 
#ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "python_bootstrap,install_dep_pkg,base_users,drupal_site,php_config,ssl_certificate" Site.yml 
# Only update certs
#ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "python_bootstrap,update_repository,install_dep_pkg,base_users,drupal_site,php_config,databases,cron_config" Site.yml 
#ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "python_bootstrap" Site.yml 
ansible-playbook -i servers --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "update_repository,install_base_pkg,install_dep_pkg" Site.yml 

rm -f *.retry
