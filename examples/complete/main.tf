provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.18.0"

  cidr_block = var.vpc_cidr_block

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.31.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "alb" {
  source  = "cloudposse/alb/aws"
  version = "0.21.0"

  vpc_id                                  = module.vpc.vpc_id
  security_group_ids                      = [module.vpc.vpc_default_security_group_id]
  subnet_ids                              = module.subnets.public_subnet_ids
  internal                                = var.internal
  http_enabled                            = var.http_enabled
  access_logs_enabled                     = var.access_logs_enabled
  alb_access_logs_s3_bucket_force_destroy = var.alb_access_logs_s3_bucket_force_destroy
  cross_zone_load_balancing_enabled       = var.cross_zone_load_balancing_enabled
  http2_enabled                           = var.http2_enabled
  idle_timeout                            = var.idle_timeout
  ip_address_type                         = var.ip_address_type
  deletion_protection_enabled             = var.deletion_protection_enabled
  deregistration_delay                    = var.deregistration_delay
  health_check_path                       = var.health_check_path
  health_check_timeout                    = var.health_check_timeout
  health_check_healthy_threshold          = var.health_check_healthy_threshold
  health_check_unhealthy_threshold        = var.health_check_unhealthy_threshold
  health_check_interval                   = var.health_check_interval
  health_check_matcher                    = var.health_check_matcher
  target_group_port                       = var.target_group_port
  target_group_target_type                = var.target_group_target_type

  context = module.this.context
}

module "alb_ingress" {
  source = "../.."

  vpc_id                              = module.vpc.vpc_id
  authentication_type                 = var.authentication_type
  unauthenticated_priority            = var.unauthenticated_priority
  unauthenticated_paths               = var.unauthenticated_paths
  slow_start                          = var.slow_start
  stickiness_enabled                  = var.stickiness_enabled
  default_target_group_enabled        = false
  target_group_arn                    = module.alb.default_target_group_arn
  unauthenticated_listener_arns       = [module.alb.http_listener_arn]
  unauthenticated_listener_arns_count = 1

  context = module.this.context
}
