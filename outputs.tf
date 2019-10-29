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

output "paths_listener_rule_id" {
  description = "Paths listener rule ID"
  value = coalesce(
    join("", aws_lb_listener_rule.unauthenticated_paths.*.id),
    join("", aws_lb_listener_rule.authenticated_paths_cognito.*.id),
    join("", aws_lb_listener_rule.authenticated_paths_oidc.*.id)
  )
}

output "hosts_listener_rule_id" {
  description = "Hosts listener rule ID"
  value = coalesce(
    join("", aws_lb_listener_rule.unauthenticated_hosts.*.id),
    join("", aws_lb_listener_rule.authenticated_hosts_cognito.*.id),
    join("", aws_lb_listener_rule.authenticated_hosts_oidc.*.id)
  )
}
