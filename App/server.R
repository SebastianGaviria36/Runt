source("./Render/rendermodels.R", encoding = "UTF-8")
SERVER <- function(input, output){
    output$trainplot <- plotly::renderPlotly({
        ensayo()
    })

    output$testplot <- plotly::renderPlotly({
        ensayo()
    })
}

