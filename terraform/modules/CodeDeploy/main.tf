resource "aws_codedeploy_app" "url_shortener" {
  compute_platform = "ECS"
  name             = "url-shortener"
}

resource "aws_codedeploy_deployment_config" "canary" {
  deployment_config_name = "ECSCanary20Percent3Minutes"
  compute_platform       = "ECS"

  traffic_routing_config {
    type = "TimeBasedCanary"
    time_based_canary {
      interval   = 3
      percentage = 20
    }
  }
}

resource "aws_codedeploy_deployment_group" "url_shortener" {
  app_name               = aws_codedeploy_app.url_shortener.name
  deployment_config_name = aws_codedeploy_deployment_config.canary.deployment_config_name
  deployment_group_name  = "BlueGreen"
  service_role_arn       = aws_iam_role.codedeploy.arn

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_https_arn]
      }

      target_group {
        name = var.target_group_blue_name
      }

      target_group {
        name = var.target_group_green_name
      }
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM", "DEPLOYMENT_STOP_ON_REQUEST"]
  }
}

resource "aws_iam_role" "codedeploy" {
  name = "AWSCodeDeployRoleForECS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.codedeploy.id
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
