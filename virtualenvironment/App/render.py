import pandas as pd
import json
import plotly
import plotly.express as px

#Genera el titulo segun el periodo de visualizacion y vista semanal o mensual
def title_generator(kind_id:int, week:bool = False):
    
    '''kind es un entero que es 0 para entrenamiento, 1 para validacion y 2 para prediccion.
    week es un booleano que indica si la visualizacion es mensual o semanal.'''

    kinds = ["entrenamiento", "validación", "predicción"]
    return f"Resultados del modelo en el conjunto de {kinds[kind_id]} en vista {'mensual' if not week else 'semanal'}"

#Funcion que retorna un JSON con un plot realizado en plotly 
def plot(year:int, month:int, day:int, path:str, week:bool = False, kind_id:int = 0):

    '''year es el año de visualización, mes el mes de visualización, day el día de la visualización. path hace referencia a la ruta de la
    base de datos desde la cual se genera el gráfico, week es un booleano que indica si la visualizacion es mensual o semanal y kind_id 
    es un entero que se pasa a la función title_generator para generar el título del plot.
    '''
    df = pd.read_csv(path) #lectura del los datos
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
