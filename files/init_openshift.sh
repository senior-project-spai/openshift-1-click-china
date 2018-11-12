#!/bin/bash

# create project CI
oc get project cicd; if [ $? -gt 0 ]; then oc new-project cicd --display-name="CICD自动化"; fi

# 设置权限
oc adm policy add-scc-to-user anyuid -z gitlab-ce-user -n cicd
oc adm policy add-scc-to-user anyuid -z cicd -n cicd

# 添加GOGS模板
oc get template gogs -n cicd; if [ $? -gt 0 ]; then oc create -f ./files/gogs-template.yml -n cicd; fi
