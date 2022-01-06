from flask import Flask, request, redirect, render_template, Markup
import pandas as pd
import json
import plotly
import plotly.express as px

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/modelo/train", methods=["GET", "POST"])
def train():
    return render_template("index.html")

@app.route("/modelo/test", methods=["GET", "POST"])
def test():
    return render_template("index.html")

@app.route("/modelo/preds", methods=["GET", "POST"])
def preds():
    return render_template("preds.html")

@app.route("/info/aboutus")
def aboutus():
    return render_template("aboutus.html")

@app.route("/info/tech")
def tech():
    return render_template("aboutus.html")

if __name__ == "__main__":
    app.run(debug=True)