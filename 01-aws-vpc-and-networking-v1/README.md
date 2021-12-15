# Terraform Lab-01, AWS VPC and Networking Example

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Lab-Version](https://img.shields.io/badge/Lab%20version-1.0.0-0098B7.svg)](#)
[![Terraform/Core Version](https://img.shields.io/badge/TF%20version-1.0.11-844fba.svg)](#)
[![AWS CLI/SDK Version](https://img.shields.io/badge/awscli%20version-2.0.27-ff9900.svg)](#)


## Introduction

In this lab, we build a simple 3-by-3 (_full-region_) VPC in AWS consisting of 3 private and 3 public subnets in the respective available AZs. In addition, two security groups are created and some parameters are stored in the AWS SSM-K/V store. Three workspaces can be used for this lab; the listing of the respective workspaces can be found in the respective section in this documentation. For this lab, we will only store a local state of the infrastructure - this is not recommended for production use! We will go into more detail about the possibilities of remote state handling in the following examples.

## Terraform Module-/Repository Structure

``` 
[aws]
  |
  └ modules                 | primary module definitons
  |   └ global              | [global/] modules (could also be handled as GIT-SubModules)
  |   |   └ core            | - [global/core] modules (helper modules) 
  |   |   |   └ label       | - [global/core/label] primary label module logic 
  |   |   └ network         | [global/network] modules
  |   |   |   └ vpc         | [global/network/vpc] helper module
  |   |   └ services        | [global/service] modules (sg, iam, ssm etc) - currently not used
  |   |                     |
  |   └ project             | [project/] modules
  |   |   └ network         | [project/network] project related network modules
  |   |   |   └ sg          | - [project/network/security-groups] example definition
  |   |   └ services        | - [project/network/service] related service modules
  |   |   |   └ ssm         | - [project/network/service/ssm] project example module
  |   |   |                 |
  |---+---+-----------------|-----------------------------------------------------------------------------------
  └ payload                 | possible payload data for upcoming application stacks (e.g. user-data scripts etc) 
  |-------------------------|-----------------------------------------------------------------------------------
  |                         |
[meta]                      | meta directory (used for docs, media files and local helper scripta)
  |                         |
  └ doc                     | [meta/doc] documentation sub-directory
  |   └ pdf                 | - [meta/doc/pdf] directory
  |   └ scm                 | - [meta/doc/scm] directory
  |       └ media           | - [meta/doc/scm/media] markdown screenshots directory
  |                         |
  └ script                  | - [meta/script] local script-/tool-directory
  |                         |
  |-------------------------|-----------------------------------------------------------------------------------
```


## Terraform Workspaces Used

| Workspace | Description       | CIDR            | CIDR-priv-subnets   | CIDR-public-subnets | region       |
| --------- | ----------------- | --------------- | ------------------- | ------------------- | ------------ |
| `prod`    | primary workspace | `10.96.0.0/20`  | `10.96.3-5.0/24`    | `10.96.0-2.0/24`    | eu-central-1 |
| `stage`   | staging workspace | `10.96.16.0/20` | `10.96.19-21.0/24`  | `10.96.16-17.0/24`  | eu-central-1 |
| `test`    | testing workspace | `10.96.32.0/20` | `10.96.35-37.0/24`  | `10.96.32-34.0/24`  | us-east-1    |


## AWS Resources Used

| AWS Resource   | Terraform Definition                                                                     | Module Path                                |
| -------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------ |
| Labels         | [terraform-null-label](https://github.com/cloudposse/terraform-null-label) | [link](./aws/modules/global/core/label) |
| VPC            | [terraform-aws-vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc) | [link](./aws/modules/global/network/vpc) |
| SecurityGroup  | [terraform-aws-security-group](https://www.terraform.io/docs/providers/aws/r/security_group.html) | [link](./aws/modules/project/network/sg) |
| SSM-Parameter  | [terraform-aws-ssm-parameter](https://www.terraform.io/docs/providers/aws/r/ssm_parameter.html) | [link](./aws/modules/project/services/ssm) |


## Core Requirements

For the use of the local terminal environment for all terraform relevant CLI/API calls a certain tool set is required and Linux or macOS as operating system is recommended. If it is not possible to install our stack due to limitations in terms of feasibility/availability in the preparation, you can alternatively use the browser-internal [cloud shell](https://aws.amazon.com/cloudshell/) of your aws management console. You can find a good (free) cloud-guru web-tutorial using cloud-shell [here](https://acloudguru.com/videos/acg-fundamentals/how-to-use-aws-cloudshell?utm_campaign=11244863417&utm_source=google&utm_medium=cpc&utm_content=469352928666&utm_term=_&adgroupid=115625160932&gclid=Cj0KCQiAnuGNBhCPARIsACbnLzpVzQFqkkt2qx9rggGk0YW6VSZL0v56J6JYIyKcLoNONCM_1WPF5DQaAhBiEALw_wcB).

- `aws sdk` [installation](https://aws.amazon.com/cli/) tutorial
- `terraform` [installation](https://www.terraform.io/downloads.html) tutorial
- `tfswitch` [installation](https://tfswitch.warrensbox.com/Install/) tutorial


## Terraform Lab Terminal Preparation

The preparation of your local shell/terminal environment is one of the first steps to handle all of our labs and is the basis for all our further activity using the local development environment of all participants. We will pave the way to our first terraform aws resource deployment step by step in the following section and learning some basics of using terraform providers, configs, outputs and state.

1. **AWS Credential Configuration**

   _Please make sure that there is an appropriate aws profile in your aws-cli/sdk configuration, which must be stored in the respective `./env/<workspace>.tfvars.json`. Below you can find an example for the user `1001` with the profile `tf-ws-user-1001`._

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

2. **Terraform Workspace Preparation**

   _The Terraform-initialization phase is the first step towards the actual provisioning of the planned infrastructure. Here, all necessary providers and plugins are loaded and a basic structure for the further use of terraform is created. For example, the important state file is created, which will serve as a link between the desired and current state of the infrastructure. Furthermore, we will create a corresponding workspace here, which will encapsulate the environmental state of the infrastructure (prod, stage and test). Although we will only use `prod` in this lab, the other workspaces are quite important for understanding different configuration levels._

   ```bash
   # jump into this lab directory
   $ echo 'cd <root-repo-path>/01-aws-vpc-and-networking-v1' ;
   # prepare terraform (e.g. all required plugins will downloaded, state will be prepared)
   $ echo 'terraform init' ;
   # init our production workspace now (this will also activate the workspace immediately)
   $ echo 'terraform terraform workspace new prod' ;
   # check your current workspace (you will see a small star in front of the prod workspace marking it as active)
   $ echo 'terraform terraform workspace list' ;
   ```

## Terraform Lab Provisioning Process

The life cycle of our infrastructure will essentially depend on three important terraform commands (`plan`, `apply` and `destroy`). In the course of an automated approach, e.g. via well-known build tools such as Gitlab or Jenkins, these commands can also be used. In this case, the output of the `terraform plan` command is usually used as input for the actual provisioning call `apply`. The advantage here is that the plan is available as a physical file and is not subject to any runtime restrictions with regard to any timeouts in the user request.

1. **PLAN**

   _Now that all terraform plugins required for the provisioning process have been loaded and the workspace has been initialized, we can begin our initial infrastructure planning._

   ```bash
   # make sure that you are in the right lab directory
   $ echo 'cd <root-repo-path>/01-aws-vpc-and-networking-v1' ;
   # execute the following command to "plan" your infrastructure (nothing will be provisioned right now)
   $ echo 'terraform plan' ;
   ```

2. **APPLY**

   _The next step will be the actual execution of provisioning. for this we could also use the output of the provisioning plan from step 1, but for simplicity we will go directly into the apply process based on our infrastructure definition._

   ```bash
   # make sure that you are in the right lab directory
   $ echo 'cd <root-repo-path>/01-aws-vpc-and-networking-v1' ;
   # execute the following command to "apply" your infrastructure (you have to approve the step afterwards)
   $ echo 'terraform apply' ;
   ```

3. **DESTROY**

   _The last step will be the removal of the created resources. All resources defined via the infrastructure definition will be removed completely and without residue from your aws account._

   ```bash
   # make sure that you are in the right lab directory
   $ echo 'cd <root-repo-path>/01-aws-vpc-and-networking-v1' ;
   # execute the following command to "destroy" your infrastructure (you have to approve the step afterwards)
   $ echo 'terraform destroy' ;
   ```
   
## Conclusion

With this lab we learned the basics of setting up, planning and provisioning simple aws resources using the example of a VPC with 6 subnets and 2 security groups. We will build up the other labs based on this lab and use parts of the approaches and resources explained here in them as well.


## Links

- https://github.com/cloudposse/terraform-null-label/blob/master/README.md
- https://github.com/terraform-aws-modules/terraform-aws-vpc
- https://www.terraform.io/docs/providers/aws/r/security_group.html
- https://www.terraform.io/docs/providers/aws/r/ssm_parameter.html
- https://www.terraform.io/docs/language/state/index.html


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