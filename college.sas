*problem 2 a);
title "Import College Data";
proc import datafile="C:\Users\hwu33\Downloads\College.csv" out=college replace;
delimiter=',';
getnames=yes;
run;
proc print;
run;

title "Create New Dummy Variables";
data college;
set college;
* drop school variable that is not used in analysis;
drop school;
dp=(Private='Yes');
run;
proc print;
run;

title "Histogram for Grad.Rate";
proc univariate;
var Grad_Rate;
histogram/normal;
run;
proc print;
run;

*problem 2 b);
title "Scatterplot Matrix";
proc gplot data=college;
plot Grad_Rate*(Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend dp);
run;
proc print;
run;

*problem 2 c);
title "Boxplot for Grad_Rate by dp";
proc sort data=college;
by dp;
proc boxplot data=college;
plot Grad_Rate*dp;
run;

title "Boxplot for Grad_Rate by Elite10";
proc sort data=college;
by Elite10;
proc boxplot data=college;
plot Grad_Rate*Elite10;
run;
proc print;
run;

*problem 2 d);
title "Full Regression Model for Grad_Rate";
proc reg data=college;
model Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend dp;
run;
proc print;
run;


*problem 2 e);
title "Full Regression Model for Grad_Rate with VIF";
proc reg data=college;
model Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend dp/vif;
run;
proc print;
run;

*problem 2 f);
title "stepwise Selection Method";
*stepwise Selection Method;
proc reg data=college;
model  Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend dp/selection = stepwise;
run;

title "cp Selection Method";
*cp Selection Method;
proc reg data=college;
model  Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend dp/selection = cp;
run;
proc print;
run;

*problem 2 h); 
TITLE "Residual Analysis";
PROC REG;
MODEL Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Personal perc_alumni Expend dp;
PLOT student.*( Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Personal perc_alumni Expend dp);
PLOT student.*predicted.;
PLOT npp.*student.;
RUN;
PROC PRINT;
RUN;

*problem 2 j;
TITLE "Outliers";
PROC REG data = college;
MODEL  Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Personal perc_alumni Expend dp/influence r;
PLOT student.*( Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Personal perc_alumni Expend dp predicted.);
PLOT npp.*student.;
RUN;

title "Remove Influencial Points and Outliers";
data college_new;
set college;
if _n_ in (63, 119, 256, 274, 277, 287, 398, 437, 492) then delete;
run;
proc print;
run;

title "Rerun model selection after removing  Influencial Points and Outliers";
proc reg data=college_new;
model Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Personal perc_alumni Expend dp/vif r influence stb;
run;

title "Remove new Influencial Points and Outliers";
data college_new1;
set college_new;
if _n_ in (201, 342, 472, 559) then delete;
run;
proc print;
run;

title "Rerun model selection after removing  Influencial Points and Outliers";
proc reg data=college_new1;
model Grad_Rate = Accept_pct Elite10 F_Undergrad P_Undergrad Outstate 
Room_Board Personal perc_alumni Expend dp/vif r influence stb;
run;
