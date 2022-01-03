datos <- readRDS("datos.Rds")

#TRAIN Y TEST
train <- subset(datos, subset = 2012 <= datos$Ano & datos$Ano <= 2016 )[,-1]
test <- subset(datos, subset = datos$Ano == 2017)[,-1]

#Rsquared function
eval_results <- function(true, predicted) {
  SSE <- sum((predicted - true)^2)
  SST <- sum((true - mean(true))^2)
  R_square <- 1 - SSE / SST
  print(SSE)
  print(SST)
  R_square
  
}

#Todas las covariables
modall <- lm(Unidades ~ ., data = train)
#R squared (train)
eval_results(train$Unidades, predict(modall))
#R squared (test)
eval_results(test$Unidades, predict(modall, newdata = test))
