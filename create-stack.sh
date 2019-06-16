#!/usr/bin/env bash
aws cloudformation create-stack \
    --stack-name udagram-stack \
    --template-body file://yaml/network.yaml \
    --parameters file://yaml/network-params.json
