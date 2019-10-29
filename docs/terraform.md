## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (_e.g._ "1") | list(string) | `<list>` | no |
| authenticated_hosts | Authenticated hosts to match in Hosts header | list(string) | `<list>` | no |
| authenticated_listener_arns | A list of authenticated ALB listener ARNs to attach ALB listener rules to | list(string) | `<list>` | no |
| authenticated_listener_arns_count | The number of authenticated ARNs in `authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | number | `0` | no |
| authenticated_paths | Authenticated path pattern to match (a maximum of 1 can be defined) | list(string) | `<list>` | no |
| authenticated_priority | The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `unauthenticated_priority` since a listener can't have multiple rules with the same priority | number | `300` | no |
| authentication_cognito_user_pool_arn | Cognito User Pool ARN | string | `` | no |
| authentication_cognito_user_pool_client_id | Cognito User Pool Client ID | string | `` | no |
| authentication_cognito_user_pool_domain | Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com) | string | `` | no |
| authentication_oidc_authorization_endpoint | OIDC Authorization Endpoint | string | `` | no |
| authentication_oidc_client_id | OIDC Client ID | string | `` | no |
| authentication_oidc_client_secret | OIDC Client Secret | string | `` | no |
| authentication_oidc_issuer | OIDC Issuer | string | `` | no |
| authentication_oidc_token_endpoint | OIDC Token Endpoint | string | `` | no |
| authentication_oidc_user_info_endpoint | OIDC User Info Endpoint | string | `` | no |
| authentication_type | Authentication type. Supported values are `COGNITO` and `OIDC` | string | `` | no |
| delimiter | Delimiter between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| deregistration_delay | The amount of time to wait in seconds while deregistering target | number | `15` | no |
| health_check_enabled | Indicates whether health checks are enabled. Defaults to `true` | bool | `true` | no |
| health_check_healthy_threshold | The number of consecutive health checks successes required before healthy | number | `2` | no |
| health_check_interval | The duration in seconds in between health checks | number | `15` | no |
| health_check_matcher | The HTTP response codes to indicate a healthy check | string | `200-399` | no |
| health_check_path | The destination for the health check request | string | `/` | no |
| health_check_port | The port to use to connect with the target. Valid values are either ports 1-65536, or `traffic-port`. Defaults to `traffic-port` | string | `traffic-port` | no |
| health_check_protocol | The protocol to use to connect with the target. Defaults to `HTTP`. Not applicable when `target_type` is `lambda` | string | `HTTP` | no |
| health_check_timeout | The amount of time to wait in seconds before failing a health check request | number | `10` | no |
| health_check_unhealthy_threshold | The number of consecutive health check failures required before unhealthy | number | `2` | no |
| name | Name of the application | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | `` | no |
| port | The port for the created ALB target group (if `target_group_arn` is not set) | number | `80` | no |
| protocol | The protocol for the created ALB target group (if `target_group_arn` is not set) | string | `HTTP` | no |
| slow_start | The amount of time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is `0` seconds | number | `0` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | `` | no |
| stickiness_cookie_duration | The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds) | number | `86400` | no |
| stickiness_enabled | Boolean to enable / disable `stickiness`. Default is `true` | bool | `true` | no |
| stickiness_type | The type of sticky sessions. The only current possible value is `lb_cookie` | string | `lb_cookie` | no |
| tags | Additional tags (_e.g._ { BusinessUnit : ABC }) | map(string) | `<map>` | no |
| target_group_arn | ALB target group ARN. If this is an empty string, a new target group will be created | string | `` | no |
| target_type | The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group | string | `ip` | no |
| unauthenticated_hosts | Unauthenticated hosts to match in Hosts header | list(string) | `<list>` | no |
| unauthenticated_listener_arns | A list of unauthenticated ALB listener ARNs to attach ALB listener rules to | list(string) | `<list>` | no |
| unauthenticated_listener_arns_count | The number of unauthenticated ARNs in `unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | number | `0` | no |
| unauthenticated_paths | Unauthenticated path pattern to match (a maximum of 1 can be defined) | list(string) | `<list>` | no |
| unauthenticated_priority | The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `authenticated_priority` since a listener can't have multiple rules with the same priority | number | `100` | no |
| vpc_id | The VPC ID where generated ALB target group will be provisioned (if `target_group_arn` is not set) | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| hosts_listener_rule_id | Hosts listener rule ID |
| paths_listener_rule_id | Paths listener rule ID |
| target_group_arn | ALB Target Group ARN |
| target_group_arn_suffix | ALB Target Group ARN suffix |
| target_group_name | ALB Target Group name |

