#!/bin/bash

#
# install additional packages
# --
sudo yum -y install mc && sudo yum clean all
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | sudo bash

#
# prepare workshop path && clone workshop files
# --
sudo mkdir -p /opt/workshop && sudo chown cloudshell-user: /opt/workshop && \
git clone https://github.com/doitintl/tf-fundamentals-workshop-101.git /opt/workshop/tf-fundamentals-workshop-101
cd /opt/workshop/tf-fundamentals-workshop-101

#
# cleanup aws credentials file
# --
# mkdir -p "$HOME"/.aws
# echo "" > "$HOME"/.aws/credentials
#
# citywire workshop attendees override
# --
# [terraform]
# aws_access_key_id = AKIA
# aws_secret_access_key = ccc
