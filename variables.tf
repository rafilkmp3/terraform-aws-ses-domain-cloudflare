variable "domain_name" {
  description = "The domain name to configure SES."
  type        = string
}

variable "enable_verification" {
  description = "Control whether or not to verify SES DNS records."
  type        = bool
  default     = true
}
variable "enable_spf_domain" {
  description = "Control whether or not create SPF DNS records."
  type        = bool
  default     = true
}
variable "enable_mx_receive" {
  description = "Control whether or not to create DNS MX SES receive records."
  type        = bool
  default     = true
}
variable "enable_txt_dmarc" {
  description = "Control whether or not create txt DMARC DNS records."
  type        = bool
  default     = true
}


variable "mail_from_domain" {
  description = " Subdomain (of the route53 zone) which is to be used as MAIL FROM address"
  type        = string
}

# variable "from_addresses" {
#   description = "List of email addresses to catch bounces and rejections"
#   type        = "list"
# }


# variable "receive_s3_bucket" {
#   description = "Name of the S3 bucket to store received emails."
#   type        = "string"
# }
# variable "receive_s3_prefix" {
#   description = "The key prefix of the S3 bucket to store received emails."
#   type        = "string"
# }
# variable "route53_zone_id" {
#   description = "Route53 host zone ID to enable SES."
#   type        = "string"
# }
# variable "ses_rule_set" {
#   description = "Name of the SES rule set to associate rules with."
#   type        = "string"
# }
