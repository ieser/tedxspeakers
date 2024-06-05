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

html_content = requests.get(url).content
soupBook = BeautifulSoup(html_content, 'html.parser') #Recupero il contenuto della pagina web
 
chapters = []
for idx, chapter in enumerate(soupBook.find_all('li', class_='toc__chapter'), start=1):
    title = link = content = ""
    
    title = chapter.find('a').get_text(strip=True).split(": ")

    title =  title[1] if len(title) == 2 else "Not found"
    print("titolo" + title)
    link = chapter.find('a')['href']
    print("link" + link)
    
    if(link != ""):
        html_content = requests.get(link).content
        soupCapther = BeautifulSoup(html_content, 'html.parser') #Recupero il contenuto del singolo capitolo
        content = soupCapther.find('div', class_='site-content').get_text(strip=True)
    chapters.append((idx, title, link, content))
    
print(chapters)
transformed_df = spark.createDataFrame(chapters, ["_id", "Title", "Link", "Content"])


write_mongo_options = {
    "connectionName": "TedXSpeakersDB",
    "database": "tedxspeakers",
    "collection": "speakingskills",
    "ssl": "true",
    "ssl.domain_match": "false"}
from awsglue.dynamicframe import DynamicFrame
transformed_df_dynamic_frame = DynamicFrame.fromDF(transformed_df, glueContext, "nested")


glueContext.write_dynamic_frame.from_options(transformed_df_dynamic_frame, connection_type="mongodb", connection_options=write_mongo_options)
