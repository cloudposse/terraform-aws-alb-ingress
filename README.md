# terraform-aws-alb-ingress

Terraform module to provision an HTTP style ingress based on hostname and path


Usage Example

```
module "alb" {
  source     = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=master"
  namespace  = "eg"
  stage      = "dev"
  name       = "web"
  vpc_id     = "..."
}

module "api_ingress" {
  source     = "git::https://github.com/cloudposse/terraform-aws-alb-ingress.git?ref=master"
  namespace  = "eg"
  stage      = "dev"
  name       = "web"
  attributes = "api"
  vpc_id     = "..."
  target_group_arn = "${module.alb.default_target_group_arn}"
  paths      = ["/api/*"]
}

module "blog_ingress" {
  source     = "git::https://github.com/cloudposse/terraform-aws-alb-ingress.git?ref=master"
  namespace  = "eg"
  stage      = "dev"
  name       = "web"
  attributes = "blog"
  vpc_id     = "..."
  target_group_arn = "${module.alb.default_target_group_arn}"
  paths      = ["/blog/*"]
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
