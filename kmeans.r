setwd('C:/Users/lanyi/Desktop/Sem2/IS5126/guided project 1')

library(datasets)
library(ggplot2)

#load all the relavant data
Season0405<-read.csv(file='Season0405.csv',header=TRUE, sep=",")
Season0506<-read.csv(file='Season0506.csv',header=TRUE, sep=",")
Season0607<-read.csv(file='Season0607.csv',header=TRUE, sep=",")
Season0708<-read.csv(file='Season0708.csv',header=TRUE, sep=",")
Season0809<-read.csv(file='Season0809.csv',header=TRUE, sep=",")
Season0910<-read.csv(file='Season0910.csv',header=TRUE, sep=",")
Season1011<-read.csv(file='Season1011.csv',header=TRUE, sep=",")
Season1112<-read.csv(file='Season1112.csv',header=TRUE, sep=",")
Season1213<-read.csv(file='Season1213.csv',header=TRUE, sep=",")
Season1314<-read.csv(file='Season1314.csv',header=TRUE, sep=",")
Season1415<-read.csv(file='Season1415.csv',header=TRUE, sep=",")
allSeason<-rbind(Season0405,Season0506,Season0607,Season0708,Season0809,Season0910,Season1011,Season1112,Season1213,Season1314,Season1415)

#Data exploration
Season0405$salary<-ceiling(Season0405$salary/1000000)
ggplot(Season0405,aes(age,salary))+geom_point()
ggplot(Season0405,aes(pos,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(team_id,salary))+geom_point()
ggplot(Season0405,aes(fg2a,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(fg3a,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(blk,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(ast,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(pts,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(fg3_pct,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(debut,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(height,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(fg,salary,color=team_id))+geom_point()
ggplot(Season0405,aes(tov,salary,color=team_id))+geom_point()
ggplot(Season1415,aes(tov,salary,color=team_id))+geom_point()
head(Season0405)

#kmeans part
columnnames<-c("ts_pct","age","salary")
newdata<-Season0405[columnnames]
newdata$age<-newdata$age/50
newone<-na.omit(newdata)
ggplot(newone,aes(tov,ws,color=salary))+geom_point()
Cluster<-kmeans(newone[,1:3],5,nstart=5000)
Cluster
ggplot(newone,aes(ts_pct,age,color=Cluster$cluster))+geom_point()+scale_color_gradient(low="blue", high="red")
table(Cluster$cluster)


#linear regression part
ylm<-lm(salary~debut+weight+per+ts_pct+tov_pct+mp+blk_pct+ws+stl_pct+trb_pct,data=Season1415)
summary(ylm)

ggplot(Season1415,aes(tov,fg,color=salary))+geom_point()
#Test if height and weight are correlated
handw<-lm(height~weight,data=allSeason)
summary(handw)
ggplot(Season1415,aes(height,weight))+geom_point()

