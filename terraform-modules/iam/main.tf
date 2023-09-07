resource "aws_iam_role" "iam_role" {
  name                  = var.role_name
  force_detach_policies = var.force_detach_policies
  description           = var.description == "" ? var.role_name : var.description
  max_session_duration  = var.max_session_duration
  assume_role_policy    = var.assume_role_policy
  tags                  = merge(var.tags, { Name = var.role_name })
  path                  = var.path
}


resource "aws_iam_policy" "iam_policy" {
  count       = length(var.custom_iam_policies)
  name        = lookup(var.custom_iam_policies[count.index], "name", null)
  description = lookup(var.custom_iam_policies[count.index], "description", format("Policy for %s", var.role_name))
  policy      = lookup(var.custom_iam_policies[count.index], "policy_document", null)
  path        = lookup(var.custom_iam_policies[count.index], "path", var.path)
}


resource "aws_iam_role_policy_attachment" "custom_policy_attachment" {
  count      = length(var.custom_iam_policies)
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.*.arn[count.index]

  depends_on = [aws_iam_policy.iam_policy]
}


resource "aws_iam_role_policy_attachment" "managed_policy_attachment" {
  count      = length(var.managed_iam_policies)
  role       = aws_iam_role.iam_role.name
  policy_arn = var.managed_iam_policies[count.index]

  depends_on = [aws_iam_policy.iam_policy]
}
