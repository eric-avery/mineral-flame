data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "mineral_flame_server_role" {
  name                = "${var.name}-instance-role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

data "aws_iam_policy_document" "mineral_flame_cw_permissions" {

  statement {
    effect = "Allow"
    actions = [
      "autoscaling:*",
      "cloudwatch:*",
      "ec2:*",
      "iam:*",
      "logs:*",
      "s3:*"
    ]
    resources = ["*"]
  }

}

resource "aws_iam_role_policy" "mineral_flame_server_policy" {
  name   = "${var.name}-instance-policy"
  policy = data.aws_iam_policy_document.mineral_flame_cw_permissions.json
  role   = aws_iam_role.mineral_flame_server_role.id
}

resource "aws_iam_instance_profile" "mineral_flame_instance_profile" {
  name = aws_iam_role.mineral_flame_server_role.name
  path = "/"
  role = aws_iam_role.mineral_flame_server_role.name
}