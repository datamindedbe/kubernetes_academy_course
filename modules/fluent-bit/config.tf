resource "kubernetes_config_map" "fluent-bit" {
  metadata {
    name      = "fluent-bit"
    namespace = var.namespace
  }
  data = {
    "fluent-bit-filter.conf"  = <<EOF
[FILTER]
    Name                parser
    Key_Name            log
    Match               kube.*
    Parser              containerd
    Parser              docker
EOF
    "fluent-bit-input.conf"   = <<EOF
[INPUT]
    Name              tail
    Path              /var/log/containers/*.log
    Tag               kube.*
    Refresh_Interval  5
    Mem_Buf_Limit     10MB
    Skip_Long_Lines   On
EOF
    "fluent-bit-output.conf"  = <<EOF
[OUTPUT]
    Name              cloudwatch_logs
    Match             *
    region            ${data.aws_region.current.name}
    log_group_name    ${aws_cloudwatch_log_group.fluent-bit.name}
    log_stream_prefix from-fluent-bit-
    auto_create_group false
EOF
    "fluent-bit-service.conf" = <<EOF
[SERVICE]
    Flush        1
    Daemon       Off
    Log_Level    warn
    Parsers_File parsers.conf
EOF
    "fluent-bit.conf"         = <<EOF
@INCLUDE fluent-bit-service.conf
@INCLUDE fluent-bit-input.conf
@INCLUDE fluent-bit-filter.conf
@INCLUDE fluent-bit-output.conf
EOF
    "parsers.conf"            = <<EOF
[PARSER]
    Name        containerd
    Format      regex
    Regex       ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>[^ ]*) (?<log>.*)$
    Time_Key    time
    Time_Format %Y-%m-%dT%H:%M:%S.%L%z
    Time_Keep   On

[PARSER]
    Name         docker
    Format       json
    Time_Key     time
    Time_Format  %Y-%m-%dT%H:%M:%S.%L
    Time_Keep    On
EOF

  }
}
