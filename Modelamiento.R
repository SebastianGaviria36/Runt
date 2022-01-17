datos <- readRDS("datos.Rds")
library(tidyverse)

#TRAIN Y TEST
train <- subset(datos, subset = 2012 <= datos$Ano & datos$Ano <= 2016 )[,-1]
test <- subset(datos, subset = datos$Ano == 2017)[,-1] 

#Rsquared function
eval_results <- function(true, predicted) {
  SSE <- sum((predicted - true)^2)
  SST <- sum((true - mean(true))^2)
  R_square <- 1 - SSE / SST
  R_square
}

#Todas las covariables (no apto)
modall <- lm(Unidades ~ ., data = train)
#R squared (train)
eval_results(train$Unidades, predict(modall))
#R squared (test)
eval_results(test$Unidades, predict(modall, newdata = test))

#Solo variables categoricas 
modcat <- lm(paste("Unidades", paste(names(train)[2:6], collapse = " + "), sep = " ~ "),
             data = train)
#R squared (train)
eval_results(train$Unidades, predict(modcat))
#R squared (test)
eval_results(test$Unidades, predict(modcat, newdata = test))

#Anadiendo covariables numericas
datos_num <- data.frame(Formula = "", R2_train = 0, R2_test = 0, dif = 0)
for (i in 7:12) {
  formula_temp <- paste("Unidades", paste(names(train)[c(2:6, i)], collapse = " + "), sep = " ~ ") 
  modtemp <- lm(formula_temp,
                data = train)
  datos_num[i-6,1] <- formula_temp
  datos_num[i-6,2] <- eval_results(train$Unidades, predict(modtemp))
  datos_num[i-6,3] <- eval_results(test$Unidades, predict(modtemp, newdata = test))
  datos_num[i-6,4] <- datos_num[i-6,2] - datos_num[i-6,3] 
}

#Intentando regression poisson (no apto)
modallpois <- glm(Unidades ~ ., family = poisson(link = "log"), data = train)
#R squared (train)
eval_results(train$Unidades, predict(modallpois, type = "response"))
#R squared (test)
eval_results(test$Unidades, predict(modall, newdata = test, type = "response"))

#poisson con factores
#Solo variables categoricas (no apto, muestra mejoria)
modcatpois <- glm(paste("Unidades", paste(names(train)[2:6], collapse = " + "), sep = " ~ "),
             data = train, family = poisson())
#R squared (train)
eval_results(train$Unidades, predict(modcatpois, type = "response"))
#R squared (test)
eval_results(test$Unidades, predict(modcatpois, newdata = test, type = "response"))

#Anadiendo covariables numericas
datos_numpois <- data.frame(Formula = "", R2_train = 0, R2_test = 0, dif = 0)
for (i in 7:12) {
  formula_temp <- paste("Unidades", paste(names(train)[c(2:6, i)], collapse = " + "), sep = " ~ ") 
  modtemp <- lm(formula_temp,
                data = train)
  datos_numpois[i-6,1] <- formula_temp
  datos_numpois[i-6,2] <- eval_results(train$Unidades, predict(modtemp, type = "response"))
  datos_numpois[i-6,3] <- eval_results(test$Unidades, predict(modtemp, newdata = test, type = "response"))
  datos_numpois[i-6,4] <- datos_num[i-6,2] - datos_num[i-6,3] 
}
################################################################################
#POISSON
#Todas las regresiones posibles
counter <- 1
datos_all_pois <- data.frame(Formula = "", R2_train = 0, R2_test = 0, dif = 0)
for (i in 1:11) {
  temp <- combn(names(train)[-1], i)
  for (j in 1:ncol(temp)) {
    formula_temp <- paste("Unidades", paste(temp[,j], collapse = " + "), sep = " ~ ")
    modtemp <- glm(formula_temp, family = poisson(), data = train)
    datos_all_pois[counter,1] <- formula_temp
    datos_all_pois[counter,2] <- eval_results(train$Unidades, predict(modtemp, type = "response"))
    datos_all_pois[counter,3] <- eval_results(test$Unidades, predict(modtemp, newdata = test, type = "response"))
    datos_all_pois[counter,4] <- datos_all_pois[counter,2] - datos_all_pois[counter,3]
    counter <- counter + 1
  }
}
rm(list = c("i", "j", "temp", "formula_temp", "modtemp"))

datos_all_pois <- datos_all_pois %>%
  mutate(dif = abs(R2_train - R2_test)) %>%
  arrange(dif)

best_formula <- datos_all_pois[1,1]
best_sum <- sum(datos_all_pois[1,2:3]^2)

for (i in 2:nrow(datos_all_pois)) {
  temp_sum <- sum(datos_all_pois[i,2:3]^2)
  if (temp_sum > best_sum & datos_all_pois[i,4] < 0.1) {
    best_formula <- datos_all_pois[i,1]
    best_sum <- temp_sum
  }
}
best_formula #objective model (cumple el criterio del 10%)
best_sum
which.max(datos_all_pois[,1] == best_formula)
# saveRDS(best_formula, "formulapoiss.Rds")

#Todas las regresiones posibles con regularizacion poisson (fracaso)

counter <- 1
datos_pois_reg <- data.frame(Formula = "", alpha = 0, lambda = 0, R2_train = 0, R2_test = 0, dif = 0)
param_grid <- expand.grid(alpha = seq(0, 1, .05), lambda = 10^seq(-3, 2, length.out = 100))
library(glmnet)
library(caret)
t1 <- Sys.time()
for (i in 2:11) {
  temp <- combn(names(train)[-1], i)
  for (j in 1:ncol(temp)) {
    formula_temp <- paste("Unidades", paste(temp[,j], collapse = " + "), 
                          sep = " ~ ")
    modtemp <- train(as.formula(formula_temp), method = "glmnet", 
                     trControl = trainControl(method = "cv", number = 10),
                     tuneGrid = param_grid,
                     family = "poisson", 
                     data = train)
    datos_pois_reg[counter, 2:3] <- modtemp$bestTune
    train_temp <- model.matrix(as.formula(formula_temp), data = train)[, -1]
    test_temp <- model.matrix(as.formula(formula_temp), data = test)[, -1]
    modtemp <- modtemp$finalModel
    datos_pois_reg[counter,1] <- formula_temp
    datos_pois_reg[counter,4] <- eval_results(train$Unidades, 
                                              predict(modtemp,
                                                      newx = train_temp, 
                                                      s = modtemp$lambdaOpt,
                                                      type = "response"))
    datos_pois_reg[counter,5] <- eval_results(test$Unidades, 
                                              predict(modtemp,
                                                      newx = test_temp, 
                                                      s = modtemp$lambdaOpt,
                                                      type = "response"))

    
    datos_pois_reg[counter,6] <- datos_pois_reg[counter,4] - datos_pois_reg[counter,5]
    counter <- counter + 1
  }
}
t2 <- Sys.time()
print(paste("El tiempo que se demoró fue", t2-t1, sep = " "))

################################################################################
#GAMLSS
#Mejores distribuciones
library(gamlss)
#dist_conteos <- gamlss::fitDist(datos$Unidades, type = "counts")
#saveRDS(dist_conteos, "dist_conteos.Rds")
readRDS("dist_conteos.Rds")

#ZANBI(Por ahora, el mejor)
zanbi <- gamlss(Unidades ~ Dia + Mes + Ano + Semana + Festivo, 
                family = ZANBI(), data = train)
pred_zanbi <- predict(zanbi, newdata = test, type = "response")
eval_results(train$Unidades, round(fitted(zanbi)))
eval_results(test$Unidades, round(pred_zanbi))

#ZINBI
zinbi <- gamlss(Unidades ~ Dia + Mes + Ano + Semana + Festivo, 
                family = ZINBI(), data = train)
pred_zinbi <- predict(zinbi, newdata = test, type = "response")
eval_results(train$Unidades, round(fitted(zinbi)))
eval_results(test$Unidades, round(pred_zinbi))

#ZANBI con la mejor formula POISSON (Empeora)
zanbi_pois <- gamlss(as.formula(formulapoiss), 
                     family = ZANBI(), data = train)
pred_zanbi_pois <- predict(zanbi_pois, newdata = test, type = "response")
eval_results(train$Unidades, round(fitted(zanbi_pois)))
eval_results(test$Unidades, round(pred_zanbi_pois))

#ZIP
zip <- gamlss(Unidades ~ Dia + Mes + Ano + Semana + Festivo,
              family = ZIP(), data = train)
pred_zip <- predict(zip, newdata = test, type = "response")
eval_results(train$Unidades, round(fitted(zip)))
eval_results(test$Unidades, round(pred_zip))

#GEOM(A tener en cuenta)
geom <- gamlss(Unidades ~ Dia + Mes + Ano + Semana + Festivo,
               family = GEOM(), data = train)
pred_geom <- predict(geom, newdata = test, type = "response")
eval_results(train$Unidades, round(fitted(geom)))
eval_results(test$Unidades, round(pred_geom))

#DPO
dpo <- gamlss(Unidades ~ Dia + Mes + Ano + Semana + Festivo, 
              family = DPO(), data = train)

############################RF#####################
library(caret)
knn_reg <- train(Unidades ~ Dia + Mes + Ano + Semana + Festivo,
                 method = "knn",
                 data = train)
pred_knn <- predict(knn_reg, newdata = test)
eval_results(train$Unidades, round(fitted(knn_reg)))
eval_results(test$Unidades, round(pred_knn))

ctrl_rf <- trainControl(method = "LGOCV", 
                        number = 10,
                        p = 0.2,
                        )

rf <- train(Unidades ~ Dia + Mes + Ano + Semana + Festivo,
            method = "rf",
            data = train)
pred_rf <- predict(rf, newdata = test)
eval_results(train$Unidades, round(fitted(rf)))
eval_results(test$Unidades, round(pred_rf))

########FINISHES MODELING STAGE (FOR NOW)###################

#DATA GENERATING FUNCTION

gendata <- function(modelo){
  predicted1 <- predict(modelo, newdata = train, type = "response")
  reals1 <- train$Unidades
  label1 <- factor(c(rep("real",length(reals1)), rep("predicho",length(reals1))))
  dates1 <- subset(datos, subset = 2012 <= datos$Ano & datos$Ano <= 2016 )[,1]
  
  predicted2 <- predict(modelo, newdata = test, type = "response")
  reals2 <- test$Unidades
  label2 <- factor(c(rep("real",length(reals2)), rep("predicho",length(reals2))))
  dates2 <- subset(datos, subset = datos$Ano == 2017)[,1]
  
  
  frame1 <- data.frame(Fecha = c(dates1,dates1),
                      Valor = c(reals1, predicted1),
                      Clase = label1,
                      Dia = c(wday(dates1),wday(dates1)),
                      Semana = c(week(dates1),week(dates1)),
                      Mes = c(month(dates1),month(dates1)),
                      Ano = c(year(dates1),year(dates1)))
  
  frame2 <- data.frame(Fecha = c(dates2,dates2),
                       Valor = c(reals2, predicted2),
                       Clase = label2,
                       Dia = c(wday(dates2),wday(dates2)),
                       Semana = c(week(dates2),week(dates2)),
                       Mes = c(month(dates2),month(dates2)),
                       Ano = c(year(dates2),year(dates2)))

  
  write.csv(frame1, "predtrain.csv")
  write.csv(frame2, "predtest.csv")
  
 }

gendata(zinbi)

#GENERTING FLAT FILES
pred2012_2017 <- predict(zinbi, newdata = datos[,3:7], type = "response")
pred2018 <- predict(zinbi, newdata = datos2018[,2:6], type = "response")

Fechatrain <- subset(datos, subset = 2012 <= datos$Ano & datos$Ano <= 2017 )[,1]
Flat2012_2017 <- data.frame(Fecha = Fechatrain, Prediccion = round(pred2012_2016))
write.csv(Flat2012_2017, "Flat2012_2017.csv")

Flat2018 <- data.frame(Fecha = datos2018$Fecha, Prediccion = round(pred2018))
write.csv(Flat2018, "Flat2018.csv")

#GENERATING PREDICTIONS TO 2018 

frame2018 <- data.frame(Fecha = Flat2018$Fecha,
                     Valor = Flat2018$Prediccion,
                     Clase = rep("predicho", length(Flat2018$Prediccion)),
                     Dia = wday(datos2018$Fecha),
                     Semana = week(datos2018$Fecha),
                     Mes = month(datos2018$Fecha),
                     Ano = year(datos2018$Fecha))

write.csv(frame2018, "pred2018.csv", row.names = F)
