import pandas as pd
import json
import plotly
import plotly.express as px

def title_generator(kind_id:int, week:bool = False):
    kinds = ["entrenamiento", "validación", "predicción"]
    return f"Resultados del modelo en el conjunto de {kinds[kind_id]} en vista {'mensual' if not week else 'semanal'}"

def plot(year:int, month:int, day:int, path:str, week:bool = False, kind_id:int = 0):
    df = pd.read_csv(path)
    if week:
        temp = int(df[(df.Ano == year) & (df.Mes == month) & (df.Dia == day) & (df.Clase == ("Predicho" if kind_id == 2 else "Real"))].Semana)
        df = df[(df.Ano == year) & (df.Semana == temp)]
    else:
        df = df[(df.Ano == year) & (df.Mes == month)]

    fig = px.line(df, x="Fecha", y="Valor", color="Clase",
    labels={"Valor":"Cantidad de autos registrados por día"}, line_dash="Clase", hover_name="Clase",
    title=title_generator(kind_id, week))

    graphJSON = json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)

    return graphJSON
