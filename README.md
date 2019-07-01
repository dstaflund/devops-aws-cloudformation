## AWS CloudFormation Project    

### Requirements

This project contains the AWS CloudFormation templates needed to generate a networking environment
that satisfies the following requirements.

#### Server specs

- There are two private subnets each containing up to two servers
- Each server is to have two vCPUs and at least 4GB of RAM
- Each server is to use Ubuntu 18
- Each server is to have at least 10GB of disk space allocated


#### Security Groups and Roles

- The instances must use IAM Roles to use the S3 Service
- Inbound HTTP port 80 is open that that applications can communicate on it
- Servers must have unrestricted outbound internet access to download and update software


#### Load Balancing

- A load balancer must distribute calls to each of the servers
- The load balancer must perform health checks
- The load balancer health check must accommodate build and startup times
- The load balancer must allow all public traffic (0.0.0.0/0) on port 80 inbound
- The load balancer must only use port 80 to reach the internal servers
- The load balancer must be located in a public subnet


#### Launch Configuration

- There is to be a Launch Configuration that deploys an application to up to four servers
- The application to be deployed must be downloaded from an S3 bucket
- The provided UserData script must install all the required application dependencies


#### CloudFormation Scripts

- One of the output exports of the CloudFormation script should be the public URL of the load balancer
- The script must automate the creation and destruction of the entire infrastructure
- The script should make judicious use of parameters

#### Networking Diagram

A diagram of the network is as follows:

![Alt text](/doc/udagram-network.png?raw=true "Network Diagram")


### AWS CloudFormation Stack Structure

Five AWS CloudFormation templates (two of which are optional) are used to satisfy the above requirements.


#### Service Stack

This stack declares the S3 bucket that the EC2 instances download the application from.  It also declares
the IAMS role that the EC2 instances must use to get access to the S3 bucket.

This stack takes the following input parameters:

![Alt text](/doc/service_stack_input.jpg?raw=true "Service Stack Input Parameters")

This script outputs the following values:

![Alt text](/doc/service_stack_output.jpg?raw=true "Service Stack Output Values")


#### Macro Stack _(Optional)_

This stack declares some AWS Lambdas that the test stack uses to upload a test application into the S3 bucket.

This stack is optional and only needs to be used if you want the test stack to upload a test application for
you.  If you wish to upload an application yourself -- and forego creation of the Macro and Test stacks --
feel free to do so.

The strategy used to perform S3 file uploads is an adaptation of code found at
https://github.com/awslabs/aws-cloudformation-templates/tree/master/aws/services/CloudFormation/MacrosExamples/S3Objects

This stack does not consume input parameters or produce output values.


#### Test Stack _(Optional)_

This stack uses the AWS Lambdas declared in the Macro stack to upload a test application into the S3 bucket.

This stack is optional and only needs to be used if you want the test stack to upload a test application for
you.  If you wish to upload an application yourself -- and forego creation of the Macro and Test stacks --
feel free to do so.

The test application uploaded by this stack is a Base64 version of the application found in the _/test_ folder
of this project.  The website https://www.browserling.com/tools/file-to-base64 was used to to encode the zip file.

Note that the zip-file contains a single _index.html_ file that display the phrase _It works!  Udagram, Udacity._

This stack takes the following input parameters:

![Alt text](/doc/test_stack_input.jpg?raw=true "Test Stack Input Parameters")

This script does not produce output values.


#### Network Stack

The Network stack declares the following resources of this network:

* The AWS Virtual Private Cloud (VPC)
* The Internet Gateway
* The public and private subnets
* The NAT Gateways
* The routing tables

This stack takes the following input parameters:

![Alt text](/doc/network_stack_input.jpg?raw=true "Network Stack Input Parameters")

This script outputs the following values:

![Alt text](/doc/network_stack_output.jpg?raw=true "Network Stack Output Values")


#### Server Stack

The Server Stack declares the computing resources that make use of the network stack:

* The webapp and load balancer security groups
* The launch configuration
* The instance profile
* The target and autoscaling groups
* The load balancer as well as its listener and rules

The strategy used by this stack of having EC2 instances use instance profiles to access the S3 bucket is
an adaptation of code found https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html

This stack takes the following input parameters:

![Alt text](/doc/server_stack_input.jpg?raw=true "Server Stack Input Parameters")

This script outputs the following values:

![Alt text](/doc/server_stack_output.jpg?raw=true "Server Stack Output Values")

A live link to my load balancer can be found at http://udagr-webap-j0mxb3f2v4w1-2025708013.us-west-2.elb.amazonaws.com/

### Instructions

#### Creating the Stacks

To create the AWS CloudFormation stacks, do the following:

1.  Create an AWS account
1.  Download and install AWS Command Line Interface from https://aws.amazon.com/cli/
1.  Open a command prompt and go to the top-level directory of this repository
1.  Create the stacks by doing the following (NB:  Only Linux syntax is provided here -- modify for Windows):

```
    #
    # Note that you can use '-c' instead of '--create-stack' in the following
    #
    
    > cd stacks
    > cd ./1_service
    > ./build.sh --create-stack      # Create the S3 bucket and associated role
    > cd ../2_macro
    > ./build.sh --create-stack      # (Optional) Create a lambda that can be used to upload files to the S3 bucket
    > cd ../3_test
    > ./build.sh --create-stack      # (Optional) Use lambda to upload test app to the S3 bucket
    > cd ../4_network
    > ./build.sh --create-stack      # Create the network infrastructure
    > cd ../5_server
    > ./build.sh --create-stack      # Deploying the servers, etc. onto the network
```

After you run each step, log onto the AWS Console, go to the CloudFormation section, and wait until the
Stack has been created before moving onto the subsequent step.

#### Viewing the Web Application

Once the stacks have been deployed and the EC2 instances are running, find the public link associated
with your load balancer and click on it.  It should bring you to the test application page.


#### Deleting the Stacks

To delete the AWS CloudFormation stacks when you are finished, do the following:

1.  Open a command prompt and go to the top-level directory of this repository
1.  Run the following (NB:  Only Linux syntax is provided here -- modify for Windows):

```
    #
    # Note that you can use '-d' instead of '--delete-stack' in the following
    #
    
    > cd stacks
    > cd ./5_server
    > ./build.sh --delete-stack      # Delete the servers, etc. from the network
    > cd ../4_network
    > ./build.sh --delete-stack      # Delete the underlying network
    > cd ../3_test
    > ./build.sh --delete-stack      # (Optional) Delete code used to upload test app to the S3 bucket 
    > cd ../2_macro
    > ./build.sh --delete-stack      # (Optional) Delete lambda that can be used to upload files to the S3 bucket
    > cd ../1_service
    > ./build.sh --delete-stack      # Delete the S3 bucket
```

After you run each step, log onto the AWS Console, go to the CloudFormation section, and wait until the
Stack has been created before moving onto the subsequent step.


### Acknowledgments

- Strategy used to perform S3 file uploads is an adaptation of code found at https://github.com/awslabs/aws-cloudformation-templates/tree/master/aws/services/CloudFormation/MacrosExamples/S3Objects
- Used https://www.browserling.com/tools/file-to-base64 to encode the zipfile
- Strategy used to give EC2 instances access to the S3 bucket is taken from https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html

