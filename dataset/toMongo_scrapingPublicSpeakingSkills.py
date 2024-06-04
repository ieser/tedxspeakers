from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from pyspark.sql import SparkSession
from bs4 import BeautifulSoup
import requests

# Inizializzazione dei contesti di Spark e Glue
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# URL del sito web da cui recuperare i dati
url = "https://pressbooks.bccampus.ca/speaking/"

# Leggi i dati HTML dal sito web
html_content = requests.get(url).content

# Parsing del contenuto HTML con BeautifulSoup
soup = BeautifulSoup(html_content, 'html.parser')

# Estrarre i titoli, i link e il contenuto dei capitoli
chapters = []
for idx, chapter in enumerate(soup.find_all('div', class_='book-chapter'), start=1):
    title = chapter.find('h3', class_='toc-level-1').find('a').get_text(strip=True)
    link = chapter.find('h3', class_='toc-level-1').find('a')['href']
    content = '\n'.join(chapter.find('div', class_='chapter-content').stripped_strings)
    chapters.append((idx, title, link, content))

# Converte i dati estratti in un DataFrame Glue
transformed_df = spark.createDataFrame(chapters, ["Chapter Number", "Title", "Link", "Content"])


write_mongo_options = {
    "connectionName": "TedXSpeakersDB",
    "database": "tedxspeakers",
    "collection": "speakingskills",
    "ssl": "true",
    "ssl.domain_match": "false"}
from awsglue.dynamicframe import DynamicFrame
transformed_df_dynamic_frame = DynamicFrame.fromDF(transformed_df, glueContext, "nested")


glueContext.write_dynamic_frame.from_options(transformed_df_dynamic_frame, connection_type="mongodb", connection_options=write_mongo_options)
