#!/bin/bash

if [ "$*" = "" ]; then
   echo "Must provide a node name:"
   echo ""
   oc get nodes
   exit 1
fi
h="$1"

ssh $h df /var/lib/docker | grep "^/dev/mapper/docker--vg-lvcontainer"
if [ $? -eq 0 ]; then
   echo "This node has already been converted."
   exit 1
fi


# Gluster ###########################################
oc label node $h --list=true | grep "^glusterfs="
if [ $? -eq 0 ]; then
   GLUSTERFS="Y"
   oc label node $h glusterfs-
   while true
   do
      oc get pods -n glusterfs -o wide | awk '{print $7}' | grep -x "$h"
      if [ $? -ne 0 ]; then
         break
      fi
      oc get pods -n glusterfs -o wide | grep "$h"
      sleep 5
   done
      
fi


# Docker images ####################################
# Save docker images to a temporary place (tbd)
# /images/imagesave.sh


set -x
# Note: may need the "--delete-local-data" option on the drain command
oc adm cordon $h
oc adm drain $h --ignore-daemonsets --delete-local-data

# Docker space disk conversion #############################
cat docker-storage-reconfig.script | ssh $h /bin/bash


oc adm uncordon $h
set +x


# Gluster Restart ###########################################
if [ "$GLUSTERFS" = "Y" ]; then
   echo "Restarting Gluster..."
   oc label node $h glusterfs=storage-host
   oc get pods -n glusterfs -o wide
fi
