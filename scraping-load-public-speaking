import requests
from bs4 import BeautifulSoup

# URL del libro
base_url = "https://pressbooks.bccampus.ca/speaking/"

# Invia una richiesta alla pagina principale del libro
response = requests.get(base_url)
soup = BeautifulSoup(response.content, 'html.parser')

# Trova il contenitore dei capitoli
chapters_container = soup.find('nav', {'id': 'table-of-contents'})

# Estrai i titoli dei capitoli e i rispettivi link
chapters = []
for chapter in chapters_container.find_all('li', class_='chapter'):
    chapter_title = chapter.find('a').get_text(strip=True)
    chapter_link = chapter.find('a')['href']
    chapters.append((chapter_title, chapter_link))

# Stampa i capitoli
for title, link in chapters:
    print(f"Title: {title}, Link: {link}")
