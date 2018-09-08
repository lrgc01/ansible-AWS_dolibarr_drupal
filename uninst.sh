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

ansible-playbook -i hosts --extra-vars "gather_y_n=no update_cache_y_n=no purge_y_n=yes autoremove_y_n=yes basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" removeDrupal.yml
#ansible-playbook -i hosts --extra-vars "gather_y_n=no update_cache_y_n=no purge_y_n=yes autoremove_y_n=yes basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --skip-tags "uninstall_dep_pkg" removeDrupal.yml

rm -f *.retry
