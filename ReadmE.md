# <b> App </b>

Desarrollo de la app que permite la visualización de las predicciones del modelo comparadas con las reales y la visualización de los pronósticos.

## <b>Instrucciones</b>
 
Para ejecutar la appliación es necesario tener las siguientes dependencias:
<ul>
<li> <a src="https://flask.palletsprojects.com/en/2.0.x/">Flask</a> 
<li> <a src="https://plotly.com/">plotly</a>
<li> <a src="https://pandas.pydata.org/">pandas</a>
<li> <a src="https://numpy.org/">numpy</a>
<li> <a src="https://flask-session.readthedocs.io/en/latest/">flask-session</a>
</ul>

En cada enlace se encuentran instrucciones de instalación de los
respectivos paquetes, los cuales pueden ser instalados dentro de pip.

## <b> Directorios relevantes</b>

<ul>
<li> <a src="https://github.com/SebastianGaviria36/Runt/tree/App/virtualenvironment">virtualenviroment</a>: carpeta con todo el proyecto de la app.
<ul> 
<li> <b>wsgi.py</b>: archivo donde se ejecuta la app hecha en flask.    
</ul>
<li> <a src="https://github.com/SebastianGaviria36/Runt/tree/App/virtualenvironment/App">App</a>: carpeta con los ejecutables
de la app. 
<ul> 
<li> <b>app.py</b>: archivo donde se encuentra la app hecha en flask.  
<li> <b>render.py</b>: archivo donde se encuentra la función para generar los gráficos.  
</ul>
<li> <a src="https://github.com/SebastianGaviria36/Runt/tree/App/virtualenvironment/App/templates">templates</a>: carpeta donde
se encuentran los archivos html de la página, escritos con <a src="https://jinja2docs.readthedocs.io/en/stable/">Jinja2</a>
</ul>

Para añadir prediciones es necesario una base de datos estructurada
de la siguiente manera en el caso de entrenamiento y validación.

|    Fecha   |  Valor |   Clase  |   Dia  | Semana |   Mes  |   Ano  | DiaString |
|:----------:|:------:|:--------:|:------:|:------:|:------:|:------:|:---------:|
| 2012-01-01 |    0   |   Real   |    1   |    1   |    1   |  2017  |  Domingo  |
|   $\vdots$   | $\vdots$ |  $\vdots$  | $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ |   $\vdots$  |
| 2016-12-31 |   527  | Predicho |   31   |   53   |   12   |  2016  |   Sábado  |

Para añadir prediciones es necesario una base de datos estructurada
de la siguiente manera en el caso de los pronósticos a futuro del modelo.
|    Fecha   |  Valor |   Clase  |   Dia  | Semana |   Mes  |   Ano  | DiaString |
|:----------:|:------:|:--------:|:------:|:------:|:------:|:------:|:---------:|
| 2018-01-01 |    0   |   Real   |    1   |    1   |    1   |  2018  |  Lunes  |
|   $\vdots$   | $\vdots$ |  $\vdots$  | $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ |   $\vdots$  |


<b>Nota</b>: para el argumento paths en la función plot se recomienda usar la librería os de 
python para no tener problemas con las direcciones de los archivos en caso de estar usando 
un sistema operativo diferente a Linux o a alguno Unix-Like.