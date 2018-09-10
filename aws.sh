#!/bin/sh

PLAYDIR="`dirname $0`"

cd "$PLAYDIR"

BASEDIR="`pwd`"
CONFDIR="${BASEDIR}/conf.d"
SSHCONF="${CONFDIR}/ssh_config"

export BASEDIR CONFDIR SSHCONF

export DISPLAY_SKIPPED_HOSTS="false"

# First check base local pre-requisites, but becoming root with password:
echo "Local sudo to install local base requirements (may comment line after first run)"
ansible-playbook --ask-become-pass base_AWS.yml
# can comment the line after first successfull run

# The rest of AWS stuff may be as local non-root user
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "base_config" AWS.yml
ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" AWS.yml

rm -f *.retry
