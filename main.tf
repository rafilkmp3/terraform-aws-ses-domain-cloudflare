#
# SES Domain Verification
#

resource "aws_ses_domain_identity" "main" {
  domain = var.domain_name
}

resource "aws_ses_domain_identity_verification" "main" {
  count = var.enable_verification ? 1 : 0

  domain = aws_ses_domain_identity.main.id

  depends_on = [cloudflare_record.ses_verification]
}

resource "cloudflare_record" "ses_verification" {
  domain = var.domain_name
  name   = "_amazonses.${aws_ses_domain_identity.main.id}"
  type   = "TXT"
  value  = aws_ses_domain_identity.main.verification_token
}

#
# SES DKIM Verification
#

resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

resource "cloudflare_record" "dkim" {
  count  = 3
  domain = var.domain_name
  name = format(
    "%s._domainkey.%s",
    element(aws_ses_domain_dkim.main.dkim_tokens, count.index),
    var.domain_name,
  )
  type  = "CNAME"
  value = "${element(aws_ses_domain_dkim.main.dkim_tokens, count.index)}.dkim.amazonses.com"
}


resource "cloudflare_record" "spf_domain" {
  count  = var.enable_spf_domain ? 1 : 0
  domain = var.domain_name
  name   = "@"
  type   = "TXT"
  value  = "v=spf1 include:amazonses.com -all"
}

# Sending MX Record
data "aws_region" "current" {
}



# Receiving MX Record
resource "cloudflare_record" "mx_receive" {
  count  = var.enable_mx_receive ? 1 : 0
  domain = var.domain_name
  name   = "@"
  type   = "MX"
  value  = "10 inbound-smtp.${data.aws_region.current.name}.amazonaws.com"
}

#
# DMARC TXT Record
#
resource "cloudflare_record" "txt_dmarc" {
  count  = var.enable_txt_dmarc ? 1 : 0
  domain = var.domain_name
  name   = "_dmarc"
  type   = "TXT"
  value  = "v=DMARC1; p=none; rua=mailto:postmaster@${var.domain_name}; ruf=mailto:postmaster@${var.domain_name}; fo=1;"
}

# #
# # SES Receipt Rule
# #
# resource "aws_ses_receipt_rule" "main" {
#   name          = "${format("%s-s3-rule", local.dash_domain)}"
#   rule_set_name = "${var.ses_rule_set}"
#   recipients    = "${var.from_addresses}"
#   enabled       = true
#   scan_enabled  = true
#   s3_action {
#     position = 1
#     bucket_name       = "${var.receive_s3_bucket}"
#     object_key_prefix = "${var.receive_s3_prefix}"
#   }
# }
# resource "cloudflare_record" "mx_send_mail_from" {
#   domain = "${var.domain_name}"
#   name   = "${aws_ses_domain_mail_from.main.mail_from_domain}"
#   type   = "MX"
#   value  = "10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"
# }

# #
# # SES MAIL FROM Domain
# #

# resource "aws_ses_domain_mail_from" "main" {
#   domain           = "${aws_ses_domain_identity.main.domain}"
#   mail_from_domain = "${var.domain_name}"
# }

# # SPF validaton record
# resource "cloudflare_record" "spf_mail_from" {
#   domain = "${var.domain_name}"
#   name   = "${aws_ses_domain_mail_from.main.mail_from_domain}"
#   type   = "TXT"
#   value  = "v=spf1 include:amazonses.com -all"
# }
