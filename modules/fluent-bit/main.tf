resource "aws_cloudwatch_log_group" "fluent-bit" {
  name              = "k8sacademy-log-group"
  retention_in_days = 14
}

locals {
  labels = {
    app = "fluent-bit"
  }
  service_account_name = "fluent-bit"
}