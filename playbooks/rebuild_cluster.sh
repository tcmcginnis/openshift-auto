#/bin/sh
#
# T.McGinnis 10/2018
#

FIRSTMASTER=master1

cd `dirname $0`

date
set -x
ssh $FIRSTMASTER ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml

date
ansible-playbook uninstall/uninstall_devices.yml

date
ansible nodes -m shell -a 'shutdown -r 0'

# Wait for all nodes to become available
# set +x
date
sleep 15
while true
do
   ping -c 1 $FIRSTMASTER
   if [ $? -eq 0 ]; then
      break
   fi
   sleep 5
done
sleep 5
while true
do
   ansible nodes -m ping
   if [ $? -eq 0 ]; then
      break
   fi
   sleep 5
done

date
set -x
ansible-playbook uninstall/uninstall_artifacts.yml

date
ansible-playbook openshift-node-prep/config.yml

date
ssh $FIRSTMASTER ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
 
date
ssh $FIRSTMASTER ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml

date
