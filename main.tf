locals {
  target_group_enabled = "${var.target_group_arn == "" ? "true" : "false"}"
  target_group_arn     = "${local.target_group_enabled == "true" ? join("", aws_lb_target_group.default.*.arn) : var.target_group_arn}"
}

data "aws_lb_target_group" "default" {
  arn = "${local.target_group_arn}"
}

module "default_label" {
  enabled    = "${local.target_group_enabled}"
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_lb_target_group" "default" {
  count       = "${local.target_group_enabled == "true" ? 1 : 0}"
  name        = "${module.default_label.id}"
  port        = "${var.port}"
  protocol    = "${var.protocol}"
  slow_start  = "${var.slow_start}"
  tags        = "${var.tags}"
  target_type = "${var.target_type}"
  vpc_id      = "${var.vpc_id}"

  deregistration_delay = "${var.deregistration_delay}"

  stickiness = {
    type            = "${var.stickiness_type}"
    cookie_duration = "${var.stickiness_cookie_duration}"
    enabled         = "${var.stickiness_enabled}"
  }

  health_check {
    enabled             = "${var.health_check_enabled}"
    path                = "${var.health_check_path}"
    port                = "${coalesce(var.health_check_port, var.port)}"
    protocol            = "${coalesce(var.health_check_protocol, var.protocol)}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    interval            = "${var.health_check_interval}"
    matcher             = "${var.health_check_matcher}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "unauthenticated_paths" {
  count        = "${length(var.unauthenticated_paths) > 0 && length(var.unauthenticated_hosts) == 0 ? var.unauthenticated_listener_arns_count : 0}"
  listener_arn = "${var.unauthenticated_listener_arns[count.index]}"
  priority     = "${var.unauthenticated_priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "path-pattern"
    values = ["${var.unauthenticated_paths}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_paths_oidc" {
  count        = "${var.authentication_type == "OIDC" && length(var.authenticated_paths) > 0 && length(var.authenticated_hosts) == 0 ? var.authenticated_listener_arns_count : 0}"
  listener_arn = "${var.authenticated_listener_arns[count.index]}"
  priority     = "${var.authenticated_priority + count.index}"

  action = [
    {
      type = "authenticate-oidc"

      authenticate_oidc {
        client_id              = "${var.authentication_oidc_client_id}"
        client_secret          = "${var.authentication_oidc_client_secret}"
        issuer                 = "${var.authentication_oidc_issuer}"
        authorization_endpoint = "${var.authentication_oidc_authorization_endpoint}"
        token_endpoint         = "${var.authentication_oidc_token_endpoint}"
        user_info_endpoint     = "${var.authentication_oidc_user_info_endpoint}"
      }
    },
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "path-pattern"
    values = ["${var.authenticated_paths}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_paths_cognito" {
  count        = "${var.authentication_type == "COGNITO" && length(var.authenticated_paths) > 0 && length(var.authenticated_hosts) == 0 ? var.authenticated_listener_arns_count : 0}"
  listener_arn = "${var.authenticated_listener_arns[count.index]}"
  priority     = "${var.authenticated_priority + count.index}"

  action = [
    {
      type = "authenticate-cognito"

      authenticate_cognito {
        user_pool_arn       = "${var.authentication_cognito_user_pool_arn}"
        user_pool_client_id = "${var.authentication_cognito_user_pool_client_id}"
        user_pool_domain    = "${var.authentication_cognito_user_pool_domain}"
      }
    },
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "path-pattern"
    values = ["${var.authenticated_paths}"]
  }
}

resource "aws_lb_listener_rule" "unauthenticated_hosts" {
  count        = "${length(var.unauthenticated_hosts) > 0 && length(var.unauthenticated_paths) == 0 ? var.unauthenticated_listener_arns_count : 0}"
  listener_arn = "${var.unauthenticated_listener_arns[count.index]}"
  priority     = "${var.unauthenticated_priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.unauthenticated_hosts}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_oidc" {
  count        = "${var.authentication_type == "OIDC" && length(var.authenticated_hosts) > 0 && length(var.authenticated_paths) == 0 ? var.authenticated_listener_arns_count : 0}"
  listener_arn = "${var.authenticated_listener_arns[count.index]}"
  priority     = "${var.authenticated_priority + count.index}"

  action = [
    {
      type = "authenticate-oidc"

      authenticate_oidc {
        client_id              = "${var.authentication_oidc_client_id}"
        client_secret          = "${var.authentication_oidc_client_secret}"
        issuer                 = "${var.authentication_oidc_issuer}"
        authorization_endpoint = "${var.authentication_oidc_authorization_endpoint}"
        token_endpoint         = "${var.authentication_oidc_token_endpoint}"
        user_info_endpoint     = "${var.authentication_oidc_user_info_endpoint}"
      }
    },
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.authenticated_hosts}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_cognito" {
  count        = "${var.authentication_type == "COGNITO" && length(var.authenticated_hosts) > 0 && length(var.authenticated_paths) == 0 ? var.authenticated_listener_arns_count : 0}"
  listener_arn = "${var.authenticated_listener_arns[count.index]}"
  priority     = "${var.authenticated_priority + count.index}"

  action = [
    {
      type = "authenticate-cognito"

      authenticate_cognito {
        user_pool_arn       = "${var.authentication_cognito_user_pool_arn}"
        user_pool_client_id = "${var.authentication_cognito_user_pool_client_id}"
        user_pool_domain    = "${var.authentication_cognito_user_pool_domain}"
      }
    },
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.authenticated_hosts}"]
  }
}

resource "aws_lb_listener_rule" "unauthenticated_hosts_paths" {
  count        = "${length(var.unauthenticated_paths) > 0 && length(var.unauthenticated_hosts) > 0 ? var.unauthenticated_listener_arns_count : 0}"
  listener_arn = "${var.unauthenticated_listener_arns[count.index]}"
  priority     = "${var.unauthenticated_priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.unauthenticated_hosts}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.unauthenticated_paths}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_paths_oidc" {
  count        = "${var.authentication_type == "OIDC" && length(var.authenticated_paths) > 0 && length(var.authenticated_hosts) > 0 ? var.authenticated_listener_arns_count : 0}"
  listener_arn = "${var.authenticated_listener_arns[count.index]}"
  priority     = "${var.authenticated_priority + count.index}"

  action = [
    {
      type = "authenticate-oidc"

      authenticate_oidc {
        client_id              = "${var.authentication_oidc_client_id}"
        client_secret          = "${var.authentication_oidc_client_secret}"
        issuer                 = "${var.authentication_oidc_issuer}"
        authorization_endpoint = "${var.authentication_oidc_authorization_endpoint}"
        token_endpoint         = "${var.authentication_oidc_token_endpoint}"
        user_info_endpoint     = "${var.authentication_oidc_user_info_endpoint}"
      }
    },
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.authenticated_hosts}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.authenticated_paths}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_paths_cognito" {
  count        = "${var.authentication_type == "COGNITO" && length(var.authenticated_paths) > 0 && length(var.authenticated_hosts) > 0 ? var.authenticated_listener_arns_count : 0}"
  listener_arn = "${var.authenticated_listener_arns[count.index]}"
  priority     = "${var.authenticated_priority + count.index}"

  action = [
    {
      type = "authenticate-cognito"

      authenticate_cognito {
        user_pool_arn       = "${var.authentication_cognito_user_pool_arn}"
        user_pool_client_id = "${var.authentication_cognito_user_pool_client_id}"
        user_pool_domain    = "${var.authentication_cognito_user_pool_domain}"
      }
    },
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.authenticated_hosts}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.authenticated_paths}"]
  }
}
