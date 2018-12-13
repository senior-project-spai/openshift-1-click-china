#!/bin/bash
systemctl restart nfs
function deploy_app_cicd(){
	t_name=$1
	project_name=$2
	oc get dc $t_name -n $project_name > /dev/null 2>&1 || oc new-app --template=$t_name -n $project_name 
	sleep 180
}

deploy_app_cicd gogs  cicd
deploy_app_cicd nexus3 cicd
deploy_app_cicd sonarqube cicd

oc get project jeesite  > /dev/null 2>&1 ||  oc new-project jeesite --display-name=JeeSite
oc get dc mysql -n jeesite > /dev/null 2>&1 || oc new-app --template=openshift/mysql-persistent --name=mysql --param=MYSQL_USER=jeesite --param=MYSQL_PASSWORD=jeesite --param=MYSQL_ROOT_PASSWORD=jeesite --param=MYSQL_DATABASE=jeesite -n jeesite
if [ -d jeesite ]
then
	cd jeesite
	git pull
else
	git clone https://gitee.com/openshiftx/jeesite.git
	cd jeesite
fi
oc get bc jeesite  -n jeesite > /dev/null 2>&1 || cat Dockerfile | oc new-build -D - --name jeesite -n jeesite && oc adm policy add-scc-to-user anyuid -z jeesite -n jeesite
oc get bc jeesite-pipeline  -n jeesite > /dev/null 2>&1 || oc create -f openshift-pipeline.yml -n jeesite

oc get serviceaccount jeesite -n jeesite 2>&1 || oc create serviceaccount jeesite -n jeesite
oc get dc jeesite > /dev/null 2>&1 || oc create -f ../openshift-templates/jeesite-deployment.yaml -n jeesite
oc get svc jeesite > /dev/null 2>&1 || oc expose dc jeesite --port=8080
oc get route jeesite > /dev/null 2>&1 || oc expose svc jeesite

echo "success"