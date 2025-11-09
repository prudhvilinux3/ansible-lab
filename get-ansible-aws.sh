#!/bin/bash
#########################################################################################################
#Author: Prudhvi B											#
#Date: 9th Nov 2025											#
#Purpose: To get the Ansible managed hosts tagged in aws account 					#
#pre-requsites: the shell or current console should have aws configured outside the script 		#
# The script gets only the running instances with tages where Key is Manager and Value is Ansible 	#
#########################################################################################################



cd inventory/
echo "[aws]" > inventory
aws ec2 describe-instances   --filters "Name=tag:Manager,Values=Ansible" "Name=instance-state-name,Values=running"   --query "Reservations[].Instances[].{ID:InstanceId,IP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value}"   --output json   | jq -r '.[] | select(.IP != null) | "\(.Name //  "ec2")_\(.ID) ansible_host=\(.IP)"'   >> /tmp/inven 
running_instances=`wc -l </tmp/inven`

if [ "$running_instances" -lt 1 ] ; then
	echo -e "No Instances found running that has tags as Manager = Ansible \n Please check your aws console and scale up the instances as required" 
else 
	cat /tmp/inven >> inventory
fi


