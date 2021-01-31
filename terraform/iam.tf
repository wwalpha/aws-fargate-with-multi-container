# ----------------------------------------------------------------------------------------------
# AWS ECS Task Execution Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_exec" {
  name               = "OneCloud_MultiContainer_ECSTaskExecutionRole"
  assume_role_policy = file("iam/ecs_task_principals.json")
  lifecycle {
    create_before_destroy = false
  }
}

# ----------------------------------------------------------------------------------------------
# AWS ECS Task Execution Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ecs_task_exec" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Policy - Inline
# ----------------------------------------------------------------------------------------------
resource "aws_iam_policy" "inline" {
  name        = "inline-policy"
  description = "inline-policy"

  policy = file("iam/inline-policy.json")
}

# ----------------------------------------------------------------------------------------------
# AWS ECS Task Execution Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "inline" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = aws_iam_policy.inline.arn
}
