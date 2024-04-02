libname vaping "C:\Users\alp395\OneDrive - Drexel University\Drexel\Desktop\bst553";

data vaping.vape;
set vaping.vaping;
run;

*1)RECOVERING MISSING VALUES;
*recovering participants with missing visits;
data vaping.baseline(keep= id vaping nicotine);
set vaping.vape;
by id;
if first.id then output;
run;

proc print data=vaping.baseline;
run;

*v1 is the dataset where all participants have the same number of visits (7);
data vaping.v1;
set vaping.baseline;
time=0; output;
time=3; output;
time=6; output;
time=9; output;
time=12; output;
time=15; output;
time=19; output;
run;

proc print data=vaping.v1 ;
run;

proc sort data=vaping.v1;
by id;
run;

proc sort data=vaping.vape;
by id;
run;

*merging vaping.v1 dataset with the original one (vaping.vape) to have a new dataset (vaping.vaping1) 
This new dataset will have all visits from all participants and missing values assigned to those visits that were not completed by a specific id;
data vaping.vaping1;
merge vaping.vape vaping.v1;
by id time;
run;

*Checking the data;
proc print data=vaping.vaping1;
var id time vaping exercise FEV1 nicotine;
run;

proc freq data=vaping.vaping1; 
tables time;
run;


*2)DATA FORMAT TRANSFORMATION - from long to wide;

*a) transposing variable FEV1;
proc transpose data=vaping.vaping1 out=vaping.fev1 prefix=FEV1_;
by id;
id time;
var FEV1;
run;

proc print data=vaping.fev1;
run;

*b) transposing variable exercise;
proc transpose data=vaping.vaping1 out=vaping.exer prefix=Exer_;
by id;
id time;
var exercise;
run;

proc print data=vaping.exer;
run;

*c) transposing variable nicotine;
proc transpose data=vaping.vaping1 out=vaping.nicot prefix=nicot_;
by id;
id time;
var nicotine;
run;

proc print data=vaping.nicot;
run;

*d) transposing variable vaping;
proc transpose data=vaping.vaping1 out=vaping.vapi prefix=vapi_;
by id;
id time;
var vaping;
run;

proc print data=vaping.vapi;
run;

*Data format transformation - from long to wide --> menging all datasets with transposed variables;
data vaping.vaping2;
merge vaping.fev1 (drop=_NAME_) vaping.exer (drop=_NAME_) vaping.nicot (drop=_NAME_) vaping.vapi (drop=_NAME_);
by id;
run;

proc print data=vaping.vaping2;
run;


*3)DESCRIPTIVE STATISTICS*
*long format final dataset= vaping.vaping1;
*wide format final dataset=vaping.vaping2;

*checking the missing data patterns;
data vaping.vaping2_fev1;
set vaping.vaping2;
keep id FEV1_0 FEV1_3 FEV1_6 FEV1_9 FEV1_12 FEV1_15 FEV1_19;
RUN;

proc print data=vaping.vaping2_fev1; 
run;

proc mi data=vaping.vaping2_fev1 seed=37851 nimpute=0 ;
var FEV1_0 FEV1_3 FEV1_6 FEV1_9 FEV1_12 FEV1_15 FEV1_19;
run;




data vaping.vaping1;
set vaping.vaping1;
	baselineage=16; *all participants had 16y at baseline;
	FUtime_in_years= time*0.083;
	age=baselineage+FUtime_in_years;
	FUtime_in_months=FUtime_in_years*12;
run;


*For all subjects;

proc freq data=vaping.vaping1; 
tables visit;
run;

*identyfing FU time;
proc means data=vaping.vaping1; 
var FUtime_in_years;
var FUtime_in_months;
run;

PROC CORR DATA=vaping.vaping2; 
VAR FEV1_0 FEV1_3 FEV1_6 FEV1_9 FEV1_12 FEV1_15 FEV1_19;
RUN;

PROC CORR DATA=vaping.vaping2; 
VAR EXER_0 EXER_3 EXER_6 EXER_9 EXER_12 EXER_15 EXER_19;
RUN;

*create average means for fev1, for each visit;
proc means data=vaping.vaping1;
class  time;
var fev1;
ods output summary=grouped_FEV1_means_by_time;
run;

proc sgplot data=grouped_FEV1_means_by_time; 
series x=time  y=FEV1_mean ;
run;

*create average means for exercise, for each visit;
proc means data=vaping.vaping1;
class  time;
var exercise;
ods output summary=grouped_exercise_means_by_time;
run;

proc sgplot data=grouped_exercise_means_by_time; 
series x=time  y=exercise_mean ;
run;


*create average means for  FEV1 comparing vapers and non-vapers, for each visit;
proc means data=vaping.vaping1;
class vaping time;
var fev1;
ods output summary=grouped_FEV1_means_by_time;
run;
proc sgplot data=grouped_FEV1_means_by_time; 
series x=time  y=FEV1_mean / group=vaping;
run;

*create average means for exercise comparing vapers and non-vapers, for each visit;
proc means data=vaping.vaping1;
class vaping time;
var exercise;
ods output summary=grouped_exer_means_by_time; 
run;
proc sgplot data=grouped_exer_means_by_time; 
series x=time  y=exer_mean / group=vaping;
run;


*getting N and % of nicotine among e-cigarettes users;
proc freq data=vaping.vaping1;
table nicotine*vaping; 
run; 



*For each subject;  
/*Ordinary scatterplot*/
PROC SGPLOT DATA=vaping.vaping1;  *to identify outlier ovservations, not so useful;
TITLE "ORDINARY FEV1 SCATTERPLOT";
scatter y=FEV1 x=age;
RUN;

/*SPAGHETTI  PLOT */
PROC SGPLOT DATA=vaping.vaping1 noautolegend;   *with overall mean overlaid; *to identify outlier subjects;
TITLE "FEV1 TRENDS FOR SUBJECTS (SPAGHETTI PLOT), overlay mean";
Series y =FEV1 x=age / group=id  lineattrs=(color=gray thickness=1);
reg y =FEV1 x=age / MARKERATTRS=(size=0) lineattrs=(color=red thickness=2);  
RUN;

PROC SGPLOT DATA=vaping.vaping1 noautolegend;   *with overall mean overlaid, differentiating vapers vs non-vapers;
TITLE "FEV1 TRENDS FOR SUBJECTS (SPAGHETTI PLOT), overlay mean by vaping status";
Series y =FEV1 x=age / group=id  lineattrs=(color=gray thickness=1);
reg y =FEV1 x=age / group=vaping MARKERATTRS=( size=0) lineattrs=(color=red thickness=2); 
RUN;

/*Scatterplot for each subject with trend added*/
PROC SGPANEL DATA=vaping.vaping1; 
panelby id / rows=5 columns=6;
TITLE "Individuals' FEV1 scatterplots with subject trend line added";
scatter y=FEV1 x=time ;
reg y=FEV1 x=time;
RUN;




PROC MEANS DATA=vaping.vaping1;
Title "Descriptives for each person";
BY id;
VAR FEV1;
ODS OUTPUT summary=FEV1_summary;
RUN;

*Histogram of means (within individual means);  *have no idea what this is for;
PROC UNIVARIATE DATA=FEV1_summary;
VAR FEV1_mean;
Histogram FEV1_mean;
run;

proc reg data=vaping.vaping1;
by id;
model fev1=time;
ods output ParameterEstimates=FEV1slopes;
run;

proc univariate data=FEV1slopes;
where variable='time';
var estimate;
histogram estimate;
run;


*Code for initial model, acknowledging correlated data; 
proc mixed data=vaping.vaping1;
class id time;
model FEV1 = vaping time vaping*time / s cl;  
repeated time / subject=id type=un;  
run;

proc mixed data=vaping.vaping1;
class id time;
model FEV1 = vaping time vaping*time / s cl; 
repeated time / subject=id type=cs;  
run;

proc mixed data=vaping.vaping1;
class id time;
model FEV1 = vaping time vaping*time / s cl;  
repeated time / subject=id type=ar(1);  
run;

proc mixed data=vaping.vaping1; *lower AIC;
class id time;
model FEV1 = vaping time vaping*time / s cl;  
repeated time / subject=id type=toep;  
run;


*//////////////////////////////////MODELS;

*unadjusted model;
proc mixed data= vaping.vaping1 empirical;
  class id time (ref="0") ;     
  model FEV1 = vaping / s cl; 
  repeated time / type=toep subject=id r; *final covariance;
run;


*using time as continuous, but fev1 is not linear?;
proc mixed data= vaping.vaping1 empirical;
  class id visit(ref="1") ;     
  model FEV1 = vaping time vaping*time  / s cl; 
  repeated visit / type=toep subject=id r; *final covariance;
run;


*Q1 and 2: differences in the pattern of change in FEV1 over time by e-cigarette use;
proc mixed data= vaping.vaping1 empirical;
  class id visit time ;     
  model FEV1 = vaping time vaping*time / s cl; 
  repeated visit / type=toep subject=id r; 
run;

proc mixed data=vaping.vaping1 empirical;
class id visit time(ref='0') ;                  
model fev1 = vaping time vaping*time  / s cl;   
repeated visit / type=toep subject=id r; 
  
   estimate 'change from v1 to v2 among non-smokers ' time 1 0 0 0 0 0 -1 /cl;  
   estimate 'change from v1 to v3 among non-smokers ' time 0 1 0 0 0 0 -1 /cl;  
   estimate 'change from v1 to v4 among non-smokers ' time 0 0 1 0 0 0 -1 /cl;  
   estimate 'change from v1 to v5 among non-smokers ' time 0 0 0 1 0 0 -1 /cl;  
   estimate 'change from v1 to v6 among non-smokers ' time 0 0 0 0 1 0 -1 /cl;  
   estimate 'change from v1 to v7 among non-smokers ' time 0 0 0 0 0 1 -1 /cl;  

   estimate 'change from v1 to v2 among smokers ' time 1 0 0 0 0 0 -1 vaping*time 1 0 0 0 0 0 -1 /cl;  
   estimate 'change from v1 to v3 among smokers ' time 0 1 0 0 0 0 -1 vaping*time 0 1 0 0 0 0 -1 /cl;  
   estimate 'change from v1 to v4 among smokers ' time 0 0 1 0 0 0 -1 vaping*time 0 0 1 0 0 0 -1 /cl;  
   estimate 'change from v1 to v5 among smokers ' time 0 0 0 1 0 0 -1 vaping*time 0 0 0 1 0 0 -1 /cl;  
   estimate 'change from v1 to v6 among smokers ' time 0 0 0 0 1 0 -1 vaping*time 0 0 0 0 1 0 -1 /cl;  
   estimate 'change from v1 to v7 among smokers ' time 0 0 0 0 0 1 -1 vaping*time 0 0 0 0 0 1 -1 /cl; 

  run;


proc mixed data= vaping.vaping1 empirical;
title 'describing differences';
title2 'using toep covariance matrix and robust standard errors';
   class id visit time(ref='0') ;                        
   model fev1 = vaping time vaping*time  /noint s;   
   repeated visit / type=toep subject=id r; 
  
   estimate 'e-cigarrete difference at v1' vaping 1 vaping*time 1 0 0 0 0 0 0 /cl;
   estimate 'e-cigarrete difference at v2' vaping 1 vaping*time 0 1 0 0 0 0 0 /cl;
   estimate 'e-cigarrete difference at v3' vaping 1 vaping*time 0 0 1 0 0 0 0 /cl;
   estimate 'e-cigarrete difference at v4' vaping 1 vaping*time 0 0 0 1 0 0 0 /cl;
   estimate 'e-cigarrete difference at v5' vaping 1 vaping*time 0 0 0 0 1 0 0 /cl;
   estimate 'e-cigarrete difference at v6' vaping 1 vaping*time 0 0 0 0 0 1 0 /cl;
   estimate 'e-cigarrete difference at v7' vaping 1 vaping*time 0 0 0 0 0 0 1 /cl;
  run;

*Q3: Difference in the rate of change in FEV1 over time comparing those that exercise vs those that do not exercise; *cmparing the patterns of change;
  *random intercept, linear slope;
  proc mixed data= vaping.vaping1 empirical;
  class id ;     
  model FEV1 = time time*time exercise time*exercise time*time*exercise / s cl;
  random int time /subject=id type=toep;
  contrast 'exercise modifies time pattern'
	time*exercise 1,
	time*time*exercise 1;
  run;

*Q4: Difference in the rate of change in FEV1 over time comparing those that vape vs those that do not, within groups of exercise;

 Data vaping.vaping1;
 set vaping.vaping1;
 if exercise  then exercise_cat=.;
 if exercise <19 then exercise_cat=1;
 else exercise_cat=0;
 run; 

 data vaping.vaping1_Ex0; *high physical activity;
 set vaping.vaping1;
 where exercise_cat=0;  
 run;

 data vaping.vaping1_Ex1; *low physical activity;
 set vaping.vaping1;
 where exercise_cat=1;
 run;

  proc mixed data= vaping.vaping1_Ex1 empirical;
  class id vaping (ref='0');     
  model FEV1 = time time*time vaping time*vaping time*time*vaping / s cl;
  random int time /subject=id type=toep;
  contrast 'vaping modifies time pattern'
	time*vaping 1,
	time*time*vaping 1;
  run;

  proc mixed data= vaping.vaping1_Ex0 empirical;
  class id vaping (ref='0');     
  model FEV1 = time time*time vaping time*vaping time*time*vaping / s cl;
  random int time /subject=id type=toep;
  contrast 'vaping modifies time pattern'
	time*vaping 1,
	time*time*vaping 1;
  run;

*Q5: Among vaping users, is there an association between the pattern of change in FEV and whether the product contains nicotine?;
data vaping.vaping1_vapers;
 set vaping.vaping1;
 where vaping=1;
 run;

  proc mixed data= vaping.vaping1_vapers empirical;
  class id visit time nicotine (ref="0");     
  model FEV1 = nicotine time nicotine*time / s cl; 
  repeated visit / type=toep subject=id r; 
run;

*Q6: Difference in the rate of change in FEV1 over time; 
  proc mixed data= vaping.vaping1 empirical;
  class id time (ref='0') ;     
  model FEV1 = time/ s cl;
  random int time /subject=id type=toep;
  run;









