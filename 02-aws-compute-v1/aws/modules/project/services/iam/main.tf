# ---------------------------------------------------------------------------------------------------------------------
# MODULES
# some modules used in this infrastructure approach
# ---------------------------------------------------------------------------------------------------------------------

# --
# @entity/id:    core_label (label, global/core/label)
# @source/doc:   https://github.com/cloudposse/terraform-null-label/blob/master/README.md
# @source/local: aws/modules/global/network/vpc/main.tf
# @info:         this is an adaption of core-label open source repository used for tag/lbl ident of resources
# --
module "label" {

  source = "../../../global/core/label"

  stage     = var.stage
  namespace = var.namespace
  name      = var.name

  attributes = var.attributes
  tags       = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# DATA
# some data used for our iam policy management
# ---------------------------------------------------------------------------------------------------------------------

#
# codepipeline core policy statement for all of our pipelines
#
# - allow assume role for instance (codepipeline_assume_policy)
#
data "aws_iam_policy_document" "codepipeline_policy_doc_primary" {

  statement {
    sid     = "AllowCPAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

#
# primary policy statement for all of our EC2 instance(s)
#
# - allow assume role for instance
# - allow for SSM access to instance
#
data "aws_iam_policy_document" "ec2_policy_doc_primary" {

  statement {
    sid     = "AllowEC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid     = "AllowEC2SSMOperations"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
  }
}

#
# secondary policy statement for apps in our EC2 instance(s)
# @info: use this data block for all of your manual statement set(s)
#
# - allow s3 read-only access
# - allow cloudwatch log (group) access
# - allow pass/list role (for role assume process)
#
data "aws_iam_policy_document" "ec2_policy_doc_secondary" {

  statement {
    sid       = "AllowEC2AdditionalOperations"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "cloudwatch:PutMetricAlarm",
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:PutRetentionPolicy",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "sts:AssumeRole",
      "iam:PassRole",
      "iam:ListRoles"
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# RESOURCES
# some native resources used in this infrastructure approach
# ---------------------------------------------------------------------------------------------------------------------

# --
# @entity/id:    aws_iam_role (ec2, codebuild, code-deploy)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/iam_role.html
# --
resource "aws_iam_role" "ec2_primary_role" {

  name               = "${module.label.stage}-${module.label.name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_policy_doc_primary.json
}

# --
# @entity/id:    aws_iam_role_policy (ec2, codebuild, code-deploy)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
# --
resource "aws_iam_role_policy" "ec2_primary_role_policy" {

  name   = "${module.label.stage}-${module.label.name}-ec2-role-policy"
  role   = aws_iam_role.ec2_primary_role.id
  policy = data.aws_iam_policy_document.ec2_policy_doc_secondary.json
}

# --
# @entity/id:    aws_iam_role_policy_attachment (aws_iam_role_policy_attachment, EC2 Application related IAM Role Attachments)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
# @info:         use this approach for all append-existing-role (aws roles) to our ec2 role set
# --

# @info: add "AmazonEC2RoleForSSM" to primary instance role
resource "aws_iam_role_policy_attachment" "ec2_primary_role_policy_ext_ssm" {

  role       = aws_iam_role.ec2_primary_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  lifecycle {
    create_before_destroy = true
  }
}

# @info: add "AmazonSSMAutomationRole" to primary instance role
resource "aws_iam_role_policy_attachment" "ec2_primary_role_policy_ext_ssm_auto" {

  role       = aws_iam_role.ec2_primary_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
  lifecycle {
    create_before_destroy = true
  }
}

# @info: add "AmazonEC2ContainerRegistryReadOnly" to primary instance role
resource "aws_iam_role_policy_attachment" "ec2_primary_role_policy_ext_ecr_ro" {

  role       = aws_iam_role.ec2_primary_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# --
# @entity/id:    aws_ssm_activation (aws_ssm_activation)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/ssm_activation.html
# --
resource "aws_ssm_activation" "ec2_primary_ssm_activation" {

  name               = "${module.label.stage}-${module.label.name}-ssm-activation"
  iam_role           = aws_iam_role.ec2_primary_role.id
  description        = "SSM activation for our instance audit access"
  registration_limit = 5
}

resource "random_id" "ec2_default_linked_role" {

  byte_length = 4
}

# --
# @entity/id:    iam_instance_profile (elastic_beanstalk_app)
# @source/doc:   https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
# --
resource "aws_iam_instance_profile" "ec2_default_profile" {

  name = "${module.label.stage}-${module.label.name}-ec2-app-profile-${random_id.ec2_default_linked_role.hex}"
  role = aws_iam_role.ec2_primary_role.name
}
