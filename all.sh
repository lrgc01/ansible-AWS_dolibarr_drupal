#!/bin/sh

PLAYDIR="`dirname $0`"

cd "$PLAYDIR"

BASEDIR="`pwd`"
CONFDIR="${BASEDIR}/conf.d"
SSHCONF="${CONFDIR}/ssh_config"

# Ensure priv keys in conf.d dir are protected
chmod 600 ${CONFDIR}/*

export BASEDIR CONFDIR SSHCONF

export DISPLAY_SKIPPED_HOSTS="false"

# First check base local pre-requisites, but becoming root with password:
echo "Local sudo to install local base requirements (may comment line after first run)"
ansible-playbook --ask-become-pass base_AWS.yml
# can comment the line after first successfull run

# The rest of AWS stuff may be as local non-root user
ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" AWS.yml

export ANSIBLE_SSH_ARGS="-C -o ControlMaster=auto -o ControlPersist=60s -F ${SSHCONF}"

# Use --tags "__TAG_NAME__" to restrict ansible-playbook in the following useful tags:
#  - base_users
#  - auth_keys
#  - deploy_templates
#  - install_dep_pkg
#  - cron_config
#  - config_files
#  - databases
#  - php_config,drupal_site

#ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "ssl_certificate" Drupal.yml
#ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "install_dep_pkg" Drupal.yml 
ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=no basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" Site.yml 

rm -f *.retry
