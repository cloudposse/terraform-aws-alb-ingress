locals {
  target_group_arn = var.default_target_group_enabled ? join("", aws_lb_target_group.default[*].arn) : var.target_group_arn
}

data "aws_lb_target_group" "default" {
  count = module.this.enabled ? 1 : 0

  arn = local.target_group_arn
}

module "target_group" {
  source          = "cloudposse/label/null"
  version         = "0.25.0"
  id_length_limit = 32
  context         = module.this.context
}

resource "aws_lb_target_group" "default" {
  count = module.this.enabled && var.default_target_group_enabled ? 1 : 0

  name             = coalesce(var.target_group_name, module.target_group.id)
  port             = var.port
  protocol         = var.protocol
  protocol_version = var.protocol_version
  slow_start       = var.slow_start
  target_type      = var.target_type
  vpc_id           = var.vpc_id

  deregistration_delay = var.deregistration_delay

  load_balancing_algorithm_type     = var.load_balancing_algorithm_type
  load_balancing_anomaly_mitigation = var.load_balancing_anomaly_mitigation

  stickiness {
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
    cookie_name     = var.stickiness_cookie_name
    enabled         = var.stickiness_enabled
  }

  health_check {
    enabled             = var.health_check_enabled
    path                = var.health_check_path
    port                = coalesce(var.health_check_port, var.port)
    protocol            = coalesce(var.health_check_protocol, var.protocol)
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }

  tags = module.this.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "unauthenticated_paths" {
  count = module.this.enabled && length(var.unauthenticated_paths) > 0 && length(var.unauthenticated_hosts) == 0 ? length(var.unauthenticated_listener_arns) : 0

  listener_arn = var.unauthenticated_listener_arns[count.index]
  priority     = var.unauthenticated_priority > 0 ? var.unauthenticated_priority + count.index : null

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    path_pattern {
      values = var.unauthenticated_paths
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "authenticated_paths_oidc" {
  count = module.this.enabled && var.authentication_type == "OIDC" && length(var.authenticated_paths) > 0 && length(var.authenticated_hosts) == 0 ? length(var.authenticated_listener_arns) : 0

  listener_arn = var.authenticated_listener_arns[count.index]
  priority     = var.authenticated_priority > 0 ? var.authenticated_priority + count.index : null

  action {
    type = "authenticate-oidc"

    authenticate_oidc {
      client_id              = var.authentication_oidc_client_id
      client_secret          = var.authentication_oidc_client_secret
      issuer                 = var.authentication_oidc_issuer
      authorization_endpoint = var.authentication_oidc_authorization_endpoint
      token_endpoint         = var.authentication_oidc_token_endpoint
      user_info_endpoint     = var.authentication_oidc_user_info_endpoint
      scope                  = var.authentication_oidc_scope

      on_unauthenticated_request          = var.authentication_oidc_on_unauthenticated_request
      authentication_request_extra_params = var.authentication_oidc_request_extra_params
    }
  }

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    path_pattern {
      values = var.authenticated_paths
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "authenticated_paths_cognito" {
  count = module.this.enabled && var.authentication_type == "COGNITO" && length(var.authenticated_paths) > 0 && length(var.authenticated_hosts) == 0 ? length(var.authenticated_listener_arns) : 0

  listener_arn = var.authenticated_listener_arns[count.index]
  priority     = var.authenticated_priority > 0 ? var.authenticated_priority + count.index : null

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = var.authentication_cognito_user_pool_arn
      user_pool_client_id = var.authentication_cognito_user_pool_client_id
      user_pool_domain    = var.authentication_cognito_user_pool_domain
      scope               = var.authentication_cognito_scope

      on_unauthenticated_request          = var.authentication_cognito_on_unauthenticated_request
      authentication_request_extra_params = var.authentication_cognito_request_extra_params
    }
  }

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    path_pattern {
      values = var.authenticated_paths
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "unauthenticated_hosts" {
  count = module.this.enabled && length(var.unauthenticated_hosts) > 0 && length(var.unauthenticated_paths) == 0 ? length(var.unauthenticated_listener_arns) : 0

  listener_arn = var.unauthenticated_listener_arns[count.index]
  priority     = var.unauthenticated_priority > 0 ? var.unauthenticated_priority + count.index : null

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    host_header {
      values = var.unauthenticated_hosts
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_oidc" {
  count = module.this.enabled && var.authentication_type == "OIDC" && length(var.authenticated_hosts) > 0 && length(var.authenticated_paths) == 0 ? length(var.authenticated_listener_arns) : 0

  listener_arn = var.authenticated_listener_arns[count.index]
  priority     = var.authenticated_priority > 0 ? var.authenticated_priority + count.index : null

  action {
    type = "authenticate-oidc"

    authenticate_oidc {
      client_id              = var.authentication_oidc_client_id
      client_secret          = var.authentication_oidc_client_secret
      issuer                 = var.authentication_oidc_issuer
      authorization_endpoint = var.authentication_oidc_authorization_endpoint
      token_endpoint         = var.authentication_oidc_token_endpoint
      user_info_endpoint     = var.authentication_oidc_user_info_endpoint
      scope                  = var.authentication_oidc_scope

      on_unauthenticated_request          = var.authentication_oidc_on_unauthenticated_request
      authentication_request_extra_params = var.authentication_oidc_request_extra_params
    }
  }

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    host_header {
      values = var.authenticated_hosts
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_cognito" {
  count = module.this.enabled && var.authentication_type == "COGNITO" && length(var.authenticated_hosts) > 0 && length(var.authenticated_paths) == 0 ? length(var.authenticated_listener_arns) : 0

  listener_arn = var.authenticated_listener_arns[count.index]
  priority     = var.authenticated_priority > 0 ? var.authenticated_priority + count.index : null

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = var.authentication_cognito_user_pool_arn
      user_pool_client_id = var.authentication_cognito_user_pool_client_id
      user_pool_domain    = var.authentication_cognito_user_pool_domain
      scope               = var.authentication_cognito_scope

      on_unauthenticated_request          = var.authentication_cognito_on_unauthenticated_request
      authentication_request_extra_params = var.authentication_cognito_request_extra_params
    }
  }

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    host_header {
      values = var.authenticated_hosts
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "unauthenticated_hosts_paths" {
  count = module.this.enabled && length(var.unauthenticated_paths) > 0 && length(var.unauthenticated_hosts) > 0 ? length(var.unauthenticated_listener_arns) : 0

  listener_arn = var.unauthenticated_listener_arns[count.index]
  priority     = var.unauthenticated_priority > 0 ? var.unauthenticated_priority + count.index : null

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    host_header {
      values = var.unauthenticated_hosts
    }
  }

  condition {
    path_pattern {
      values = var.unauthenticated_paths
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_paths_oidc" {
  count = module.this.enabled && var.authentication_type == "OIDC" && length(var.authenticated_paths) > 0 && length(var.authenticated_hosts) > 0 ? length(var.authenticated_listener_arns) : 0

  listener_arn = var.authenticated_listener_arns[count.index]
  priority     = var.authenticated_priority > 0 ? var.authenticated_priority + count.index : null

  action {
    type = "authenticate-oidc"

    authenticate_oidc {
      client_id              = var.authentication_oidc_client_id
      client_secret          = var.authentication_oidc_client_secret
      issuer                 = var.authentication_oidc_issuer
      authorization_endpoint = var.authentication_oidc_authorization_endpoint
      token_endpoint         = var.authentication_oidc_token_endpoint
      user_info_endpoint     = var.authentication_oidc_user_info_endpoint
      scope                  = var.authentication_oidc_scope

      on_unauthenticated_request          = var.authentication_oidc_on_unauthenticated_request
      authentication_request_extra_params = var.authentication_oidc_request_extra_params
    }
  }

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    host_header {
      values = var.authenticated_hosts
    }
  }

  condition {
    path_pattern {
      values = var.authenticated_paths
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_paths_cognito" {
  count = module.this.enabled && var.authentication_type == "COGNITO" && length(var.authenticated_paths) > 0 && length(var.authenticated_hosts) > 0 ? length(var.authenticated_listener_arns) : 0

  listener_arn = var.authenticated_listener_arns[count.index]
  priority     = var.authenticated_priority > 0 ? var.authenticated_priority + count.index : null

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = var.authentication_cognito_user_pool_arn
      user_pool_client_id = var.authentication_cognito_user_pool_client_id
      user_pool_domain    = var.authentication_cognito_user_pool_domain
      scope               = var.authentication_cognito_scope

      on_unauthenticated_request          = var.authentication_cognito_on_unauthenticated_request
      authentication_request_extra_params = var.authentication_cognito_request_extra_params
    }
  }

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    host_header {
      values = var.authenticated_hosts
    }
  }

  condition {
    path_pattern {
      values = var.authenticated_paths
    }
  }

  dynamic "condition" {
    for_each = length(var.listener_http_header_conditions) > 0 ? [""] : []
    content {
      dynamic "http_header" {
        for_each = var.listener_http_header_conditions

        content {
          http_header_name = http_header.value["name"]
          values           = http_header.value["value"]
        }
      }
    }
  }
}
