variable "default_target_group_enabled" {
  type        = bool
  default     = true
  description = "Enable/disable creation of the default target group"
}

variable "target_group_arn" {
  type        = string
  default     = ""
  description = "Existing ALB target group ARN. If provided, set `default_target_group_enabled` to `false` to disable creation of the default target group"
}

variable "unauthenticated_listener_arns" {
  type        = list(string)
  default     = []
  description = "A list of unauthenticated ALB listener ARNs to attach ALB listener rules to"
}

variable "listener_http_header_conditions" {
  type = list(object({
    name  = string
    value = list(string)
  }))
  default     = []
  description = "A list of http header conditions to apply to the listener."
}

variable "authenticated_listener_arns" {
  type        = list(string)
  default     = []
  description = "A list of authenticated ALB listener ARNs to attach ALB listener rules to"
}

variable "deregistration_delay" {
  type        = number
  default     = 15
  description = "The amount of time to wait in seconds while deregistering target"
}

variable "load_balancing_algorithm_type" {
  type        = string
  default     = "round_robin"
  description = "Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is round_robin or least_outstanding_requests. The default is round_robin."
}

variable "health_check_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether health checks are enabled. Defaults to `true`"
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination for the health check request"
}

variable "health_check_port" {
  type        = string
  default     = "traffic-port"
  description = "The port to use to connect with the target. Valid values are either ports 1-65536, or `traffic-port`. Defaults to `traffic-port`"
}

variable "health_check_protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol to use to connect with the target. Defaults to `HTTP`. Not applicable when `target_type` is `lambda`"
}

variable "health_check_timeout" {
  type        = number
  default     = 10
  description = "The amount of time to wait in seconds before failing a health check request"
}

variable "health_check_healthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health checks successes required before healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health check failures required before unhealthy"
}

variable "health_check_interval" {
  type        = number
  default     = 15
  description = "The duration in seconds in between health checks"
}

variable "health_check_matcher" {
  type        = string
  default     = "200-399"
  description = "The HTTP response codes to indicate a healthy check"
}

variable "unauthenticated_priority" {
  type        = number
  default     = null
  description = "The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `authenticated_priority` since a listener can't have multiple rules with the same priority"
}

variable "authenticated_priority" {
  type        = number
  default     = null
  description = "The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `unauthenticated_priority` since a listener can't have multiple rules with the same priority"
}

variable "port" {
  type        = number
  default     = 80
  description = "The port for the created ALB target group (if `target_group_arn` is not set)"
}

variable "protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol for the created ALB target group (if `target_group_arn` is not set)"
}

variable "target_type" {
  type        = string
  default     = "ip"
  description = "The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where generated ALB target group will be provisioned (if `target_group_arn` is not set)"
}

variable "unauthenticated_hosts" {
  type        = list(string)
  default     = []
  description = "Unauthenticated hosts to match in Hosts header"
}

variable "authenticated_hosts" {
  type        = list(string)
  default     = []
  description = "Authenticated hosts to match in Hosts header"
}

variable "unauthenticated_paths" {
  type        = list(string)
  default     = []
  description = "Unauthenticated path pattern to match (a maximum of 1 can be defined)"
}

variable "authenticated_paths" {
  type        = list(string)
  default     = []
  description = "Authenticated path pattern to match (a maximum of 1 can be defined)"
}

variable "authentication_type" {
  type        = string
  default     = ""
  description = "Authentication type. Supported values are `COGNITO` and `OIDC`"
}

variable "authentication_cognito_user_pool_arn" {
  type        = string
  description = "Cognito User Pool ARN"
  default     = ""
}

variable "authentication_cognito_user_pool_client_id" {
  type        = string
  description = "Cognito User Pool Client ID"
  default     = ""
}

variable "authentication_cognito_user_pool_domain" {
  type        = string
  description = "Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com)"
  default     = ""
}

variable "authentication_cognito_scope" {
  type        = string
  description = "Cognito scope, which should be a space separated string of requested scopes (see https://openid.net/specs/openid-connect-core-1_0.html#ScopeClaims)"
  default     = null
}

variable "authentication_cognito_on_unauthenticated_request" {
  type        = string
  description = "Cognito unauthenticated behavior, deny, allow, or authenticate"
  default     = "authenticate"
}

variable "authentication_cognito_request_extra_params" {
  type        = map(string)
  description = "Cognito query parameters to include in redirect request"
  default     = null
}

variable "authentication_oidc_client_id" {
  type        = string
  description = "OIDC Client ID"
  default     = ""
}

variable "authentication_oidc_client_secret" {
  type        = string
  description = "OIDC Client Secret"
  default     = ""
}

variable "authentication_oidc_issuer" {
  type        = string
  description = "OIDC Issuer"
  default     = ""
}

variable "authentication_oidc_authorization_endpoint" {
  type        = string
  description = "OIDC Authorization Endpoint"
  default     = ""
}

variable "authentication_oidc_token_endpoint" {
  type        = string
  description = "OIDC Token Endpoint"
  default     = ""
}

variable "authentication_oidc_user_info_endpoint" {
  type        = string
  description = "OIDC User Info Endpoint"
  default     = ""
}

variable "authentication_oidc_scope" {
  type        = string
  description = "OIDC scope, which should be a space separated string of requested scopes (see https://openid.net/specs/openid-connect-core-1_0.html#ScopeClaims, and https://developers.google.com/identity/protocols/oauth2/openid-connect#scope-param for an example set of scopes when using Google as the IdP)"
  default     = null
}

variable "authentication_oidc_on_unauthenticated_request" {
  type        = string
  description = "OIDC unauthenticated behavior, deny, allow, or authenticate"
  default     = "authenticate"
}

variable "authentication_oidc_request_extra_params" {
  type        = map(string)
  description = "OIDC query parameters to include in redirect request"
  default     = null
}

variable "slow_start" {
  type        = number
  default     = 0
  description = "The amount of time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is `0` seconds"
}

variable "stickiness_type" {
  type        = string
  default     = "lb_cookie"
  description = "The type of sticky sessions. The only current possible value is `lb_cookie`"
}

variable "stickiness_cookie_duration" {
  type        = number
  default     = 86400
  description = "The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds)"
}

variable "stickiness_enabled" {
  type        = bool
  default     = true
  description = "Boolean to enable / disable `stickiness`. Default is `true`"
}
