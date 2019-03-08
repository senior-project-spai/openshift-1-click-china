#!/bin/bash
CICD_IMAGES=(gitlab/gitlab-ce:11.4.0-ce.0 \
	redis:3.2.3-alpine \
	centos/postgresql-95-centos7:latest \
	openshiftdemos/gogs:0.11.34 \
	openshift/jenkins-2-centos7:latest \
	sonatype/nexus3:3.14.0 \
	openshift/jenkins-agent-maven-35-centos7:v4.0 \
	openshiftdemos/sonarqube:6.7 \
	centos/mysql-57-centos7:latest \
	xhuaustc/openshift-kafka:latest \
	xhuaustc/openshift-kafka:latest \
	xhuaustc/logstash:6.6.1 \
	xhuaustc/elasticsearch:6.6.1 \
	xhuaustc/kibana:6.6.1)

for image in "${CICD_IMAGES[@]}"
do
	docker pull $image
done