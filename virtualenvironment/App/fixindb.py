#Script para arreglar las bases de datos (no necesario)
import pandas as pd
from dateutil.parser import parse
import numpy as np

days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]

def fixed(df, path):
    df.Dia = df.Fecha.apply(lambda x: int(x.split("-")[-1]))
    df.Fecha = df.Fecha.apply(lambda x: parse(x))
    df.Clase = df.Clase.apply(lambda x: x.capitalize())
    df["DiaString"] = df.Fecha.apply(lambda x: days[x.weekday()])
    df.Valor = np.round(df.Valor)
    df.to_csv(path, index=False)
    return 

# paths = ["predtest.csv", "predtrain.csv"]

# for path in paths:
    # df = pd.read_csv(path)
    # fixed(df, path)

df = pd.read_csv("pred2018.csv")
fixed(df, "pred2018.csv")