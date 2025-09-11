resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["2b18947a6a9fc7764fd8b5fb18a863b0c6dac24f"]
}

resource "aws_iam_role" "GitHubActions" {
  name = "GitHubActions"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:madil002/ecs-url-shortener:ref:refs/heads/main" # Hardcoded repo
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "GitHubActions_ECS" {
  name = "GitHubActions-ECS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          var.ecs_task_role_arn,
          var.ecs_execution_role_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.GitHubActions.id
  policy_arn = aws_iam_policy.GitHubActions_ECS.arn
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.GitHubActions.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role" "GitHubActions-Terraform" {
  name = "GitHubActions-Terraform"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:madil002/ecs-url-shortener:ref:refs/heads/main"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "terraform" {
  name = "GithubActions-Terraform"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "acm:*",
          "route53:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "ecs:*",
          "codedeploy:*",
          "dynamodb:*",
          "wafv2:*",
          "logs:*",
          "cloudwatch:*",
          "iam:*",
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tf" {
  role       = aws_iam_role.GitHubActions-Terraform.id
  policy_arn = aws_iam_policy.terraform.arn
}
