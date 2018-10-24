#!/bin/bash
export CHANGEREPO=true
if [ $CHANGEREPO == true -a ! -d /etc/yum.repos.d/back ]
then
    cd /etc/yum.repos.d/; mkdir -p back; mv -f *.repo back/; cd -
    cp files/all.repo /etc/yum.repos.d/
    yum clean all
fi
current_path=`pwd`
yum localinstall tools/ansible-2.4.6.0-1.el7.ans.noarch.rpm
ansible-playbook playbook.yml
cd $current_path/openshift-ansible-playbook
ansible-playbook playbooks/prerequisites.yml
ansible-playbook playbooks/deploy_cluster.yml
htpasswd -b /etc/origin/master/htpasswd admin admin
oc adm policy add-cluster-role-to-user cluster-admin admin
