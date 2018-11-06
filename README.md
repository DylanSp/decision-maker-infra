# Decision Maker - Infrastructure

The infrastructure for Decision Maker is configured as an AWS CloudFormation template. The major components are:
  - An EC2 Ubuntu instance with Docker installed, to host the containers for the site.
  - An RDS MySQL instance, to act as the site's database.
  - An Application Load Balancer for TLS termination (using an AWS-provided cert) and routing requests to the appropriate container.

The rest of the CloudFormation template sets up a publicly-accessible VPC with two subnets, in two different availability zones, to host this infrastructure. It also contains the necessary resources for a Lambda-backed custom resource to allow setting up ALB redirect rules in a CloudFormation template, which isn't currently possible in vanilla CloudFormation. (Credit to [jheller](https://github.com/jheller/alb-rule) for this code)