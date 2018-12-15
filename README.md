# Decision Maker - Infrastructure

[![Build Status](https://travis-ci.com/DylanSp/decision-maker-infra.svg?branch=master)](https://travis-ci.com/DylanSp/decision-maker-infra)

The infrastructure for Decision Maker is configured as an AWS CloudFormation template. The major components are:
  - An EC2 Ubuntu instance with Docker installed, to host the containers for the site.
  - An RDS MySQL instance, to act as the site's database.
  - An Application Load Balancer for TLS termination (using an AWS-provided cert) and routing requests to the appropriate container.

The rest of the CloudFormation template sets up a publicly-accessible VPC with two subnets, in two different availability zones, to host this infrastructure. It also contains the necessary resources for a Lambda-backed custom resource to allow setting up ALB redirect rules in a CloudFormation template, which isn't currently possible in vanilla CloudFormation. (Credit to [jheller](https://github.com/jheller/alb-rule) for this code)

## CI Process

All changes to this project should go through pull requests. Creating a pull request causes Travis CI to create a [CloudFormation changeset](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets.html), which should be manually examined in the AWS console to verify that the changes are correct. Merging the PR to `master` will execute the change set.

# License

MIT