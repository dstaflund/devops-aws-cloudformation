## AWS CloudFormation Project    

### Requirements

This project contains the AWS CloudFormation templates needed to generate a networking environment
that meets the following requirements.

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

Three AWS CloudFormation stacks are used to meet the above requirements.


#### Service Stack

This stack declares the S3 bucket that the EC2 instances download the application from.  It also declares
the IAMS role that the EC2 instances must use to get access to the S3 bucket, and uploads the test application.

This stack takes the following input parameters:

![Alt text](/doc/service_stack_input.jpg?raw=true "Service Stack Input Parameters")

This script outputs the following values:

![Alt text](/doc/service_stack_output.jpg?raw=true "Service Stack Output Values")


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

Note that entries in the _Values_ column will differ for each stack installation.

#### Server Stack

The Server Stack declares the computing resources that make use of the network stack:

* The webapp and load balancer security groups
* The launch configuration
* The instance profile
* The target and autoscaling groups
* The load balancer as well as its listener and rules

Note that although the launch configuration can spin up to 4 servers at one time, it only spins up 2
at the start to save on costs and resources.  More servers will be added if the load demands are there.

The strategy used by this stack of having EC2 instances use instance profiles to access the S3 bucket is
an adaptation of code found https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html

This stack takes the following input parameters:

![Alt text](/doc/server_stack_input.jpg?raw=true "Server Stack Input Parameters")

This script outputs the following values:

![Alt text](/doc/server_stack_output.jpg?raw=true "Server Stack Output Values")

Note that entries in the _Values_ column will differ for each stack installation.

A live link to my load balancer can be found at http://udagr-WebAp-1CIRFFVXGZSQ6-889163088.us-west-2.elb.amazonaws.com/


### Instructions

#### Creating the Stacks

To create the AWS CloudFormation stacks, do the following _(NB:  These instructions assume you are running Linux
with bash installed)_:

1.  Create an AWS account
1.  Download and install AWS Command Line Interface from https://aws.amazon.com/cli/
1.  Open a command prompt and go to the top-level directory of this repository
1.  Create the stacks by doing the following:

```
    > cd stacks
    > ./setup.sh
```

The script will take a while to complete.  Once it's finished, log onto the AWS Console, go to the EC2 instances
section and wait until both of the instances are up and running before trying to view the application.


#### Viewing the Web Application

Once the stacks have been deployed and the EC2 instances are running, find the public link associated
with your load balancer and click on it.  It should bring you to the test application page.


#### Deleting the Stacks

To delete the AWS CloudFormation stacks when you are finished, do the following:

1.  Open a command prompt and go to the top-level directory of this repository
1.  Run the following:

```
    > cd stacks
    > ./teardown.sh
```

The stacks may take a while to be deleted, but once the script ends, you should find no reference to the
stacks in the AWS CloudFormation console.


### Acknowledgments

- Strategy used to give EC2 instances access to the S3 bucket is taken from https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html

