# library(tidyverse)
# library(lubridate)
# library(magrittr)
# library(rjson)
# 
# datos <- readxl::read_xlsx("registros_autos_entrenamiento.xlsx")
# 
# json <- fromJSON(file = "holidays.json")
# fechas <- c()
# 
# for (i in 1:length(json$table)) {
#   fechas[i] <-
#     format(as.Date(json$table[[i]]$holiday), "%Y-%m-%d")
# }
# fechas <- as.Date(fechas)
# 
# datos %<>%
#   mutate(
#     Fecha = as.Date(Fecha),
#     Dia = wday(Fecha, label = T),
#     Mes = month(Fecha, label = T),
#     Ano = year(Fecha),
#     Semana = week(Fecha),
#     Festivo = factor(if_else(Fecha %in% fechas, "Si", "No"))
#   )
# 
# datosPIB <- readxl::read_xlsx("DatosPIB.xlsx")
# 
# datos <- inner_join(datos, datosPIB, by = "Ano")
# 
# #Agregando TRM del dolar
# 
# dolar <- readxl::read_xlsx("1.1.1.TCM_Serie_historica_IQY.xlsx",
#                            range = "A8:B11004") %>% 
#   mutate(Fecha = as.Date(Fecha)) %>% 
#   filter(between(year(Fecha), 2012, 2017))
# 
# datos <- inner_join(datos, dolar, by = "Fecha")
# 
# #Agregando salario minimo
# datos <- readRDS("datos.Rds")
# minimo <- readxl::read_xlsx("1.1.1.SLR_Serie_historica_IQY.xlsx")
# 
# datos <- inner_join(datos, minimo, by = "Ano")
# 
# #Agregando IPC e inflacion mensual
# ipc <- readxl::read_xlsx("1.2.5.IPC_Serie_variaciones.xlsx", 
#                  range = "A13:E822") %>% 
#   mutate(Ano = as.character(Ano),
#          Mes = as.numeric(substr(Ano, 5, 6)),
#          Ano = as.numeric(substr(Ano, 1, 4))) %>% 
#   select(Ano, Mes, IPC, Inflacion_mensual) %>% 
#   filter(between(Ano, 2012, 2017))
# 
# #NOTAS: Inflación mensual melita, el resto es pure trash
# meses <- unique(datos$Mes)
# ipc$Mes <- meses[ipc$Mes]
# datos <- inner_join(datos, ipc, by = c("Ano" = "Ano", "Mes" = "Mes"))
# saveRDS(datos, "datos.Rds")

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

#TRM vs Unidades
ggplot(datos, aes(y = Unidades, x = TRM)) +
  geom_point() +
  theme_bw()

saveRDS(datos, "datos.Rds")
