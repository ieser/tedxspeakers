# TEDxSpeakers
# Script ETL a partire dai file csv caricati su S3.

import sys
import json
import pyspark
from pyspark.sql.functions import col, collect_list, array_join

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job



tedx_list_dataset_path = "s3://ieser-tedxspeakers-data/final_list.csv"    # file su S3 con la lista dei video di Tedx
tedx_tags_dataset_path = "s3://ieser-tedxspeakers-data/tags.csv"          # file su S3 con i tag dei video
tedx_details_dataset_path = "s3://ieser-tedxspeakers-data/details.csv"    # file su S3 con i dettagli dei video
tedx_images_dataset_path = "s3://ieser-tedxspeakers-data/images.csv"    # file su S3 con le immagini dei video
tedx_watchnext_dataset_path = "s3://ieser-tedxspeakers-data/related_videos.csv"  # file su S3 con i video correlati

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)


#### READ INPUT FILES TO CREATE AN INPUT DATASET
tedx_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(tedx_list_dataset_path)
    
tedx_dataset.printSchema()

# Conto gli elementi
count_items = tedx_dataset.count()
print(f"Number of items from RAW DATA {count_items}")

# Conto gli elementi con id non nullo
count_items_null = tedx_dataset.filter("id is not null").count()  
print(f"Number of items from RAW DATA with NOT NULL KEY {count_items_null}")

## READ THE DETAILS
details_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(tedx_details_dataset_path)

details_dataset = details_dataset.select(col("id").alias("id_ref"),
                                         col("description"),
                                         col("duration"),
                                         col("publishedAt"))

# AND JOIN WITH THE MAIN TABLE
tedx_dataset_main = tedx_dataset.join(details_dataset, tedx_dataset.id == details_dataset.id_ref, "left") \
    .drop("id_ref")


### VIDEO IMAGES 
# Recupera dal dataset il percorso delle immagini
image_dataset = spark.read \
    .option("header","true") \
    .csv(tedx_images_dataset_path)

image_dataset = image_dataset.select( col("id").alias("id_ref"),  col("url").alias("url_image"))
tedx_dataset_main = tedx_dataset_main.join(image_dataset, tedx_dataset_main.id == image_dataset.id_ref, "left") \
    .drop("id_ref")
    

### ADD TAGS DATASET
tags_dataset = spark.read.option("header","true").csv(tedx_tags_dataset_path)
tags_dataset_agg = tags_dataset.groupBy(col("id").alias("id_ref")).agg(collect_list("tag").alias("tags"))
tags_dataset_agg.printSchema()
tedx_dataset_main = tedx_dataset_main.join(tags_dataset_agg, tedx_dataset_main.id == tags_dataset_agg.id_ref, "left") \
    .drop("id_ref") \
    .select(col("id").alias("_id"), col("*")) \

tedx_dataset_main.printSchema()




### ADD WATCH NEXT
tedx_watchnext_dataset_path = "s3://ieser-mytedx-data/related_videos.csv"  # file su S3 con i video correlati
watchNext_dataset = spark.read.option("header","true").csv(tedx_watchnext_dataset_path)
watchNext_dataset_toJoin = watchNext_dataset.groupBy(col("id").alias("id_ref")).agg(collect_list(struct(watchNext_dataset[1:]).alias("watch_next_videos"))
tedx_dataset_main = tedx_dataset_main.join(watchNext_dataset_toJoin, tedx_dataset_main.id == watchNext_dataset_toJoin.id_ref, "left").drop("id_ref") 



write_mongo_options = {
    "connectionName": "TedXSpeakersDB",
    "database": "tedxspeakers",
    "collection": "tedx_data",
    "ssl": "true",
    "ssl.domain_match": "false"}
from awsglue.dynamicframe import DynamicFrame
tedx_dataset_dynamic_frame = DynamicFrame.fromDF(tedx_dataset_main, glueContext, "nested")

glueContext.write_dynamic_frame.from_options(tedx_dataset_dynamic_frame, connection_type="mongodb", connection_options=write_mongo_options)
