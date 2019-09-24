data "aws_vpc" "default" {
  default = true
}

module "ingress_example" {
  source    = "../"
  name      = "example"
  namespace = "cp"
  stage     = "dev"
  vpc_id    = "${data.aws_vpc.default.id}"

  port     = "80"
  protocol = "HTTP"

  health_check_enabled = false
}
