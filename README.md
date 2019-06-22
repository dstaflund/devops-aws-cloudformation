## AWS CloudFormation Project    


**Server specs**

- There are to be two private subnets each containing two of the above servers
- Each server is to have two vCPUs and at least 4GB of RAM
- Each server is to use Ubuntu 18
- Each server is to have at least 10GB of disk space allocated
- _(Optional)_ There should be a bastion host to allow you to SSH into your private subnet servers.


**Security Groups and Roles**

- The instances must use IAM Roles to use the S3 Service
- The application must communicate on HTTP port 80 so servers will need this inbound port open
- Servers must have unrestricted outbound internet access to download and update software
- _(Optional)_ The bastion host should be on a public subnet with port 22 open only to your home IP address
- _(Optional)_ The bastion host should have a private key to access the other servers.


**Load Balancing**

- A load balancer must distribute calls to each of the servers
- The load balancer must also perform health checks
- The load balancer health check must accommodate build and startup times
- The load balancer must allow all public traffic (0.0.0.0/0) on port 80 inbound
- The load balancer must only use port 80 to reach the internal servers
- The load balancer must be located in a public subnet


**Launch Configuration**

- There is to be a Launch Configuration that deploys an application to four servers
- The application to be deployed must be downloaded from an S3 bucket
- Log information for UserData scripts must be located in _cloud-init-output.log_ under the folder _/var/log_
- The provided UserData script must install all the required application dependencies


**CloudFormation Scripts**

- One of the output exports of the CloudFormation script should be the public URL of the load balancer
- The script must automate the creation and destruction of the entire infrastructure
- The script should make judicious use of parameters


