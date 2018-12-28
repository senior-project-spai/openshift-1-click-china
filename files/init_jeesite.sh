#!/bin/bash
gogs_username=$1
gogs_password=$2

## create token
token=$(curl -s -u root:123456 http://gogs.cicd.svc:3000/api/v1/users/root/tokens | grep sha2 | awk -F\" '{print $8}')
if [ "$token" == "" ]
then
	token=$(curl -s -X POST -u $gogs_username:$gogs_password http://gogs.cicd.svc:3000/api/v1/users/root/tokens -d name=default | awk -F\" '{print $8}')
fi


## create repo
curl -s -H "Authorization: token $token" http://gogs.cicd.svc:3000/api/v1/user/repos | egrep -q '"name":"jeesite"[^{]*"empty":false'
if [ $? -eq 0 ]
then
 	if [ -d jeesite ]
 	then
 		cd jeesite
 		git pull
  	else
		git clone http://gogs.cicd.svc:3000/root/jeesite.git
		cd jeesite
	fi
else
	curl -s -H "Authorization: token 6200198c6fcb7dc28e5330be0ca5fdc31c0b2a2e"  -X POST http://gogs.cicd.svc:3000/api/v1/user/repos -d 'name=jeesite&private=false'
	if [ ! -d jeesite ]
	then
		git clone https://gitee.com/openshiftx/jeesite.git
	fi
	cd jeesite
	git init
	git add .
	git commit -m "first commit"
	git remote add origin http://$gogs_username:$gogs_password@gogs.cicd.svc:3000/root/jeesite.git
	git push -u origin master

fi

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