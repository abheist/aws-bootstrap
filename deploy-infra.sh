#!/bin/bash

STACK_NAME=awsbootstrap 
REGION=us-east-1 
CLI_PROFILE=awsbootstrap

EC2_INSTANCE_TYPE=t2.micro 

AWS_AACOUNT_ID=`aws sts get-caller-identity --profile awsbootstrap \
  --query "Account" --output text`
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_AACOUNT_ID"

echo -e "=============== Deploying setup.yml ============"
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME-setup \
  --template-file setup.yml \
  --no-file-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides CodePipelineBucket=$CODEPIPELINE_BUCKET

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file main.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides EC2InstanceType=$EC2_INSTANCE_TYPE
