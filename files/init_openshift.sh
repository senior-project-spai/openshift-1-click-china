#!/bin/bash
OPENSHIFT_TEMPLATE_DIR='./openshift-templates'
CICD_TEMPLATES=(gogs jenkins gitlab nexus3 sonarqube)

# create project CI
oc get project cicd; if [ $? -gt 0 ]; then oc new-project cicd --display-name="CICD自动化"; fi

# 设置权限
oc adm policy add-scc-to-user anyuid -z gitlab-ce-user -n cicd
oc adm policy add-scc-to-user anyuid -z cicd -n cicd

for temp_name in "${CICD_TEMPLATES[@]}"
do 
	oc get template $temp_name -n cicd
	if [ $? -gt 0 ]
	then
		oc create -f ${OPENSHIFT_TEMPLATE_DIR}/${temp_name}-template.yaml -n cicd
	fi
done

