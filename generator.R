library(mirt)

#need to estimate parameters and epic model in c set, then iief scores in full using
#established parameters. check if IEFF thetas are the same this way and former

setwd("C:/Users/jdawg/Documents/R/thesis/master-thesis")
calibration = read.csv("calibration_sample.csv", header=TRUE) 
validation = read.csv("validation_sample.csv", header=TRUE)

# d = as.data.frame(d)
# q = apply(d, 2, as.numeric)
# q[8,] = c(q[8,2:4],NA) 
#dat <- simdata(slopes, q, 2000, itemtype = 'graded')
dat = readRDS('generated.rds')

base_model <- mirt(dat, model=1, itemtype='graded')
parameters = mod2values(base_model)
iief_parameters = parameters[c(1:25,55:56),]
epic_parameters = parameters[26:56,]
iief_parameters$est = FALSE
iief_parameters$parnum = 1:nrow(iief_parameters)
epic_parameters$est = FALSE
epic_parameters$parnum = 1:nrow(epic_parameters)
model_iief = mirt(dat[,1:5], 1, pars=iief_parameters, itemtype='graded')
model_epic = mirt(dat[,6:11],1, pars = epic_parameters, itemtype='graded')
epic_scores = fscores(model_epic, method = "EAPsum", full.scores = FALSE)
iief_scores = fscores(model_iief, method = "EAPsum", full.scores = TRUE)

dat = as.data.frame(dat)

for (x in 1:nrow(dat)){
  dat$Sum_iief[x]=sum(dat[x,1:5], na.rm=TRUE)
  dat$Sum_epic[x] = sum(dat[x,6:11], na.rm= TRUE)
}

# for (x in 1:nrow(dat)){
#   dat$Sum_iief[x]=sum(validation[x,2:6], na.rm=TRUE)
#   validation$Sum_epic[x] = sum(validation[x,7:12], na.rm= TRUE)
# }

#validation$pred_epic = expected.test(model_epic, Theta = as.matrix(thetas,,1))
dat$pred = expected.test(model_epic, Theta = as.matrix(iief_scores,,1))
obs = dat$Sum_epic

rmse = sqrt(mean((pred-obs)^2, na.rm=TRUE))

ggplot(data = df, aes(x=Sum_iief)) + geom_jitter(aes(y = Sum_epic, colour='Observed'), alpha=.3) + 
  geom_point(aes(y = predicted_scores, colour='Predicted')) +
  geom_smooth(aes(y = Sum_epic, colour='Observed')) +
  geom_smooth(aes(y = predicted_scores, colour='Predicted'), linetype='dashed') +
  scale_color_manual("",
                     breaks = c("Predicted", "Observed"),
                     values = c('black', 'red'))

t = ggplot() + 
  geom_line(data= theta_list, aes(x = Theta1, y=SE1, color = 'EPIC')) +
  geom_point(data= theta_list, aes(x =Theta1, y=SE1, color = 'EPIC')) +
  geom_line(data= theta_list, aes(x = Theta2, y=SE2, color='IIEF')) +
  geom_point(data= theta_list, aes(x = Theta2, y=SE2, color='IIEF')) +
  xlab('Theta') + ylab('Standard error') +
  scale_colour_manual("", 
                      breaks = c("EPIC", "IIEF"),
                      values = c("red", "black"))

setDT(iief_scores)[,freq := .N, by = 1:6]
