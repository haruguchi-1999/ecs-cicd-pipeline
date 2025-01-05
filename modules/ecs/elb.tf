resource "aws_lb" "alb-fargate-api" {
  name               = "alb-${var.envname}-${var.systemid}-fargate-api"
  internal           = false
  // ロードバランサータイプ
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  // 内部でプライベート通信の場合は true
  enable_deletion_protection = true

  access_logs {
    // ログを保存するS3
    bucket  = aws_s3_bucket.lb_logs.id
    // S3バケットのプレフィックス
    prefix  = "/aws/alb/fargate-api/"
    // ログを有効化
    enabled = true
  }

  tags = {
    Name = "alb-${var.envname}-${var.systemid}-fargate-api"
    Module_Name = var.module_name
    Application = var.systemid
  }
}