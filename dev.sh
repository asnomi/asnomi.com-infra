#!/bin/bash

# include paramater
PARAMETER="parameters/dev.yml"
TemplateName=$(yq ".templatename.website" ${PARAMETER} -r)
StackName=$(yq ".stackname.website" ${PARAMETER} -r)
ENVTAG=$(yq ".common.EnvTag" ${PARAMETER} -r)
PROJECT=$(yq ".common.Project" ${PARAMETER} -r)
WORKBUCKET=$(yq ".common.WorkBucket" ${PARAMETER} -r)
DOMAINNAME=$(yq ".common.DomainName" ${PARAMETER} -r)

# debug
ls -alh

# cd
cd template/

# S3 upload
aws s3 cp ${TemplateName} s3://${WORKBUCKET}/${TemplateName}

# Instance Template
aws cloudformation deploy --stack-name ${StackName} \
  --template-file ${TemplateName} \
  --s3-bucket ${WORKBUCKET} \
  --capabilities CAPABILITY_NAMED_IAM \
  --no-execute-changeset \
  --parameter-overrides \
  EnvTag=${ENVTAG} Project=${PROJECT} \
  DomainName=${DOMAINNAME}

# S3 Remove
aws s3 rm s3://${WORKBUCKET}/${TemplateName}