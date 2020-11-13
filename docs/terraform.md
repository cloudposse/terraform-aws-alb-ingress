<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 2.42 |
| local | >= 1.3 |
| null | >= 2.0 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.42 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| authenticated\_hosts | Authenticated hosts to match in Hosts header | `list(string)` | `[]` | no |
| authenticated\_listener\_arns | A list of authenticated ALB listener ARNs to attach ALB listener rules to | `list(string)` | `[]` | no |
| authenticated\_listener\_arns\_count | The number of authenticated ARNs in `authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | `number` | `0` | no |
| authenticated\_paths | Authenticated path pattern to match (a maximum of 1 can be defined) | `list(string)` | `[]` | no |
| authenticated\_priority | The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `unauthenticated_priority` since a listener can't have multiple rules with the same priority | `number` | `0` | no |
| authentication\_cognito\_scope | Cognito scope | `list(string)` | `[]` | no |
| authentication\_cognito\_user\_pool\_arn | Cognito User Pool ARN | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_client\_id | Cognito User Pool Client ID | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_domain | Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com) | `string` | `""` | no |
| authentication\_oidc\_authorization\_endpoint | OIDC Authorization Endpoint | `string` | `""` | no |
| authentication\_oidc\_client\_id | OIDC Client ID | `string` | `""` | no |
| authentication\_oidc\_client\_secret | OIDC Client Secret | `string` | `""` | no |
| authentication\_oidc\_issuer | OIDC Issuer | `string` | `""` | no |
| authentication\_oidc\_scope | OIDC scope | `list(string)` | `[]` | no |
| authentication\_oidc\_token\_endpoint | OIDC Token Endpoint | `string` | `""` | no |
| authentication\_oidc\_user\_info\_endpoint | OIDC User Info Endpoint | `string` | `""` | no |
| authentication\_type | Authentication type. Supported values are `COGNITO` and `OIDC` | `string` | `""` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| default\_target\_group\_enabled | Enable/disable creation of the default target group | `bool` | `true` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| deregistration\_delay | The amount of time to wait in seconds while deregistering target | `number` | `15` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| health\_check\_enabled | Indicates whether health checks are enabled. Defaults to `true` | `bool` | `true` | no |
| health\_check\_healthy\_threshold | The number of consecutive health checks successes required before healthy | `number` | `2` | no |
| health\_check\_interval | The duration in seconds in between health checks | `number` | `15` | no |
| health\_check\_matcher | The HTTP response codes to indicate a healthy check | `string` | `"200-399"` | no |
| health\_check\_path | The destination for the health check request | `string` | `"/"` | no |
| health\_check\_port | The port to use to connect with the target. Valid values are either ports 1-65536, or `traffic-port`. Defaults to `traffic-port` | `string` | `"traffic-port"` | no |
| health\_check\_protocol | The protocol to use to connect with the target. Defaults to `HTTP`. Not applicable when `target_type` is `lambda` | `string` | `"HTTP"` | no |
| health\_check\_timeout | The amount of time to wait in seconds before failing a health check request | `number` | `10` | no |
| health\_check\_unhealthy\_threshold | The number of consecutive health check failures required before unhealthy | `number` | `2` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| port | The port for the created ALB target group (if `target_group_arn` is not set) | `number` | `80` | no |
| protocol | The protocol for the created ALB target group (if `target_group_arn` is not set) | `string` | `"HTTP"` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| slow\_start | The amount of time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is `0` seconds | `number` | `0` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| stickiness\_cookie\_duration | The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds) | `number` | `86400` | no |
| stickiness\_enabled | Boolean to enable / disable `stickiness`. Default is `true` | `bool` | `true` | no |
| stickiness\_type | The type of sticky sessions. The only current possible value is `lb_cookie` | `string` | `"lb_cookie"` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| target\_group\_arn | Existing ALB target group ARN. If provided, set `default_target_group_enabled` to `false` to disable creation of the default target group | `string` | `""` | no |
| target\_type | The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group | `string` | `"ip"` | no |
| unauthenticated\_hosts | Unauthenticated hosts to match in Hosts header | `list(string)` | `[]` | no |
| unauthenticated\_listener\_arns | A list of unauthenticated ALB listener ARNs to attach ALB listener rules to | `list(string)` | `[]` | no |
| unauthenticated\_listener\_arns\_count | The number of unauthenticated ARNs in `unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | `number` | `0` | no |
| unauthenticated\_paths | Unauthenticated path pattern to match (a maximum of 1 can be defined) | `list(string)` | `[]` | no |
| unauthenticated\_priority | The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `authenticated_priority` since a listener can't have multiple rules with the same priority | `number` | `0` | no |
| vpc\_id | The VPC ID where generated ALB target group will be provisioned (if `target_group_arn` is not set) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| target\_group\_arn | ALB Target Group ARN |
| target\_group\_arn\_suffix | ALB Target Group ARN suffix |
| target\_group\_name | ALB Target Group name |

<!-- markdownlint-restore -->
