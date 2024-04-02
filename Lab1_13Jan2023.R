log (25)

#List of objects in the workspace
ls ()

#getting working directory
getwd ()

#Exercise 1
5^8

a<-1
b<-5
c<-3
(-12+sqrt(b^2-4*a*c))/(2*a)

log10(100000)

sum((1+50)/2)*50

#Exercise 2
temp<-35*1:100-(1:100)^3+4000

length(temp)

temp [100]

temp [12]

#to get multiple values from the vector we can use c
#c creates a vector. In temp, we didn't use c but used :
temp[c(12,29,57)]

max(temp)

#to find out what a function does
?which

which(temp==max(temp))
which(temp==4078)
which.max(temp)

which(temp>4000)

temp[temp<=464]
length(temp[temp<=464])

temp[-]

which(temp <=1000 & temp>=-3000)
temp[which(temp <=1000 & temp>=-3000)]

#Exercise 3
m1<-cbind(c(5,2,13), c(8,4,0))

m2<-rbind(c("apple","banana","cherry"), c("dog","elephant","fish"), c(14,9,5))

m1[3,1]


m2[1,2]
m2[2,2]
m2[3,2]
#also
m2[ ,2]
m2[1:3,2]


m2[3,1]
m2[3,2]
#also
m2[3,1:2]
#also 
m2[3,c(1,2)]

#Exercise 4
climate<-read.csv("/Users/analu/OneDrive - Drexel University/APG organized folder/Education/PhD @ Drexel/Courses/EPI 700_ R/Lectures and labs/1. R basics, basic data manipulation and statistics/01.climate.csv", header=T)

View(climate)
rm(climate)

climate<-read.table("/Users/analu/OneDrive - Drexel University/APG organized folder/Education/PhD @ Drexel/Courses/EPI 700_ R/Lectures and labs/1. R basics, basic data manipulation and statistics/01.climate.csv", header=T, sep=",")

climate2<-climate[,c("city","rain","jan","jul","elev")]
View(climate2)

dim(climate2)

climate[1:3]
climate[c(1,2,3),]

climate2[climate2$city=="philadelphia",]

climate2$rain[climate2$city=="honolulu"]
mean(climate2$jul)

climate2$elev==min(climate2$elev)
climate2$city[climate2$elev==min(climate2$elev)]

climate2$tempdiff<-climate2$jul-climate2$jan
climate2$tempdiff

climate2$city[climate2$tempdiff==max(climate2$tempdiff]

climate2


animals <- factor(c ("bear", "pig", "cow", "bear", "bear", "cow"))
animals
