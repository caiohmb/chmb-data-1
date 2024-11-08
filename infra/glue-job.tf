resource "aws_glue_job" "glue_iceberg_job" {
  name     = "dev-us-east-1-data-1-project-glue-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://dev-us-east-1-data-1-project/app/scripts/glue-etl.py"
    python_version  = "3"
  }

  connections = []
  timeout      = 5
  number_of_workers = 2
  worker_type  = "Standard"

  default_arguments = {
    "--spark.sql.extensions"                             = "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
    "--conf spark.sql.catalog.glue_catalog"              = "org.apache.iceberg.spark.SparkCatalog"
    "--conf spark.sql.catalog.glue_catalog.warehouse"    = "s3://dev-us-east-1-data-1-project/bronze/iceberg/"
    "--conf spark.sql.catalog.glue_catalog.catalog-impl" = "org.apache.iceberg.aws.glue.GlueCatalog"
    "--conf spark.sql.catalog.glue_catalog.io-impl"      = "org.apache.iceberg.aws.s3.S3FileIO"
  }
}
