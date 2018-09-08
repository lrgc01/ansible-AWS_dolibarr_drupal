#!/bin/sh

PLAYDIR="`dirname $0`"

cd "$PLAYDIR"

BASEDIR="`pwd`"
CONFDIR="${BASEDIR}/conf.d"
SSHCONF="${CONFDIR}/ssh_config"

export BASEDIR CONFDIR SSHCONF

export DISPLAY_SKIPPED_HOSTS="false"

#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "create_rds_instances" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "create_security_groups" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "gather_ec2" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "create_security_groups, show_debug" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "create_security_groups, create_key_pairs" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "gather_default_vpc, gather_ec2" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "change_state_all_ec2_instances, change_state_ec2_instances" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "change_state_ec2_instances" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "delete_ec2_instances" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "create_ec2_instances,change_state_all_ec2_instances,change_state_ec2_instances" AWS.yml
#ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" --tags "config_ansible_host_file, gather_ec2" AWS.yml
ansible-playbook --extra-vars "gather_y_n=false basedir=${BASEDIR} confdir=${CONFDIR} sshconf=${SSHCONF}" AWS.yml

rm -f *.retry
