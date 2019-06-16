#!/usr/bin/env bash
aws cloudformation update-stack \
    --stack-name udagram-stack \
    --template-body file://yaml/network.yaml \
    --parameters file://yaml/network-params.json
