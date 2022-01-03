datos <- readRDS("datos.Rds")

#TRAIN Y TEST
train <- subset(datos, subset = 2012 <= datos$Ano & datos$Ano <= 2016 )
test <- subset(datos, subset = datos$Ano == 2017)

#RMSE FUNCTION
rmse <- function(mod, tst = T){
  if (tst){
    pred <- predict(mod, test)
    return(sqrt(mean((pred-test$Unidades)^2)))}
  else{
    pred <- predict(mod, train)
    return(sqrt(mean((pred-train$Unidades)^2)))
  }
}

#RLM ALL COVARIABLES
mod1 <- lm(Unidades~Dia+Festivo+Mes+Semana+PIBanual+PIBpersona+TRM, data = train)
summary(mod1)
rmse(mod1, tst = T)

#RLM REMOVING PIB's and TRM
mod2 <- lm(Unidades~Dia+Festivo+Mes+Semana+Ano, data = train)
summary(mod2)
rmse(mod2, tst = T)

#RLM REMOVING Ano
mod3 <- lm(Unidades~Dia+Festivo+Mes+Semana, data = train)
summary(mod3)
rmse(mod3, tst = T)

#RLM REMOVING SEMANA
mod4 <- lm(Unidades~Dia+Festivo+Mes+Ano, data = train)
summary(mod4)
rmse(mod4, tst = T)

#RLM REMOVING MES
mod5 <- lm(Unidades~Dia+Festivo+Semana+Ano, data = train)
summary(mod5)
rmse(mod5, tst = T)

#Mod2 wins!

#Generating combination of two numerical variables

formulas <- c()
for (i in 7:11) {
  temp <- names(datos)[-2]
  fixed <- paste(temp[c(1:6, 12, i)], collapse = " + ")
  formulas[i-7] <- paste("Unidades", fixed, sep = " ~ ")
}
rm(list = c("i", "temp", "fixed"))

