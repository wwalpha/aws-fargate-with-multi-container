locals {
  account_id = data.aws_caller_identity.this.account_id
  region     = data.aws_region.this.name

  # task_definition_revision = max(aws_ecs_task_definition.multi_container.revision, data.aws_ecs_task_definition.multi_container.revision)
}

# ----------------------------------------------------------------------------------------------
# AWS Region
# ----------------------------------------------------------------------------------------------
data "aws_region" "this" {}

# ----------------------------------------------------------------------------------------------
# AWS Account
# ----------------------------------------------------------------------------------------------
data "aws_caller_identity" "this" {}

# ----------------------------------------------------------------------------------------------
# Task Definition
# ----------------------------------------------------------------------------------------------
# data "aws_ecs_task_definition" "multi_container" {
#   task_definition = "${aws_ecs_task_definition.multi_container.family}"
# }
