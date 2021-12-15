# Terraform Fundamentals 101

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Terraform/Core Version](https://img.shields.io/badge/TF%20version-1.0.11-844fba.svg)](#)
[![AWS CLI/SDK Version](https://img.shields.io/badge/awscli%20version-2.0.27-ff9900.svg)](#)


## Introduction

In this full-day workshop we will look at some core mechanisms of Terraform. This beginner course will mainly deal with AWS resources in the context of VPC/Networking, Scalable EC2 Instances and relational databases. The present topics are not yet fully formulated - therefore, changes within the respective labs may occur or new labs may be added in the future. The labs assume functional access to an AWS account and a consistent toolset in the local development environment). The introduction to each topic will take about 5-10 minutes, the exercises about 30-45 minutes each.

## Repository Structure

``` 
[root]
  |
  └ 01-aws-vpc-and-networking-v1   | 1st terraform lab, handling vpc/sn/sg resources with local state
  └ 02-aws-compute-bastion-host-v1 | 2nd terraform lab, handling ec2 compute resources with local state
  └ 03-aws-compute-backend-host-v1 | 3rd terraform lab, handling scalable ec2 compute resources with local state
  └ 04-aws-rds-pgsql-single-zone   | 4th terraform lab, handling rds/pgsql resources with local state (single-zone)
  └ 05-aws-rds-pgsql-multi-zone-ha | 5th terraform lab, handling rds/pgsql resources with local state (multi-zone)
  |--------------------------------|-----------------------------------------------------------------------------------
  └ logs                           | target for upcoming logs (mostly terratest/api-call result related) 
  |--------------------------------|-----------------------------------------------------------------------------------
  └ scripts                        | target for upcoming helper scripts for all of our labs + tf init 
  |--------------------------------|-----------------------------------------------------------------------------------
```

## Available Labs

| Lab/Folder                                        | Description                                                                         |
| ------------------------------------------------- | ----------------------------------------------------------------------------------- |
| [tf-aws-lab-01](./01-aws-vpc-and-networking-v1)   | simple aws vpc/networking example using native terraform hcl                        |
| [tf-aws-lab-02](./02-aws-compute-bastion-host-v1) | advanced ec2 compute bastion-host example using ubuntu ec2 with user data           |
| [tf-aws-lab-03](./03-aws-compute-backend-host-v1) | auto scaling group example for centos ec2 backend host(s) with additional user data |
| [tf-aws-lab-04](./04-aws-rds-pgsql-single-zone)   | single zone aws rds example using postgresql                                        |
| [tf-aws-lab-05](./05-aws-rds-pgsql-multi-zone-ha) | multi-zone aws rds example using postgresql                                         |


## Available Terraform Workspaces

| Workspace | Description       | CIDR            | region       |
| --------- | ----------------- | --------------- | ------------ |
| `prod`    | primary workspace | `10.96.0.0/20`  | eu-central-1 |
| `stage`   | staging workspace | `10.96.16.0/20` | eu-central-1 |
| `test`    | testing workspace | `10.96.32.0/20` | us-east-1    |


## Core Requirements

For the use of the local terminal environment for all terraform relevant CLI/API calls a certain tool set is required and Linux or macOS as operating system is recommended. If it is not possible to install our stack due to limitations in terms of feasibility/availability in the preparation, you can alternatively use the browser-internal [cloud shell](https://aws.amazon.com/cloudshell/) of your aws management console. You can find a good (free) cloud-guru web-tutorial using cloud-shell [here](https://acloudguru.com/videos/acg-fundamentals/how-to-use-aws-cloudshell?utm_campaign=11244863417&utm_source=google&utm_medium=cpc&utm_content=469352928666&utm_term=_&adgroupid=115625160932&gclid=Cj0KCQiAnuGNBhCPARIsACbnLzpVzQFqkkt2qx9rggGk0YW6VSZL0v56J6JYIyKcLoNONCM_1WPF5DQaAhBiEALw_wcB).

### Required Tools/Packages

- `aws sdk` [installation](https://aws.amazon.com/cli/) tutorial
- `terraform` [installation](https://www.terraform.io/downloads.html) tutorial

### Optional Tools/Packages

- `vscode` [installation](https://code.visualstudio.com/download) tutorial
- `tfswitch` [installation](https://tfswitch.warrensbox.com/Install/) tutorial
- `curl` [installation](https://curl.se/download.html) tutorial


## Terraform Terminal Preparation

The preparation of your local shell/terminal environment is one of the first steps to handle all of our labs and is the basis for all our further activity using the local development environment of all participants. We will pave the way to our first terraform aws resource deployment step by step in the following section and learning some basics of using terraform providers, configs, outputs and state.

1. **Clone Repository**

   _Please make sure that work with the latest main-branch version of our labs-repository._

   ```bash
   $ # $HOME/
   $ git clone git@github.com:doitintl/tf-fundamentals-workshop-101.git
   ```

2. **AWS Credential Configuration**

   _Please make sure that there is an appropriate aws profile in your aws-cli/sdk configuration, which must be stored in the respective `<lab-path>/env/<workspace>.tfvars.json`. Below you can find an example for the user `1001` with the profile `tf-ws-user-1001`._

   ```ini
   $ # $HOME/.aws/config
   [tf-ws-user-1001]
   region = eu-central-1
   output = json
   ```

   ```ini
   $ # $HOME/.aws/credentials
   [tf-ws-user-1001]
   aws_access_key_id = AKIA0000000000000000
   aws_secret_access_key = abababababababababababababababababababa0
   ```

3. **INIT/RUN** Lab
   _go to the corresponding labs subdirectory and follow the corresponding instructions in the documentation stored there_ 


## Terraform Debugging

Terraform has detailed logs which can be enabled by setting the `TF_LOG` environment variable to any value. This will cause detailed logs to appear on stderr. You can set `TF_LOG` to one of the log levels `TRACE`, `DEBUG`, `INFO`, `WARN` or `ERROR` to change the verbosity of terraform logs.


## Links

- https://www.terraform.io/docs/language/functions/index.html
- https://www.terraform.io/docs/language/expressions/index.html
- https://www.terraform.io/docs/language/settings/backends/index.html
- https://gruntwork.io/infrastructure-as-code-library/
- https://github.com/gruntwork-io/cloud-nuke
- https://github.com/cloudposse

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

## Copyright

Copyright © 2021 DoiT International