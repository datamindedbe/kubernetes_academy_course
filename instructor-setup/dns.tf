locals {
  subdomain                      = "k8sacademy"
}

resource "aws_route53_zone" "waydata" {
  name = "${local.subdomain}.waydata.be"

  tags = {
    Terraform = "true"
  }
}

resource "aws_route53_record" "root_waydata" {
  name    = "${local.subdomain}.waydata.be"
  type    = "A"
  zone_id = aws_route53_zone.waydata.id
  records = ["127.0.0.1"]
  ttl     = "10"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${local.subdomain}.waydata.be"
  validation_method = "DNS"

  tags = {
    Terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "waydata" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.waydata.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.waydata : record.name]
}