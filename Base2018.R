library(lubridate)
library(rjson)
library(tidyverse)

json <- fromJSON(file = "holidayspred.json")
fechas <- c()

for (i in 1:length(json$table)) {
  fechas[i] <- as.Date(json$table[[i]]$holiday)
}

datos <- data.frame(Fecha = seq(as.Date("2018/01/01"), by = "day", length.out = 181))

datos <- datos %>%
  mutate(Dia = wday(Fecha, label = T), Mes = month(Fecha, label = T),
         Ano = year(Fecha), Semana = week(Fecha),
         Festivo = if_else(Fecha %in% fechas, "Si", "No"))
saveRDS(datos, "datos2018.Rds")
