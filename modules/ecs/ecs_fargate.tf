# ECS Cluster, Service, TaskDefinition
resource "aws_ecs_cluster" "name" {
    # 255文字以下
    name = "ecs-cluster-${var.envname}-${var.systemid}"

    configuration {
        # ECS Exec機能を設定するブロック
      execute_command_configuration {
        # ログ設定
        log_configuration {
          cloud_watch_encryption_enabled = true
          cloud_watch_log_group_name = "${var.log-group-ecs-cluster.name}"
        }
      }
    }
}