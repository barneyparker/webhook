variable "api_name" {
  type = string
  description = "Name for the Webhook API Gateway"
}

variable "api_description" {
  type = string
  description = "API Description"
  default = "GitHub Webhook Endpoint"
}

variable "api_log_group" {
  type = string
  description = "CloudWatch Log Group for the API"
}

variable "api_domain" {
  type = string
  description = "Route53 Domain Name"
}

variable "api_subdomain" {
  type = string
  description = "Route53 Record Name"
}

variable "api_zone_id" {
  type = string
  description = "Route53 Zone ID"
}

variable "api_certificate_arn" {
  type = string
  description = "Valid ACM Certificate arn for {subdomain}.{domain}"
}

variable "table_name" {
  type = string
  description = "DynamoDB Table Name"
}

variable "log_retention" {
  type = number
  description = "Log Retention in Days"
}