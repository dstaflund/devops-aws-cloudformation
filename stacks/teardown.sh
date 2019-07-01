#!/usr/bin/env bash

cd ./3_server
./build.sh -d
cd ../2_network
./build.sh -d
cd ../1_service
./build.sh -d
cd ..
