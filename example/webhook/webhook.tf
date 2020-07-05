module "webhook" {
  source = "../../"

  api_name = "github-webhook"
  api_log_group = "/api/webhook"

  api_domain = "barneyparker.com"
  api_subdomain = "webhook"
  api_zone_id = data.aws_route53_zone.zone.zone_id
  api_certificate_arn = data.aws_acm_certificate.cert.arn

  table_name = "webhook_repositories"

  log_retention = 3
}