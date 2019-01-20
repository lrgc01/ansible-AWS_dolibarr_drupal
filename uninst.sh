#!/bin/sh

PLAYDIR="`dirname $0`"

cd "$PLAYDIR"

BASEDIR="`pwd`"
CONFDIR="${BASEDIR}/conf.d"
SSHCONF="${CONFDIR}/ssh_config"

# Ensure priv keys in conf.d dir are protected
chmod go-w,o-rwx ${CONFDIR}/*

export BASEDIR CONFDIR SSHCONF

export DISPLAY_SKIPPED_HOSTS="false"

export ANSIBLE_SSH_ARGS="-C -o ControlMaster=auto -o ControlPersist=60s -F ${SSHCONF}"

# Some tags to use or skip:
#  - drop_databases
#  - uninstall_dep_pkg
#  - remove_files_n_dirs
# From common: (these first two must be called when python is missing)
#  - install_dep_pkg
#  - bootstrap_python
#  - update_repository

#ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=false purge_y_n=false autoremove_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "bootstrap_python,drop_databases" Uninstall.yml
ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=false purge_y_n=false autoremove_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "bootstrap_python,uninstall_dep_pkg,install_dep_pkg" Uninstall.yml
#ansible-playbook -i hosts --extra-vars "gather_y_n=false update_cache_y_n=false purge_y_n=true autoremove_y_n=true basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "bootstrap_python,install_dep_pkg" Uninstall.yml

rm -f *.retry
