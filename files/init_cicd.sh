#!/bin/bash
function deploy_app_cicd(){
	t_name=$1
	oc get dc $t_name > /dev/null 2>&1 || oc new-app --template=$t_name -n cicd

}

deploy_app_cicd gogs
deploy_app_cicd nexus3
deploy_app_cicd sonarqube

