#!/usr/bin/env bash


###############################################
#
# Declare constants
#
###############################################
stackName=udagram-network-stack
templateFile=file://network.yaml
parameterFile=file://network.json


###############################################
#
# Create stack
#
###############################################
create_stack()
{
    aws cloudformation create-stack \
        --stack-name ${stackName} \
        --template-body ${templateFile} \
        --parameters ${parameterFile}
    aws cloudformation wait stack-create-complete --stack-name udagram-network-stack
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
    aws cloudformation wait stack-delete-complete --stack-name udagram-network-stack
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
        -c | --create-stack )    echo "creating stack..."
                                 create_stack
                                 echo "done"
                                 exit
                                 ;;
        -d | --delete-stack )    echo "deleting stack..."
                                 delete_stack
                                 echo "done"
                                 exit
                                 ;;
        -h | --help )            usage
                                 exit 1
    esac
    shift
done
