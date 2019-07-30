set -x

ansible-playbook -i /root/git/kubespray/inventory/mckube/hosts.yaml /root/git/openshift-auto/playbooks/kubespray-node-prep/config.yml -e IMAGE_VERSION="kubespray"

. /root/env/env.sh

ansible-playbook -i /root/git/kubespray/inventory/mckube/hosts.yaml /root/git/kubespray/cluster.yml -v

