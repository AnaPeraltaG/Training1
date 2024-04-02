
####EXERCISE 1
###edited document

##Exercise 0 Importing Data

library (foreign)
lab2 <- read.xport("C:/Users/analu/OneDrive - Drexel University/APG organized folder/Education/PhD @ Drexel/Courses/EPI 700_ R/Lectures and labs/2. Coding style- preparing data for analysis/02.0506nhanes_DEMO_D.xpt", header=T)
View(lab2)
 
dim(lab2)    #gives n of observations and rows
head(lab2)
tail(lab2)
      


##Exercise 01: Each person is assigned a study number, which is the SEQN variable. Does the same person appear in more than 1 row of the 
## dataset? 

##R/No, there are no duplicates in the SEQN variable

vec_duplicate_any(1:10348)
unique(1:10)                   #provides the unique values in our dataset 
unique(lab2$SEQN)              #need to identify the dataset and variable I'm looking into
 
duplicated(lab2$SEQN)          # tells me if there are duplicates or not (false or true). However, it does not give
                               # me the n; that's why i used the length function

length( duplicated(lab2$SEQN)) #output provides 10348, which is the same n that i got with dimensions. Thus no duplicates



##Exercise 2: How old is the oldest person in the dataset? Why is the oldest age in the dataset this particular number? 

##R/ The oldest person in 85 years old. This is the oldest age in the dataset due to the study data processing and edits 
## (people 85 years and older were grouped at age 85 due to potential disclosure risk).


range( lab2$RIDAGEYR)      #Identifying the oldest person in the dataset
max( lab2$RIDAGEYR)



##Exercise 3: How many persons are that age? 

##R/ 170 persons

length(which (lab2$RIDAGEYR==85))   #Counting total of people with age 85
table (lab2$RIDAGEYR==85)



##Exercise 4: What is the pattern to the missingness for the DMQMILIT variable which relates to the question: “Did {you/SP} ever serve
## in the Armed Forces of the United States?” 

##R/ 4508 are missing data for DMQMILIT; this question was asked to males and females age 17 years and older, which could explain the
## pattern of missingness for the variable. 


#assessing missing data in var DMQMILIT
is.na(lab2$DMQMILIT)                             #I do have missing values in this variable
summary(lab2$DMQMILIT[is.na(lab2$DMQMILIT)]) 

            #use summary to obtain the total of missing values I need to add the dataset & variable name after the function
            #Statement reads: get summary data from lab2, var DMQMILIT where variable DMQMILIT is missing >> is.na(lab2$DMQMILIT)
           
                       

##5)  Your supervisor tells you they are not satisfied with the RIDAGEYR variable, and instead wants to perform a probabilistic imputation
##of age for all the persons 85 and older. Examine the  code for this imputation and explain what it is doing.

##R/ We created the vector ages with the combined data showed below (replicates of each age value 85 and above)
## "dat$ridageyr[dat$ridageyr == 85]" means we want to retrieve data from dataset dat, variable ridageyr where variable ridageyr is equal to 85.
##The "sample(ages, 170, replace = T)" portion relates to the sampling method. We are trying to perform a probabilistic imputation 
##of the variable age, where n (or the number of values to choose from)=170. The sampling will be with replacement (replace=T), 
##which means that the total n that will be drawn will be replaced back for the next draw.

ages <- c(rep(85,10), rep(86,9), rep(87,8), 
          rep(88,7),  rep(89,6), rep(90,5),
          rep(91,4),  rep(92,3), rep(93,2),
          rep(94,1))
dat$ridageyr[dat$ridageyr == 85] <- sample(ages, 170, replace = T) 





####EXERCISE 2####

##Exercise 0: Import in the dataset siswave3.csv. Create the dataframe sis2 with only the above variables.

sis<-read.csv("C:/Users/analu/OneDrive - Drexel University/APG organized folder/Education/PhD @ Drexel/Courses/EPI 700_ R/Lectures and labs/2. Coding style- preparing data for analysis/02.siswave3.csv", header=T)
View(sis)
dim(sis)


sis2<-sis[,c("rearn","tearn","ssi","welfare","charity","sex","race","immig","workmos","workhrs")]



##Exercise 1: Why do you think there are values below 0 for respondent’s earnings? 

##R/ The summary statistics on each variable show that the minimun value for all is -9, which is not a logical value for these variables.
## Thus, -9 might be used to refer to those who refused to answer or to whom this question did not apply (e.g. children?).

summary(sis2) #provides summary stats on each variable. 
            
table(sis2$rearn[sis2$rearn < 0])
table(sis2$tearn[sis2$tearn < 0])
table(sis2$ssi[sis2$ssi < 0])
table(sis2$welfare[sis2$welfare < 0])
table(sis2$charity[sis2$charity < 0])
                                
#-9 is not a logical value for these variables, so it might refer to refuse to answer or something similar



## Exercise2: How many persons have missing values for race? For immig? For both race AND immig? 

##R/ we have 37 missing values for race, 34 missing values for variable immig, and 9 persons values for both race and immig.


# of missing values for race; immig; race AND immig
is.na(sis2$race)            #we do have missing values
is.na(sis2$immig)           #we do have missing values

summary(sis2$race[is.na(sis2$race)])          #gets the # of missing values for var race
summary(sis2$immig[is.na(sis2$immig)])        #gets the # of missing values for var race

sum( (is.na(sis2$race) & is.na(sis2$immig)) ) 


       
# Exercise 3: Convert race into a factor variable race2 with sensible levels. Missing values should be assigned their own level
## called “Missing”. Answer the following questions: Why are 1,2,3,4 are not sensible? Why should race be a factor variable and not
## a continuous/ordinal variable?)


##R/ The values were not sensible since they represent race (categorical variables) but are analyzed as a numerical variable. The
## variable race is categorical, not continuous. In addition, it is not ordinal, so it should be coded with sensible levels. 


#Recode as 1=white;2=black;3=Hispanic(nonblack); 4=other
sis2$race2 <- as.factor(sis2$race)          #forcing it to be analyzed as character variable
summary(sis2$race)
table(sis2$race) #the variable is coded as 1,2,3 and 4.


levels(sis2$race2) <-c ("white", "black", "hispanic(nonblack)", "other")

sis2$race2 <- ifelse (sis2$race==1,"white",
                      ifelse(sis2$race==2, "black",
                             ifelse(sis2$race==3, "Hispanic(NonBlack)", "other")))

table(sis2$race)
table(sis2$race, sis2$race2, useNA = "always")  #by adding useNA= "always", i get the number of missing values in the table



# Exercise 4: You want to create a total household income variable (totals earnings for respondent + spouse) but you have to 
# clean those negative values first. Use median imputation to replace the negative values, then create a total household income 
# variable named hhinc.  What is the percentage of households who have a total household income of $0?

##R/ 20.7% of households have a total household income of $0

summary(sis2$rearn)
summary(sis2$tearn)

table(sis2$rearn)
table(sis2$tearn)

sis2$rearn2 <- sis2$rearn   #creating new variable in case we need the original variables. 
sis2$tearn2 <- sis2$tearn

median(sis2$rearn[sis2$rearn >= 0])   #retrieve the median of rearn2 where rearn is equal or greater than zero
median(sis2$tearn[sis2$rearn >= 0])   #the median here was zero, which would raise the question if this imputation method will be useful

sis2$rearn2[sis2$rearn3 < 0] <- median(sis2$rearn[sis2$rearn >= 0])
sis2$tearn2[sis2$tearn2 < 0] <- median(sis2$tearn[sis2$rearn >= 0])

sis2$rearn_other <- ifelse(sis2$rearn <0,16000,sis2$rearn)    #other way of doing it 


sis2$hhinc <- sis2$rearn2 + sis2$tearn2 #imputation
summary(sis2$hhinc)

sum(sis2$hhinc %in% 0)/ nrow(sis2)  #gives the percentage of households



##Exercise 5:Create a total household income quintile variable hhincquint. because of your answer to 4), you should choose cutpoints 
##based on 0, 0.207, 0.40, 0.60, 0.80, 1.0, so everyone in the lowest quintile will have $0 of total household income.

quintiles <- quantile(sis2$hhinc, c(0, 0.207, 0.40,0.60, 0.80, 1.0))  #The values for each of these are: 0 250 16000 31500 70000 3250000

sis2$hhincquint <- cut(sis2$hhinc, breaks=quintiles, include.lowest=T, right=F)  #break specifies in what value the break will go 

table(sis2$hhincquint)



##Exercise 6:What is the median total household income in each household income quintile? 

##

by(sis2$hhinc, sis2$hhincquint, FUN= median)


##Exercise 7:Create a subset of sis2 that has only rows with complete data (no NAs). 

##R/ 
sis3 <- na.omit(sis2)



