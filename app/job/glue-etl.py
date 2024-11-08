from pyspark.sql import SparkSession

# Criação da Spark session
spark = SparkSession.builder \
    .appName("Glue Job with Iceberg") \
    .getOrCreate()

# Consultando os dados do Glue Catalog
dataFrame = spark.sql("SELECT * FROM glue_catalog.dev-database-data-1-project.data")

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
