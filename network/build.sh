#!/usr/bin/env bash


###############################################
#
# Declare constants
#
###############################################
stackName=udagram-network-stack
networkTemplateFile=file://network.yaml
networkParameterFile=file://network.json


###############################################
#
# Create stack
#
###############################################
create_stack()
{
    aws cloudformation create-stack \
        --stack-name ${stackName} \
        --template-body ${networkTemplateFile} \
        --parameters ${networkParameterFile}
}


###############################################
#
# Update stack
#
###############################################
update_stack()
{
    aws cloudformation update-stack \
        --stack-name ${stackName} \
        --template-body ${networkTemplateFile} \
        --parameters ${networkParameterFile}
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
    echo "usage: build.sh [[-c | --create-stack] | [-u | -- update-stack] | [-d | --delete-stack] | [-h | --help]]"
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
        -u | --update-stack )    echo "updating stack..."
                                 update_stack
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
