library(tidyverse)
model_comparison <- function(df, year, week) {
    df <- df %>%
        filter(Ano == year, Semana == week)
    p <- ggplot(df, aes(Fecha, Unidades, color = Clase)) +
        geom_point() +
        geom_path()
    plotly::ggplotly(p)
}

ensayo <- function() {
    p <- diamonds %>%
        filter(cut %in% c("Ideal", "Premium")) %>%
        ggplot(aes(x, y, color = cut)) +
        geom_point() +
        geom_path() +
        theme_minimal()
    plotly::ggplotly(p)
}