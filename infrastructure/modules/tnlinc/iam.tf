# data "aws_iam_policy_document" "controller_task_policy" {
#   statement {
#     actions = [
#       "ssmmessages:CreateControlChannel",
#       "ssmmessages:CreateDataChannel",
#       "ssmmessages:OpenControlChannel",
#       "ssmmessages:OpenDataChannel"
#     ]
#     effect    = "Allow"
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "controller_task_policy" {
#   name   = "${var.app_name}-controller-task-policy"
#   policy = data.aws_iam_policy_document.controller_task_policy.json
# }

# resource "aws_iam_role" "controller_task_role" {
#   name               = "${var.app_name}-controller-task-role"
#   assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
#   tags               = var.tags
# }

# resource "aws_iam_role_policy_attachment" "controller_task" {
#   role       = aws_iam_role.controller_task_role.name
#   policy_arn = aws_iam_policy.controller_task_policy.arn
# }
