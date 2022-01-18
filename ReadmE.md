# <b> App </b>

Desarrollo de la app que permite la visualización de las predicciones del modelo comparadas con las reales y la visualización de los pronósticos.

## <b>Instrucciones</b>
 
Para ejecutar la apliación es necesario tener las siguientes dependencias:

- [Flask](https://flask.palletsprojects.com/en/2.0.x/)
-  [plotly](https://plotly.com/)
-  [pandas](https://pandas.pydata.org/)
-  [numpy](https://numpy.org/)
- [flask-session](https://flask-session.readthedocs.io/en/latest/)
- [gunicorn](https://gunicorn.org/)

En cada enlace se encuentran instrucciones de instalación de los
respectivos paquetes, los cuales pueden ser instalados dentro de pip.

## <b> Directorios relevantes</b>


- [virtualenviroment](https://github.com/SebastianGaviria36/Runt/tree/App/virtualenvironment): carpeta con todo el proyecto de la app.
    - <b>wsgi.py</b>: archivo donde se ejecuta la app hecha en flask.    

- [App](https://github.com/SebastianGaviria36/Runt/tree/App/virtualenvironment/App): carpeta con los ejecutables
de la app. 
 
    - <b>app.py</b>: archivo donde se encuentra la app hecha en flask.  
    - <b>render.py</b>: archivo donde se encuentra la función para generar los gráficos.  

- [templates](https://github.com/SebastianGaviria36/Runt/tree/App/virtualenvironment/App/templates): carpeta donde
se encuentran los archivos html de la página, escritos con [Jinja2](https://jinja2docs.readthedocs.io/en/stable/).

Para añadir prediciones es necesario una base de datos estructurada
de la siguiente manera en el caso de entrenamiento y validación.

|    Fecha   |  Valor |   Clase  |   Dia  | Semana |   Mes  |   Ano  | DiaString |
|:----------:|:------:|:--------:|:------:|:------:|:------:|:------:|:---------:|
| 2012-01-01 |    0   |   Real   |    1   |    1   |    1   |  2017  |  Domingo  |
|   .   | . |  .  | . | . | . | . |   .  |
| 2016-12-31 |   527  | Predicho |   31   |   53   |   12   |  2016  |   Sábado  |

Para añadir prediciones es necesario una base de datos estructurada
de la siguiente manera en el caso de los pronósticos a futuro del modelo.
|    Fecha   |  Valor |   Clase  |   Dia  | Semana |   Mes  |   Ano  | DiaString |
|:----------:|:------:|:--------:|:------:|:------:|:------:|:------:|:---------:|
| 2018-01-01 |    0   |   Real   |    1   |    1   |    1   |  2018  |  Lunes  |
|   .   | . |  .  | . | . | . | . |   .  |


<b>Nota</b>: para el argumento paths en la función plot se recomienda usar la librería os de 
python para no tener problemas con las direcciones de los archivos en caso de estar usando 
un sistema operativo diferente a Linux o a alguno Unix-Like.