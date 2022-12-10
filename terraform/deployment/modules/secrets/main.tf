################################################################################
# Databases Secrets
# https://www.sufle.io/blog/keeping-secrets-as-secret-on-amazon-ecs-using-terraform
data "aws_secretsmanager_secret" "database_password_secret" {
  name = var.database_password_key
}

data "aws_secretsmanager_secret" "database_username_secret" {
  name = var.database_username_key
}

data "aws_secretsmanager_secret_version" "database_password_secret" {
  secret_id = data.aws_secretsmanager_secret.database_password_secret.id
}

data "aws_secretsmanager_secret_version" "database_username_secret" {
  secret_id = data.aws_secretsmanager_secret.database_username_secret.id
}

resource "aws_iam_role_policy" "password_policy_secretsmanager" {
  name = "password-policy-secretsmanager"
  role = var.role_id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect": "Allow",
        "Resource": [
          "${data.aws_secretsmanager_secret.database_username_secret.arn}",
          "${data.aws_secretsmanager_secret.database_password_secret.arn}"
        ]
      }
    ]
  }
  EOF
}