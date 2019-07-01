#!/usr/bin/env bash

cd ./1_service
./build.sh -c
cd ../2_network
./build.sh -c
cd ../3_server
./build.sh -c
cd ..
