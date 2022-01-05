library(shiny)

Ui <- fluidPage(
    titlePanel("Titulo provisional"),
    sidebarLayout(
        sidebarPanel(
            selectInput(
                "visinput",
                "Elija el contenido que desea ver",
                c(
                    "Introducción",
                    "Comparación 2012 - 2016",
                    "Predicciones primer semestre del 2018",
                    "Sobre los autores"
                )
            ),
            conditionalPanel(
                condition = "input.visinput == 'Comparación 2012 - 2016'",
                dateInput(
                    "datetrain",
                    "Seleccione la fecha para la visualización semanal",
                    value = "2012-01-01",
                    min  = "2012-01-01",
                    max  = "2016-12-31",
                    format = "dd-mm-yyyy",
                    language = "es"
                )
            ),
            conditionalPanel(
                condition = "input.visinput == 'Predicciones primer semestre del 2018'",
                dateInput(
                    "datetest",
                    "Seleccione la fecha para la visualización semanal",
                    value = "2018-01-01",
                    min  = "2018-01-01",
                    max  = "2018-06-31",
                    format = "dd-mm-yyyy",
                    language = "es"
                )
            )
        ),
        mainPanel(
            conditionalPanel(
               condition = "input.visinput == 'Introducción'",
               includeHTML("./www/intro.html")
           ),
           conditionalPanel(
               condition = "input.visinput == 'Comparación 2012 - 2016'",
               plotly::plotlyOutput("trainplot")
           ),
           conditionalPanel(
               condition = "input.visinput == 'Predicciones primer semestre del 2018'",
               plotly::plotlyOutput("testplot")
           ),
           conditionalPanel(
               condition = "input.visinput == 'Sobre los autores'",
              includeHTML("./www/aboutus.html")
           )
        )
    )
)