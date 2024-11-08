from pyspark.sql import SparkSession

# Criação da Spark session com as configurações do Glue Catalog e Iceberg
spark = SparkSession.builder \
    .appName("Glue Job with Iceberg") \
    .config("spark.sql.catalog.glue_catalog", "org.apache.iceberg.spark.SparkCatalog") \
    .config("spark.sql.catalog.glue_catalog.warehouse", "s3://dev-us-east-1-data-1-project/bronze/iceberg/") \
    .config("spark.sql.catalog.glue_catalog.catalog-impl", "org.apache.iceberg.aws.glue.GlueCatalog") \
    .config("spark.sql.catalog.glue_catalog.io-impl", "org.apache.iceberg.aws.s3.S3FileIO") \
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions") \
    .getOrCreate()

dataFrame = spark.sql("SELECT * FROM glue_catalog.var.glue_database_name.data")

# Registrar o DataFrame como uma tabela temporária
dataFrame.createOrReplaceTempView("tmp_table")

# Criar e registrar a tabela Iceberg no Glue Catalog
query = """
CREATE TABLE glue_catalog.var.glue_database_name.data
USING iceberg
TBLPROPERTIES ("format-version"="2")
AS SELECT * FROM tmp_table
"""
spark.sql(query)

spark.stop()
