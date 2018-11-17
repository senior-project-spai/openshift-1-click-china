#!/bin/bash
OPENSHIFT_TEMPLATE_DIR='./openshift-templates'
CICD_TEMPLATES=(gogs jenkins gitlab nexus3 sonarqube)
OPENSHIFT_TEMPLATES=(redis postgresql mysql)

# create project CI
oc get project cicd; if [ $? -gt 0 ]; then oc new-project cicd --display-name="CICD持续集成"; fi

# 设置权限
oc create serviceaccount cicd -n cicd
oc adm policy add-scc-to-user anyuid -z cicd -n cicd

for temp_name in "${CICD_TEMPLATES[@]}"
do 
	oc get template $temp_name -n cicd
	if [ $? -gt 0 ]
	then
		oc create -f ${OPENSHIFT_TEMPLATE_DIR}/${temp_name}-template.yaml -n cicd
	fi
done


for temp_name in "${OPENSHIFT_TEMPLATES[@]}"
do 
	oc get template $temp_name -n openshift
	if [ $? -gt 0 ]
	then
		oc create -f ${OPENSHIFT_TEMPLATE_DIR}/${temp_name}-template.yaml -n openshift
	fi
done

#删除registry-console模板
oc get template registry-console -n openshift
if [ $? -eq 0 ]
then
	oc delete template registry-console -n openshift
fi