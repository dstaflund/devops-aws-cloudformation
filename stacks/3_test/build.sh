#!/usr/bin/env bash


###############################################
#
# Declare constants
#
###############################################
stackName=udagram-test-stack
s3Bucket=com-github-dstaflund-udagram-s3-bucket
templateFile=test.yaml


###############################################
#
# Create stack
#
###############################################
create_stack()
{
    aws cloudformation deploy \
        --capabilities CAPABILITY_IAM \
        --stack-name ${stackName} \
        --template-file ${templateFile}
}


###############################################
#
# Delete stack
#
###############################################
delete_stack()
{
    aws cloudformation delete-stack \
        --stack-name ${stackName}
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
