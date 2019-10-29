output "target_group_name" {
  description = "ALB Target Group name"
  value       = data.aws_lb_target_group.default.name
}

output "target_group_arn" {
  description = "ALB Target Group ARN"
  value       = data.aws_lb_target_group.default.arn
}

output "target_group_arn_suffix" {
  description = "ALB Target Group ARN suffix"
  value       = data.aws_lb_target_group.default.arn_suffix
}
