from flask import Flask, request, redirect, render_template, session #Importando modulos de flask
from flask_session import Session #Libreria para el manejo de variables por sesion
from App.render import plot #Importando la funcion para generar los graficos

app = Flask(__name__) #Inicializando aplicacion

#Configurando la app para tipo de sesion filesystem
SESSION_TYPE = 'filesystem'
app.config.from_object(__name__)
Session(app)

#Funcion que formatea la fecha correctamente luego de recibirla por el metodo POST de las visualizaciones de los datos
def change_date(date:str, kind:str):

    year, month, day = list(map(int, date.split("-")))
    session['dates'][kind]["year"] = year
    session['dates'][kind]["month"] = month
    session['dates'][kind]["day"] = day

#Funcion que actualiza el tipo de visualizacion luego de el metodo POST 
def change_view(view:str, kind:str):

    session['visualization'][kind] = (view == "Semanal")
    if session['currentvis'][kind]["Vis"] != view:
        temp = session['currentvis'][kind]["Vis"]
        session['currentvis'][kind]["Vis"] = view
        session['currentvis'][kind]["Not"] = temp

#Funcion que corrige las fechas segun el formato solicitado en HTML para el tipo de entrada calendario
def correct_date(date: dict):
    return {key: f"{date[key]}" if date[key] > 9 else f"0{date[key]}" for key in date.keys()}

#Pagina inicial
@app.route("/")
def index():
    #Creando las variables de sesion para el usuario
    if 'dates' not in session:
        session['dates'] = {
        "train": {"year": 2012, "month": 1, "day":1},
        "test": {"year": 2017, "month": 1, "day":1},
        "preds": {"year": 2018, "month": 1, "day":1}
        }
    
        session['visualization'] = {key:False for key in session['dates'].keys()}
    
        session['currentvis'] = {key:{"Vis": "Mensual", "Not": "Semanal"} for key in session['dates'].keys()}
    
    return render_template("index.html")

#Visualizacion del modelo en el periodo de entrenamiento
@app.route("/modelo/train", methods=["GET", "POST"])
def train():
    #Actualizacion de la informacion de la pagina en caso tal de que el metodo sea POST

    if request.method == "POST":
        info = request.form["traindate"]
        frequency = request.form["trainfreq"]
        change_date(info, "train")
        change_view(frequency, "train")
        return redirect("/modelo/train")
        
    
    #Si el metodo es GET se genera el grafico con la funcion plot del archivo render
    return render_template("train.html",
    graphJSON=plot(session['dates']["train"]["year"], session['dates']["train"]["month"],
    session['dates']["train"]["day"], "App/predtrain.csv", session['visualization']["train"], 0),
    date=correct_date(session['dates']["train"]), current=session['currentvis']["train"])

@app.route("/modelo/test", methods=["GET", "POST"])
def test():
    #Actualizacion de la informacion de la pagina en caso tal de que el metodo sea POST

    if request.method == "POST":
        info = request.form["testdate"]
        frequency = request.form["testfreq"]
        change_date(info, "test")
        change_view(frequency, "test")
        return redirect("/modelo/test")


    #Si el metodo es GET se genera el grafico con la funcion plot del archivo render
    return render_template("test.html",
    graphJSON=plot(session['dates']["test"]["year"], session['dates']["test"]["month"],
    session['dates']["test"]["day"], "App/predtest.csv", session['visualization']["test"], 1),
    date=correct_date(session['dates']["test"]), current=session['currentvis']["test"])

@app.route("/modelo/preds", methods=["GET", "POST"])
def preds():
    
    #Actualizacion de la informacion de la pagina en caso tal de que el metodo sea POST
    if request.method == "POST":
        info = request.form["preddate"]
        frequency = request.form["predfreq"]
        change_date(info, "preds")
        change_view(frequency, "preds")
        return redirect("/modelo/preds")

    #Si el metodo es GET se genera el grafico con la funcion plot del archivo render
    return render_template("preds.html",
    graphJSON=plot(session['dates']["preds"]["year"], session['dates']["preds"]["month"],
    session['dates']["preds"]["day"], "App/pred2018.csv", session['visualization']["preds"], 2),
    date=correct_date(session['dates']["preds"]), current=session['currentvis']["preds"])

#Informacion del equipo de trabajo
@app.route("/info/aboutus")
def aboutus():
    return render_template("aboutus.html")

#Informe acerca de detalles tecnicos
@app.route("/info/tech")
def infotech():
    return render_template("infotech.html")

#Informe tecnico
@app.route("/inform")
def inform():
    return render_template("InformeTecnico.html")
