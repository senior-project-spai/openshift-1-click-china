#!/bin/bash
function deploy_app_cicd(){
	t_name=$1
	project_name=$2
	oc get dc $t_name -n $project_name > /dev/null 2>&1 || oc new-app --template=$t_name -n $project_name 

}

deploy_app_cicd gogs cicd
deploy_app_cicd nexus3 cicd
deploy_app_cicd sonarqube cicd

