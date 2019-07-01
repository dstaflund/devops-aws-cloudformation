#!/usr/bin/env bash


###############################################
#
# Declare constants
#
###############################################
stackName=udagram-service-stack
templateFile=file://service.yaml
parameterFile=file://service.json


###############################################
#
# Create stack
#
###############################################
create_stack()
{
    aws cloudformation create-stack \
        --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
        --stack-name ${stackName} \
        --template-body ${templateFile} \
        --parameters ${parameterFile}
    aws s3api wait bucket-exists --bucket com-github-dstaflund-udagram-s3-bucket
    aws s3 cp ../../test/working-test.zip s3://com-github-dstaflund-udagram-s3-bucket/working-test.zip
    aws cloudformation wait stack-create-complete --stack-name udagram-service-stack
}


###############################################
#
# Delete stack
#
###############################################
delete_stack()
{
    aws s3 rm s3://com-github-dstaflund-udagram-s3-bucket/working-test.zip
    aws s3api wait bucket-not-exists --bucket com-github-dstaflund-udagram-s3-bucket
    aws cloudformation delete-stack \
        --stack-name ${stackName}
    aws cloudformation wait stack-delete-complete --stack-name udagram-service-stack
}


###############################################
#
# Display script usage
#
###############################################
usage()
{
    echo "usage: build.sh [[-c | --create-stack] | [-d | --delete-stack] | [-h | --help]]"
}


###############################################
#
# Parse and handle the input parameters
#
###############################################
while [[ "$1" != "" ]]; do
    case $1 in
        -c | --create-stack )      echo "creating stack..."
                                   create_stack
                                   echo "done"
                                   exit
                                   ;;
        -d | --delete-stack )      echo "deleting stack..."
                                   delete_stack
                                   echo "done"
                                   exit
                                   ;;
        -h | --help )              usage
                                   exit 1
    esac
    shift
done
