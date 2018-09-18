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

export ANSIBLE_SSH_ARGS="-C -o ControlMaster=auto -o ControlPersist=60s -F ${SSHCONF}"

# Use --tags "__TAG_NAME__" to restrict ansible-playbook in the following useful tags:
#  - base_users
#  - auth_keys
#  - deploy_templates
#  - install_dep_pkg
#  - acme_account
#  - ssl_certificate

#ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "acme_account" SSLcrt.yml
#ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "install_dep_pkg" SSLcrt.yml 
ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}"  SSLcrt.yml 

rm -f *.retry
