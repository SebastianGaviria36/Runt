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
# 
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

################################################################################
#EDAED
#Dia importa (a nivel global)
datos <- readRDS("datos.Rds")
p1 <- ggplot(datos, aes(Dia, Unidades, fill = Dia)) +
  geom_col(position = position_stack()) +
  labs(x = "Día de la semana",
       y = "Frecuencia [unidades de 100000]") +
  theme_bw() +
  scale_y_continuous(breaks = seq(0, 3e+05, 1e+05), labels = seq(0, 3, 1))

p2 <- ggplot(datos, aes(Dia, Unidades, fill = Dia)) +
  geom_col() +
  facet_wrap(~Ano) +
  theme_bw() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

#Semana
p3 <- ggplot(datos, aes(Semana, Unidades, color = factor(Ano))) +
  geom_col(position = position_dodge2())

#Matriz de correlaciones (variables numericas)
vars_corr <- cor(datos[, c("Unidades", "PIBanual", "PIBpersona", "TRM",
                           "Salariomin", "IPC", "Inflacion_mensual")])
p4 <- ggcorrplot::ggcorrplot(vars_corr, method = "circle", 
                             ggtheme = theme_bw(),
                             lab = T, lab_size = 4,
                             colors = c("red", "white", "blue"))

#Diagramas de dispersión de la respuesta vs covariables
s1 <- ggplot(datos, aes(PIBanual, Unidades)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = lm) +
  labs(x = "PIB Anual") +
  theme_bw() 

s2 <- ggplot(datos, aes(PIBpersona, Unidades)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = lm) +
  labs(x = "PIB Persona")+
  theme_bw() 

s3 <- ggplot(datos, aes(TRM, Unidades)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = lm) +
  theme_bw() 

s4 <- ggplot(datos, aes(Salariomin, Unidades)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = lm) +
  labs(x = "Salario mínimo") +
  theme_bw() 

s5 <- ggplot(datos, aes(IPC, Unidades)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = lm) +
  theme_bw() 

s6 <- ggplot(datos, aes(Inflacion_mensual, Unidades)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = lm) +
  labs(x = "Inflación mensual")+
  theme_bw() 
