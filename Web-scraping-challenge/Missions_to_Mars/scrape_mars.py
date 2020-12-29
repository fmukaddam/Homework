#Import Dependencies
from bs4 import BeautifulSoup as bs
import pandas as pd
import requests
from selenium import webdriver
import datetime as dt
from splinter import Browser

#Choose and executable path
executable_path = {"executable_path":"/Users/fatimamukaddam/Downloads/chromedriver"}
browser = Browser("chrome", **executable_path, headless=True)

def scrape_all():

    title_news, article_text = mars_news(browser)
    mars_info = {"title_news" : title_news,
        "article_text" : article_text,
        "featured_img_url" : mars_image(browser),
        "mars_facts" : mars_facts(browser),
        "hemisphere_img" : mars_hemisphere(browser)}
    browser.quit()
    return mars_info

# # NASA Mars News
def mars_news(browser):

    # Visit Nasa news url through splinter module
    url = 'https://mars.nasa.gov/news/'
    browser.visit(url)

    html = browser.html
    soup = bs(html, "html.parser")

    content = soup.find("div", class_='content_page')

    #Search for title news
    title_news = content.find_all("div", class_="content_title")
    title_news = title_news[0].text.strip()

    #Search for news paragraph
    article_text = soup.find_all("div", class_='article_teaser_body')
    article_text = article_text[0].text

    return title_news, article_text

# # JPL Mars Space Images - Featured Image
def mars_image(browser):
    #Visit Mars Space Images through splinter module
    url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(url)
    html = browser.html

    soup = bs(html, "html.parser")
    featured_image = soup.find("article", class_='carousel_item')['style']

    # Retrieve background-image url from style tag 
    image_url  = featured_image.split('/spaceimages/')[1].split("'")[0]

    # Website Url 
    main_url = url.split('?')[0]

    # Concatenate website url with scrapped route
    pics_url = main_url + image_url
    pics_url
    browser.find_by_id("full_image").click()

    browser.find_by_text("more info     ").click()

    html = browser.html
    soup = bs(html, 'html.parser')
    featured_img_url = soup.find("img", class_='main_image')['src']
    featured_img_url = f"https://www.jpl.nasa.gov{featured_img_url}"
    featured_img_url


    return featured_img_url

# # Mars Facts
# Visit Mars facts url 
def mars_facts(browser):
    facts_url = 'http://space-facts.com/mars/'

    # Use Panda's `read_html` to parse the url
    mars_facts = pd.read_html(facts_url)

    # Find the mars facts DataFrame
    mars_df = mars_facts[0]

    # Assign the columns
    mars_df.columns = ['Description','Value']

    # Set the index to the `Description` column
    mars_df.set_index('Description', inplace=True)

    mars_table = mars_df.to_html()
    return mars_table

# # Mars Hemispheres
# Visit hemispheres website through splinter module 
def mars_hemisphere(browser):
    hemispheres_url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(hemispheres_url)

    html_hemispheres = browser.html

    # Parse HTML with Beautiful Soup
    soup = bs(html_hemispheres, 'html.parser')

    # Retreive all items that contain mars hemispheres information
    items = soup.find_all('div', class_='item')

    # Create empty list for hemisphere urls 
    hemisphere_image_urls = []

    # Store the main_ul 
    url = 'https://astrogeology.usgs.gov'

    # Loop through the items previously stored
    for i in items: 
        # Store title
        title = i.find('h3').text
        
        # Store link that leads to full image website
        partial_img_url = i.find('a', class_='itemLink product-item')['href']
        
        # Visit the link that contains the full image website 
        browser.visit(url + partial_img_url)
        
        # HTML Object of individual hemisphere information website 
        partial_img_html = browser.html
        
        # Parse HTML with Beautiful Soup for every individual hemisphere information website 
        soup = bs( partial_img_html, 'html.parser')
        
        # Retrieve full image source 
        img_url = url + soup.find('img', class_='wide-image')['src']
        
        # Append the retreived information into a list of dictionaries 
        hemisphere_image_urls.append({"title" : title, "img_url" : img_url})

    return hemisphere_image_urls