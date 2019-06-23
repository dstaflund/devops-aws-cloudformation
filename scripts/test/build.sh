#!/usr/bin/env bash


###############################################
#
# Declare constants
#
###############################################
macroStackName=udagram-macro-stack
testStackName=udagram-test-stack
macroTemplate=macro.template
packagedTemplate=s3objects.template
s3Bucket=com-github-dstaflund-udagram-s3-bucket
testTemplate=test.template


###############################################
#
# Delete stack
#
###############################################
delete_stack()
{
    aws cloudformation delete-stack \
        --stack-name ${macroStackName}
}


###############################################
#
# Package S3Objects template
#
# See https://github.com/awslabs/aws-cloudformation-templates/tree/master/aws/services/CloudFormation/MacrosExamples/S3Objects
#
###############################################
package_template()
{
    rm -f ${packagedTemplate}
    aws cloudformation package \
        --template ${macroTemplate} \
        --s3-bucket ${s3Bucket} \
        --output-template-file ${packagedTemplate}
}


##############################################
#
# Deploy S3Objects template
#
# See https://github.com/awslabs/aws-cloudformation-templates/tree/master/aws/services/CloudFormation/MacrosExamples/S3Objects
#
##############################################
deploy_template()
{
    aws cloudformation deploy \
        --capabilities CAPABILITY_IAM \
        --stack-name ${macroStackName} \
        --template-file ${packagedTemplate}
}


##############################################
#
# Deploy test application
#
# See https://github.com/awslabs/aws-cloudformation-templates/tree/master/aws/services/CloudFormation/MacrosExamples/S3Objects
#
##############################################
deploy_test()
{
    aws cloudformation deploy \
        --capabilities CAPABILITY_IAM \
        --stack-name ${testStackName} \
        --template-file ${testTemplate}
}


###############################################
#
# Display script usage
#
###############################################
usage()
{
    echo "usage: build.sh [[-d | --delete-stack] | [-p | --package-template] | [-s | --deploy-s3-template] | [-t | --deploy-test-template] | [-h | --help]]"
}


###############################################
#
# Parse and handle the input parameters
#
###############################################
while [[ "$1" != "" ]]; do
    case $1 in
        -d | --delete-stack )         echo "deleting stack..."
                                      delete_stack
                                      echo "done"
                                      exit
                                      ;;
        -p | --package-template )     echo "packaging macro template..."
                                      package_template
                                      echo "done"
                                      exit
                                      ;;
        -s | --deploy-s3-template)    echo "deploying S3Objects template..."
                                      deploy_template
                                      echo "done"
                                      ;;
        -t | --deploy-test-template ) echo "deploying test template..."
                                      deploy_test
                                      echo "done"
                                      ;;
        -h | --help )                 usage
                                      exit 1
    esac
    shift
done
