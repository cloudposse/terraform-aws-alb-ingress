
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes, e.g. `1` | list | `<list>` | no |
| delimiter | Delimiter to be used between `namespace`, `name`, `stage` and `attributes` | string | `-` | no |
| deregistration_delay | The amount of time to wait in seconds while deregistering target | string | `15` | no |
| health_check_healthy_threshold | The number of consecutive health checks successes required before healthy | string | `2` | no |
| health_check_interval | The duration in seconds in between health checks | string | `15` | no |
| health_check_matcher | The HTTP response codes to indicate a healthy check | string | `200-399` | no |
| health_check_path | The destination for the health check request | string | `/` | no |
| health_check_timeout | The amount of time to wait in seconds before failing a health check request | string | `10` | no |
| health_check_unhealthy_threshold | The number of consecutive health check failures required before unhealthy | string | `2` | no |
| hosts | Hosts to match in Hosts header, at least one of hosts or paths must be set | list | `<list>` | no |
| listener_arns | A list of ALB listener ARNs to attach ALB listener rule to | list | `<list>` | no |
| listener_arns_count | The number of ARNs in listener_arns, this is necessary to work around a limitation in Terraform where counts cannot be computed | string | `0` | no |
| name | Solution name, e.g. `app` | string | - | yes |
| namespace | Namespace, which could be your organization name, e.g. `cp` or `cloudposse` | string | - | yes |
| paths | Path pattern to match (a maximum of 1 can be defined), at least one of hosts or paths must be set | list | `<list>` | no |
| port | The port for generated ALB target group (if target_group_arn not set) | string | `80` | no |
| priority | The priority for the rule between 1 and 50000 (1 being highest priority) | string | `100` | no |
| protocol | The protocol for generated ALB target group (if target_group_arn not set) | string | `HTTP` | no |
| stage | Stage, e.g. `prod`, `staging`, `dev`, or `test` | string | - | yes |
| tags | Additional tags (e.g. `map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| target_group_arn | ALB target group ARN, if this is an empty string a new one will be generated | string | `` | no |
| target_group_name | Name of ALB target group if it is generated. | string | `` | no |
| target_type |  | string | `ip` | no |
| vpc_id | The VPC ID where generated ALB target group will be provisioned (if target_group_arn not set) | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| target_group_arn | ALB Target group ARN |
| target_group_arn_suffix | ALB Target group ARN suffix |
| target_group_name | ALB Target group name |

