resource "aws_glue_crawler" "dev-crawler-data-1" {
  name         = "dev-crawler-data-1"
  role         = aws_iam_role.glue_role.arn
  database_name = "var.glue_database_name"
  description   = "Crawler para buscar arquivos no S3"

  s3_target {
    path = "var.s3_data_path"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}
