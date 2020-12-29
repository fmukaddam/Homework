from flask import Flask, render_template, redirect 
from flask_pymongo import PyMongo
import pymongo
import scrape_mars

app = Flask(__name__)

app.config["MONGO_URI"] = "mongodb://localhost:27017/Mars_DB"
mongo = PyMongo(app)

#client = pymongo.MongoClient('mongodb://localhost:27017')
#db = client.Mars_DB
collection = mongo.db["mars_data"]

# Create route that renders index.html template and finds documents from mongo
@app.route("/")
def index(): 

    # Find data
    mars_info = mongo.db.collection.find_one(sort=[("_id" , pymongo.DESCENDING)])
    return render_template("index.html", mars_info= mars_info)

# Route that will trigger scrape function
@app.route("/scrape")
def scrape():
    scraped_data = scrape_mars.scrape_all()
    #print(scraped_data)
    mongo.db.collection.insert_one(scraped_data)
    return redirect('/', code=302)

if __name__ == "__main__": 
    app.run(debug= True)
