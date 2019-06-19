#!/usr/bin/env bash


###############################################
#
# Declare constants
#
###############################################

#
# Name of the CloudFormation stack we want to create
stackName=udagram-stack

#
# YAML script we'll use to declare the networking resources of our stack
templateFile=file://templates/network.yaml

#
# JSON script we'll use to pass parameters to our networking script
parameterFile=file://templates/network-params.json


###############################################
#
# Create the cloud formation
#
###############################################
create_formation()
{
    aws cloudformation create-stack \
        --stack-name udagram-stack \
        --template-body ${templateFile} \
        --parameters ${parameterFile}
}


###############################################
#
# Update the cloud formation
#
###############################################
update_formation()
{
    aws cloudformation update-stack \
        --stack-name ${stackName} \
        --template-body ${templateFile} \
        --parameters ${parameterFile}
}


###############################################
#
# Delete the cloud formation
#
###############################################
delete_formation()
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
    echo "usage: build.sh [[-c | --create] | [-u | --update] | [-d | --delete] | [-h | --help]]"
}


###############################################
#
# Parse and handle the input parameters
#
###############################################
while [[ "$1" != "" ]]; do
    case $1 in
        -c | --create )         create_formation
                                exit
                                ;;
        -u | --update )         update_formation
                                exit
                                ;;
        -d | --delete )         delete_formation
                                exit
                                ;;
        -h | --help )           usage
                                exit 1
    esac
    shift
done
