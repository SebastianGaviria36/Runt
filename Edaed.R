library(tidyverse)
library(lubridate)
library(magrittr)
library(rjson)

datos <- readxl::read_xlsx("registros_autos_entrenamiento.xlsx")

json <- fromJSON(file = "holidays.json")
fechas <- c()

for (i in 1:length(json$table)) {
  fechas[i] <-
    format(as.Date(json$table[[i]]$holiday), "%Y-%m-%d")
}
fechas <- as.Date(fechas)

datos %<>%
  mutate(
    Fecha = as.Date(Fecha),
    Dia = wday(Fecha, label = T),
    Mes = month(Fecha, label = T),
    Ano = year(Fecha),
    Semana = week(Fecha),
    Festivo = factor(if_else(Fecha %in% fechas, "Si", "No"))
  )

datosPIB <- readxl::read_xlsx("DatosPIB.xlsx")

datos <- inner_join(datos, datosPIB, by = "Ano")

#Dia importa (a nivel global)
ggplot(datos, aes(Dia, Unidades, fill = Dia)) +
  geom_col(position = position_stack()) +
  labs(x = "Día de la semana",
       y = "Frecuencia [unidades de 100000]") +
  theme_bw() +
  scale_y_continuous(breaks = seq(0, 3e+05, 1e+05), labels = seq(0, 3, 1)) +
  coord_flip()

ggplot(datos, aes(Dia, Unidades, fill = Dia)) +
  geom_col() +
  facet_wrap(~Ano) +
  theme_bw() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

#Semana
ggplot(datos, aes(Semana, Unidades, color = factor(Ano))) +
  geom_col(position = position_dodge2())

saveRDS(datos, "datos.Rds")
