locals {
  target_group_enabled   = "${var.target_group_arn == "" ? "true" : "false"}"
  target_group_arn       = "${local.target_group_enabled == "true" ? aws_lb_target_group.default.arn : var.target_group_arn}"
  authentication_enabled = "${var.authentication_enabled == "true" ? true : false}"
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
  vpc_id      = "${var.vpc_id}"
  target_type = "${var.target_type}"

  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path                = "${var.health_check_path}"
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

resource "aws_lb_listener_rule" "paths_no_authentication" {
  count        = "${length(var.paths) > 0 && length(var.hosts) == 0 && local.authentication_enabled == false ? var.listener_arns_count : 0}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "path-pattern"
    values = ["${var.paths}"]
  }
}

resource "aws_lb_listener_rule" "paths_with_authentication" {
  count        = "${length(var.paths) > 0 && length(var.hosts) == 0 && local.authentication_enabled == true ? var.listener_arns_count : 0}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action = [
    "${var.authentication_action}",
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "path-pattern"
    values = ["${var.paths}"]
  }
}

resource "aws_lb_listener_rule" "hosts_no_authentication" {
  count        = "${length(var.hosts) > 0 && length(var.paths) == 0 && local.authentication_enabled == false ? var.listener_arns_count : 0}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.hosts}"]
  }
}

resource "aws_lb_listener_rule" "hosts_with_authentication" {
  count        = "${length(var.hosts) > 0 && length(var.paths) == 0 && local.authentication_enabled == true ? var.listener_arns_count : 0}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action = [
    "${var.authentication_action}",
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.hosts}"]
  }
}

resource "aws_lb_listener_rule" "hosts_paths_no_authentication" {
  count        = "${length(var.paths) > 0 && length(var.hosts) > 0 && local.authentication_enabled == false ? var.listener_arns_count : 0}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.hosts}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.paths}"]
  }
}

resource "aws_lb_listener_rule" "hosts_paths_with_authentication" {
  count        = "${length(var.paths) > 0 && length(var.hosts) > 0 && local.authentication_enabled == true ? var.listener_arns_count : 0}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action = [
    "${var.authentication_action}",
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.hosts}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.paths}"]
  }
}
