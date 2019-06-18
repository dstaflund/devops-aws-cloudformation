#!/usr/bin/env bash

#
# Name of the CloudFormation stack we want to create
stackName=udagram-stack

#
# YAML script we'll use to declare the networking resources of our stack
templateFile=file://yaml/network.yaml

#
# JSON script we'll use to pass parameters to our networking script
parameterFile=file://yaml/network-params.json

create_formation()
{
    aws cloudformation create-stack \
        --stack-name udagram-stack \
        --template-body ${templateFile} \
        --parameters ${parameterFile}
}

update_formation()
{
    aws cloudformation update-stack \
        --stack-name ${stackName} \
        --template-body ${templateFile} \
        --parameters ${parameterFile}
}

delete_formation()
{
    aws cloudformation delete-stack \
        --stack-name ${stackName}
}

usage()
{
    echo "usage: build.sh [[-c | --create] | [-u | --update] | [-d | --delete] | [-h | --help]]"
}

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
