![Cloud Posse](https://cloudposse.com/logo-300x69.png)

# terraform-aws-alb-ingress [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-alb-ingress.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-alb-ingress) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)

A Terraform module to provision an HTTP style ingress based on hostname and path.

## Usage

```
module "alb" {
  source     = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=master"
  namespace  = "eg"
  stage      = "dev"
  name       = "web"
  vpc_id     = "..."
}

module "api_ingress" {
  source            = "git::https://github.com/cloudposse/terraform-aws-alb-ingress.git?ref=master"
  namespace         = "eg"
  stage             = "dev"
  name              = "web"
  attributes        = "api"
  vpc_id            = "..."
  target_group_arn  = "${module.alb.default_target_group_arn}"
  paths             = ["/api/*"]
}

module "blog_ingress" {
  source            = "git::https://github.com/cloudposse/terraform-aws-alb-ingress.git?ref=master"
  namespace         = "eg"
  stage             = "dev"
  name              = "web"
  attributes        = "blog"
  vpc_id            = "..."
  target_group_arn  = "${module.alb.default_target_group_arn}"
  paths             = ["/blog/*"]
}

module "blog_service" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=0.1.0"
  namespace                 = "eg"
  stage                     = "dev"
  name                      = "blog"
  alb_target_group_arn      = "${module.alb.default_target_group.arn}"
  container_definition_json = "${module.container_definition.json}"
  ecr_repository_name       = "${module.ecr.repository_name}"
  ecs_cluster_arn           = "${aws_ecs_cluster.default.arn}"
  launch_type               = "FARGATE"
  vpc_id                    = "${module.vpc.vpc_id}"
  security_group_ids        = ["${module.vpc.vpc_default_security_group_id}"]
  private_subnet_ids        = "${module.dynamic_subnets.private_subnet_ids}"
}
```

## Inputs

| Name                               |    Default      | Description                                                                      | Required |
|:-----------------------------------|:---------------:|:---------------------------------------------------------------------------------|:--------:|
| `namespace`                        |      ``         | Namespace (e.g. `cp` or `cloudposse`)                                            |   Yes    |
| `stage`                            |      ``         | Stage (e.g. `prod`, `dev`, `staging`)                                            |   Yes    |
| `name`                             |      ``         | Name  (e.g. `app` or `cluster`)                                                  |   Yes    |
| `target_group_arn`                 |      ``         | ALB target group ARN, if this is an empty string a new one will be generated     |    No    |
| `listener_arns`                    |     `[]`        | A list of ALB listener ARNs to attach ALB listener rule to                       |    No    |
| `deregistration_delay`             |     `15`        | The amount of time to wait in seconds while deregistering target                 |    No    |
| `health_check_path`                |     `/`         | The destination for the health check request                                     |    No    |
| `health_check_timeout`             |     `10`        | The amount of time to wait in seconds before failing a health check request      |    No    |
| `health_check_healthy_threshold`   |     `2`         | The number of consecutive health checks successes required before healthy        |    No    |
| `health_check_unhealthy_threshold` |     `2`         | The number of consecutive health check failures required before unhealthy        |    No    |
| `health_check_interval`            |     `15`        | The duration in seconds in between health checks                                 |    No    |
| `health_check_matcher`             |   `200-399`     | The HTTP response codes to indicate a healthy check                              |    No    |
| `priority`                         |     `100`       | The priority for the rule between 1 and 50000 (1 being highest priority)         |    No    |
| `port`                             |     `80`        | The port for generated ALB target group (if target_group_arn not set)            |    No    |
| `protocol`                         |    `HTTP`       | The protocol for generated ALB target group (if target_group_arn not set)        |    No    |
| `vpc_id`                           |      ``         | The VPC ID where generated ALB target group (if target_group_arn not set)        |    No    |
| `paths`                            |   `["/*"]`      | Path pattern to match (a maximum of 1 can be defined)                            |    No    |
| `attributes`                       |     `[]`        | Additional attributes (e.g. `1`)                                                 |    No    |
| `tags`                             |     `{}`        | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                               |    No    |
| `delimiter`                        |     `-`         | Delimiter to be used between `namespace`, `stage`, `name` and `attributes`       |    No    |



## Outputs

| Name                            | Description                                                     |
|:--------------------------------|:----------------------------------------------------------------|
| `target_group_arn`              | The target group ARN                                            |


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/default-backend/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Slack](https://slack.cloudposse.com).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-alb-ingress/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing `terraform-aws-alb-ingress`, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!

## License

[APACHE 2.0](LICENSE) © 2018 [Cloud Posse, LLC](https://cloudposse.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

## About

This project is maintained and funded by [Cloud Posse, LLC][website].

![Cloud Posse](https://cloudposse.com/logo-300x69.png)


Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)!

See [our other projects][community]
or [hire us][hire] to help build your next cloud platform.

  [website]: https://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: https://cloudposse.com/contact/


## Contributors

| [![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] | [![Andriy Knysh][andriy_img]][andriy_web]<br/>[Andriy Knysh][andriy_web] |[![Igor Rodionov][igor_img]][igor_web]<br/>[Igor Rodionov][igor_img]|[![Sarkis Varozian][sarkis_img]][sarkis_web]<br/>[Sarkis Varozian][sarkis_web] |
|-------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|

[erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
[erik_web]: https://github.com/osterman/
[andriy_img]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
[andriy_web]: https://github.com/aknysh/
[igor_img]: http://s.gravatar.com/avatar/bc70834d32ed4517568a1feb0b9be7e2?s=144
[igor_web]: https://github.com/goruha/
[sarkis_img]: https://avatars3.githubusercontent.com/u/42673?s=144&v=4
[sarkis_web]: https://github.com/sarkis/