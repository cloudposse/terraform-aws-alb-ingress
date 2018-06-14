locals {
  generate_target_group_arn = "${var.target_group_arn == "" ? 1 : 0}"
}

locals {
  target_group_arn = "${local.generate_target_group_arn ? aws_lb_target_group.default.arn : var.target_group_arn}"
}

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.1.3"
  enabled    = "${local.generate_target_group_arn}"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}


resource "aws_lb_target_group" "default" {
  count       = "${local.generate_target_group_arn}"
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

resource "aws_lb_listener_rule" "default" {
  count        = "${length(var.listener_arns)}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${local.target_group_arn}"
  }

//  condition {
//    field  = "host-header"
//    values = ["${var.hosts}"]
//  }

  condition {
    field  = "path-pattern"
    values = ["${var.paths}"]
  }
}
