from flask import Flask, request, redirect, render_template, session
from flask_session import Session
from App.render import plot

app = Flask(__name__)

SESSION_TYPE = 'filesystem'
app.config.from_object(__name__)
Session(app)

def change_date(date:str, kind:str):

    year, month, day = list(map(int, date.split("-")))
    session['dates'][kind]["year"] = year
    session['dates'][kind]["month"] = month
    session['dates'][kind]["day"] = day

def change_view(view:str, kind:str):

    session['visualization'][kind] = (view == "Semanal")
    if session['currentvis'][kind]["Vis"] != view:
        temp = session['currentvis'][kind]["Vis"]
        session['currentvis'][kind]["Vis"] = view
        session['currentvis'][kind]["Not"] = temp

def correct_date(date: dict):
    return {key: f"{date[key]}" if date[key] > 9 else f"0{date[key]}" for key in date.keys()}

@app.route("/")
def index():
    
    if 'dates' not in session:
        session['dates'] = {
        "train": {"year": 2012, "month": 1, "day":1},
        "test": {"year": 2017, "month": 1, "day":1},
        "preds": {"year": 2018, "month": 1, "day":1}
        }
    
        session['visualization'] = {key:False for key in session['dates'].keys()}
    
        session['currentvis'] = {key:{"Vis": "Mensual", "Not": "Semanal"} for key in session['dates'].keys()}
    
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
    graphJSON=plot(session['dates']["train"]["year"], session['dates']["train"]["month"],
    session['dates']["train"]["day"], "App/predtrain.csv", session['visualization']["train"], 0),
    date=correct_date(session['dates']["train"]), current=session['currentvis']["train"])

@app.route("/modelo/test", methods=["GET", "POST"])
def test():
    
    if request.method == "POST":
        info = request.form["testdate"]
        frequency = request.form["testfreq"]
        change_date(info, "test")
        change_view(frequency, "test")
        return redirect("/modelo/test")

    return render_template("test.html",
    graphJSON=plot(session['dates']["test"]["year"], session['dates']["test"]["month"],
    session['dates']["test"]["day"], "App/predtest.csv", session['visualization']["test"], 1),
    date=correct_date(session['dates']["test"]), current=session['currentvis']["test"])

@app.route("/modelo/preds", methods=["GET", "POST"])
def preds():
    
    if request.method == "POST":
        info = request.form["preddate"]
        frequency = request.form["predfreq"]
        change_date(info, "preds")
        change_view(frequency, "preds")
        return redirect("/modelo/preds")

    return render_template("preds.html",
    graphJSON=plot(session['dates']["preds"]["year"], session['dates']["preds"]["month"],
    session['dates']["preds"]["day"], "App/pred2018.csv", session['visualization']["preds"], 2),
    date=correct_date(session['dates']["preds"]), current=session['currentvis']["preds"])

@app.route("/info/aboutus")
def aboutus():
    return render_template("aboutus.html")

@app.route("/info/tech")
def infotech():
    return render_template("infotech.html")

@app.route("/inform")
def inform():
    return render_template("InformeTecnico.html")
