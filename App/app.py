from datetime import date
from types import MethodDescriptorType
from flask import Flask, request, redirect, render_template, Markup
from pandas.core.indexes import period
from render import plot

app = Flask(__name__)

dates = {
    "train": {"year": 2012, "month": 1, "day":1},
    "test": {"year": 2017, "month": 1, "day":1},
    "preds": {"year": 2017, "month": 1, "day":1},
}

visualization = {key:False for key in dates.keys()}

currentvis = {key:{"Vis": "Mensual", "Not": "Semanal"} for key in dates.keys()}

def change_date(date:str, kind:str):
    
    global dates
    
    year, month, day = list(map(int, date.split("-")))
    dates[kind]["year"] = year
    dates[kind]["month"] = month
    dates[kind]["day"] = day

def change_view(view:str, kind:str):
    
    global visualization, currentvis

    visualization[kind] = (view == "Semanal")
    if currentvis[kind]["Vis"] != view:
        temp = currentvis[kind]["Vis"]
        currentvis[kind]["Vis"] = view
        currentvis[kind]["Not"] = temp

def correct_date(date: dict):
    return {key: f"{date[key]}" if date[key] > 9 else f"0{date[key]}" for key in date.keys()}

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/modelo/train", methods=["GET", "POST"])
def train():
    
    if request.method == "POST":
        info = request.form["traindate"]
        frequency = request.form["trainfreq"]
        change_date(info, "train")
        change_view(frequency, "train")
        return redirect("/modelo/train")
        
    return render_template("train.html",
    graphJSON=plot(dates["train"]["year"], dates["train"]["month"],
    dates["train"]["day"], "predtrain.csv", visualization["train"], 0),
    date=correct_date(dates["train"]), current=currentvis["train"])

@app.route("/modelo/test", methods=["GET", "POST"])
def test():
    
    if request.method == "POST":
        info = request.form["testdate"]
        frequency = request.form["testfreq"]
        change_date(info, "test")
        change_view(frequency, "test")
        return redirect("/modelo/test")

    return render_template("test.html",
    graphJSON=plot(dates["test"]["year"], dates["test"]["month"],
    dates["test"]["day"], "predtest.csv", visualization["test"], 1),
    date=correct_date(dates["test"]), current=currentvis["test"])

@app.route("/modelo/preds", methods=["GET", "POST"])
def preds():
    
    if request.method == "POST":
        info = request.form["preddate"]
        frequency = request.form["predfreq"]
        change_date(info, "preds")
        change_view(frequency, "preds")
        return redirect("/modelo/preds")

    return render_template("preds.html",
    graphJSON=plot(dates["preds"]["year"], dates["preds"]["month"],
    dates["preds"]["day"], "predtest.csv", visualization["preds"], 2),
    date=correct_date(dates["preds"]), current=currentvis["preds"])

@app.route("/info/aboutus")
def aboutus():
    return render_template("aboutus.html")

@app.route("/info/tech")
def tech():
    return render_template("_site/InformeTecnico.html")

if __name__ == "__main__":
    app.run(debug=True)