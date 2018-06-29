output "target_group_name" {
  description = "ALB Target group name"
  value       = "${data.aws_lb_target_group.default.name}"
}

output "target_group_arn" {
  description = "ALB Target group ARN"
  value       = "${data.aws_lb_target_group.default.arn}"
}

output "target_group_arn_suffix" {
  description = "ALB Target group ARN suffix"
  value       = "${data.aws_lb_target_group.default.arn_suffix}"
}
