locals {
  app_id         = "sna"
  app_name       = "simple-nextjs-app"
  custom_domain  = "${var.environment}.${local.app_id}.${var.zone_name}"
  name           = "${var.namespace}-${var.environment}-${local.app_id}"
  container_name = local.app_id
  container_port = 3000

  tags = {
    Name        = local.name
    Environment = var.environment
    Description = "Managed by Terraform"
  }
}

data "aws_ecr_repository" "current" {
  name = "${var.namespace}/${local.app_name}"
}

################################################################################
# Service
################################################################################
module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.2.0"

  name        = "${local.name}-service"
  cluster_arn = var.ecs_cluster_arn

  cpu    = 1024
  memory = 4096

  # Container definition(s)
  container_definitions = {

    # fluent-bit = {
    #   cpu       = 512
    #   memory    = 1024
    #   essential = true
    #   image     = nonsensitive(data.aws_ssm_parameter.fluentbit.value)
    #   firelens_configuration = {
    #     type = "fluentbit"
    #   }
    #   memory_reservation = 50
    #   user               = "0"
    # }

    (local.container_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "${data.aws_ecr_repository.current.repository_url}:latest"
      port_mappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          hostPort      = local.container_port
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false

      # dependencies = [{
      #   containerName = "fluent-bit"
      #   condition     = "START"
      # }]

      enable_cloudwatch_logging = false
      # log_configuration = {
      #   logDriver = "awsfirelens"
      #   options = {
      #     Name                    = "firehose"
      #     region                  = local.region
      #     delivery_stream         = "my-stream"
      #     log-driver-buffer-limit = "2097152"
      #   }
      # }
      # memory_reservation = 100
    }
  }

  # service_connect_configuration = {
  #   namespace = aws_service_discovery_http_namespace.this.arn
  #   service = {
  #     client_alias = {
  #       port     = local.container_port
  #       dns_name = local.container_name
  #     }
  #     port_name      = local.container_name
  #     discovery_name = local.container_name
  #   }
  # }

  load_balancer = {
    service = {
      target_group_arn = element(module.alb.target_group_arns, 0)
      container_name   = local.container_name
      container_port   = local.container_port
    }
  }

  subnet_ids = var.private_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = local.container_port
      to_port                  = local.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb_sg.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = local.tags
}

################################################################################
# ALB and Custom domain
################################################################################
module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = var.private_subnets_cidr_blocks

  tags = local.tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${local.name}-alb"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "${local.name}-tg"
      backend_protocol = "HTTP"
      backend_port     = local.container_port
      target_type      = "ip"
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]

  tags = local.tags
}

data "aws_route53_zone" "this" {
  name = var.zone_name
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.custom_domain
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

################################################################################
# ACM certificate
################################################################################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name               = var.zone_name
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${local.custom_domain}"]

  wait_for_validation = true
}
