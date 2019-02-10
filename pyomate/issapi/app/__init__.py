from flask import Flask
import requests
import datetime


parameters = {"n": 6}
app = Flask(__name__)

from app import routes

@app.route("/")
def home():
    
    return "Hello World!"


if __name__ == "__main__":
    app.run(debug=True)