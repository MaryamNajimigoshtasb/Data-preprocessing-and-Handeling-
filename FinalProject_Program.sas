/*libname clean '/home/u58699890/My practice/DataHandeling/clean';
filename   project '/home/u58699890/My practice/DataHandeling/PROJECTSAMPLE.xlsx';
PROC IMPORT DATAFILE= project
    OUT= clean.Project
    replace
    DBMS=xlsx;
    GETNAMES=YES;
RUN;


libname clean '/home/u58704320/BAN110NAA';

PROC IMPORT 
    OUT= clean.Project_1
    DATAFILE= "/home/u58704320/BAN110NAA/Project_Dataset.xlsx" replace
    DBMS=xlsx;
    GETNAMES=YES;
RUN;



ods trace on ;
proc freq data=clean.Project_1 order=freq;
table neighbourhood;
run;

proc freq data=clean.Project_1  order=freq;
table neighbourhood;
where neighbourhood not in ('Williamsburg',
'Bedford-Stuyvesant',
'Harlem',
'Bushwick',
'Upper West Side',
"Hell's Kitchen",
'East Village',
'Upper East Side',
'Crown Heights',
'Midtown',
'East Harlem',
'Greenpoint',
'Chelsea',
'Lower East Side',
'Astoria',
'Washington Heights',
'West Village',
'Financial District',
'Flatbush',
'Clinton Hill',
'Long Island City',
'Prospect-Lefferts Gardens',
'Park Slope',
'East Flatbush',
'Fort Greene',
'Murray Hill',
'Kips Bay',

'Flushing',
'Ridgewood');
run;


%let eventrate = 0.2;
DATA clean.Projectsample;
SET clean.Project_1;
where neighbourhood not in
('Williamsburg',
'Bedford-Stuyvesant',
'Harlem',
'Bushwick',
'Upper West Side',
"Hell's Kitchen",
'East Village',
'Upper East Side',
'Crown Heights',
'Midtown',
'East Harlem',
'Greenpoint',
'Chelsea',
'Lower East Side',
'Astoria',
'Washington Heights',
'West Village',
'Financial District',
'Flatbush',
'Clinton Hill',
'Long Island City',
'Prospect-Lefferts Gardens',
'Park Slope',
'East Flatbush',
'Fort Greene',
'Murray Hill',
'Kips Bay',

'Flushing',
'Ridgewood') and (&eventrate*100)/(RANUNI(34)*(1-&eventrate)
+&eventrate) > 50 or
neighbourhood in
('Williamsburg',
'Bedford-Stuyvesant',
'Harlem',
'Bushwick')
and (&eventrate*100)/(RANUNI(34)*(1-&eventrate)
+&eventrate) > 40
or
neighbourhood in (
'Upper West Side',
"Hell's Kitchen",
'East Village',
'Upper East Side',
'Crown Heights',
'Midtown',
'East Harlem',
'Greenpoint',
'Chelsea')
and (&eventrate*100)/(RANUNI(34)*(1-&eventrate)
+&eventrate) > 40
or
neighbourhood in (
'Lower East Side',
'Astoria',
'Washington Heights',
'West Village',
'Financial District',
'Flatbush',
'Clinton Hill',
'Long Island City',
'Prospect-Lefferts Gardens',
'Park Slope',
'East Flatbush',
'Fort Greene',
'Murray Hill',
'Kips Bay',
'Flushing',
'Ridgewood')
 and (&eventrate*100)/(RANUNI(34)*(1-&eventrate)
+&eventrate) > 60
;
RUN;*/


Title' Data Cleaning For Chategorical Variables';

libname clean '/home/u58699890/My practice/DataHandeling/clean';
filename   project '/home/u58699890/My practice/DataHandeling/PROJECTSAMPLE.xlsx';
PROC IMPORT DATAFILE= project
    OUT= clean.Projectsample
    replace
    DBMS=xlsx;
    GETNAMES=YES;
RUN;



/* Freq Distribution */

proc freq data=clean.Projectsample;
table neighbourhood_group room_type;
run;

proc freq data=clean.Projectsample;
table room_type*neighbourhood_group ;
run;





/* Check Missing in Categorical Variables */
proc freq data=clean.Projectsample;
tables _character_ /missing nocum nopercent;
run;

/* Replace Missing values with Not Available or Unknown */

data clean.Projectsample_1;
set clean.Projectsample;
if missing(name) then name='Not Available';
if missing(host_name) then host_name= 'Unknown';
run;

proc print data = clean.projectsample_1 n;
var host_name;
where host_name= 'Unknown' ;
run;

proc print data = clean.projectsample_1 n;
var name;
where name= 'Not Available' ;
run;


/* Creating Derived Variable*/
data clean.Projectsample_1;
set clean.Projectsample_1;

Year= year(last_review);
run;

proc print data= clean.projectsample_1 (obs=10);
var last_review Year;
run;

proc freq data=clean.projectsample_1 order=freq;
table last_review;
run;

/* Correcting errors */

proc print data= clean.projectsample_1 (obs=10);
var room_type Year;
where room_type = 'Entire home/apt';
run;

data clean.Projectsample_2;
format room_type $ 24.;
set clean.Projectsample_1;

if findc(room_type, '/apt', 'i') then
   room_type = 'Entire home/Apartment';
run;

proc datasets library=clean;
delete projectsample_1 ;
run;
proc datasets library=clean;
delete projectsample ;
run;
proc datasets library=clean;
change projectsample_2=projectsample;
run;


*************************************************************************************************;

                                             Title1 'Data Cleaning for Numerical Variables';


title2 'checking for missing , invalid value, Extreme Values and errors';
Title3 'Checking for Missing values';
proc means data=clean.projectsample nmiss n ;
var _numeric_;
run;

title4' Host Id has missing values we try put random id for them as we dont want remove the records just becuase the ids are missing';
title5' as the host id or host name is not important in this analysis we put random id numbers for them';
data clean.projectsample;
set clean.Projectsample;
array host[*] host_id;
do i=1 to dim(host);
b=round(1000*ranuni(123)+100);
if missing(host[i]) then host[i]=b;
end;
drop i b;
run;
proc means data=clean.projectsample nmiss n ;
var _numeric_;
run;


title6 ' last review is missing as it is 25 percent of our data 
we can not delet it, as date data we try to retive them by mode but before we can plot them out';
ods select histogram;
proc univariate data=clean.projectsample;
var last_review;
histogram/normal;
run;
title7 ' we can see here data is highly skewed to the left then replacing missing with median or mode is more advisable';
title8' finding mode of date';

proc freq data=clean.projectsample order=freq;
table last_review;
run;

data clean.projectsample;
set clean.Projectsample;

i='23jun2019'd;
if missing(Last_review) then Last_review=i;
format i mmddyy10.;
drop i;
run;

proc means data=clean.projectsample nmiss;
var _numeric_;
run;

title9 ' updating created drived variable';
data clean.Projectsample;
set clean.Projectsample;
Year= year(last_review);
run;
title10 ' imputing missing value for review per month';
title11 ' first looking at the distribution';
ods select histogram;
proc univariate data=clean.Projectsample;
var reviews_per_month;
histogram/normal;
run;

ods select extremeobs;
proc univariate data=clean.Projectsample nextrobs=500;
var reviews_per_month;
run;

ods select histogram;
proc univariate data=clean.Projectsample;
var reviews_per_month;
where reviews_per_month between 4 and 27;
histogram/normal;
run;
title1' data are highly right skewed';
proc means data=clean.Projectsample  min max mean median nmiss ;
var reviews_per_month;
run;

title2' replace with median as it is right skewed';
%let median=0.71;
data clean.projectsample;
set clean.Projectsample;
if missing(reviews_per_month) then reviews_per_month=&median;
run;
proc means data=clean.Projectsample  min max mean median nmiss ;
var reviews_per_month;
run;

proc means data=clean.projectsample nmiss;
var _numeric_;
run;


title1' we imputed all missing values now we need to ckeck invalid, extrem values, outliers and the normaliztions';
proc print data=clean.Projectsample (obs=2);
run;
title1 ' check the invalid data';
data _NULL_ ;
set clean.Projectsample;
array variables[7] id
host_id
minimum_nights
number_of_reviews
calculated_host_listings_count
availability_365
Year;
length varname $ 32;
file print;
do i=1 to dim(variables);
if (notdigit((strip(variables[i])))) then do;
varname=vname(variables[i]);
put "'observation number is'"  _n_   id=  
 "'the variable name is '" varname    " the value is" variables[i];  
count+1; 
output;
end;
end;
run;


data _null_;
set clean.Projectsample;
file print;
if anyalpha(latitude) or 
anyalpha(longitude) or
anyalpha(price) or
anyalpha(last_review) or
anyalpha(reviews_per_month) then put ID= "there is an error in observation" _n_ 'and id=' id  'with' latitude=
longitude=
price=
reviews_per_month=
last_review=
;
run;


title 'there was no any invalid value';


title ' now we need to check the extrems value , outliers and and detect the outliers';
data _null_;
file print;
put 
"the varibales the we would work on them are/
id/
host_id/
latitude/
longitude/
price/
minimum_nights/
number_of_reviews/
last_review/
reviews_per_month/
calculated_host_listings_count/
availability_365/
Year"
;
run;
title ' Overview of univariate analysis'
ods select Extremeobs Histogram;
proc univariate data=clean.Projectsample plot nextrobs=50;
var latitude
longitude
price
minimum_nights
number_of_reviews
last_review
reviews_per_month
calculated_host_listings_count
availability_365
Year;
histogram/normal;
run;

*****************************************************************************************************;
                                        Title1 ' univariate analysis ';

title ' price is highly skewed to the right and having 0 vlaue does not make sence so we remove the 0 vlaues and rey to plot it again
and try transformation is still skewed then remove the extreme value and ckeck again if still skewe detect the outliers';

data clean.Projectsample1;
set clean.Projectsample( where= (price ne 0));
run;
ods select Extremeobs Histogram;
proc univariate data=clean.Projectsample1 plot nextrobs=50;
var price;
histogram;
run;
title' with this degree of skeweness it is unexpected to have normal chart with log but less try';
data clean.Projectsample2;
set clean.Projectsample1;
price_log= log(price);
price_root= (price+2)**.25;
run;
proc sort data=clean.Projectsample2;
by price;
run; 
ods select Extremeobs Histogram;
proc univariate data=clean.Projectsample2 plot nextrobs=100;
var price price_log price_root;
id id;
histogram;
run;
title' we can see the price log giving better distributions but still is skewed so we tru to remove the extreme values';
*from the observation we can see the cut off is 2000 ;

title "Using PROC SGPLOT to Create a Box Plot";
proc sgplot data=clean.projectsample(keep=id price);
   hbox price ;
run;
proc means data= clean.projectsample;
var price; 
output out=price_range Q1= Q3=   QRange= / autoname;
run;

data clean.price_outliers;
   file print;
   set Clean.projectsample (keep=id price);
   if _n_ = 1 then set price_range;
   if price le price_Q1 - 1.5*price_QRange and not missing(price) or
      price ge price_Q3 + 1.5*price_QRange then
      put "Possible Outlier for id " id "Value of price is " price;
run;
*this showing us upper bound is 1050;
data clean.projectsapmle_price;
set Clean.projectsample;
if _n_=1 then set clean.price_outliers; 
if price ge price_Q1 - 1.5*price_QRange  and
      price le price_Q3 + 1.5*price_QRange;
      price_log= log(price);
price_root= (price+2)**.25;
run;
proc univariate data=clean.Projectsample3 plot nextrobs=100;
var price price_log price_root;
id id;
histogram;
run;
ODS SELECT TestsForNormality Plots;
PROC UNIVARIATE DATA = clean.Projectsample3 NORMAL PLOT;
var price price_log price_root;
RUN;
*let see whta if we remove the extreme values starting frpm 2000 and changing the bound till we get the reasonable distribution;
data clean.Projectsample4;
set clean.Projectsample( where= (price gt 25 and price lt 1100 ));
price_log= log(price);
price_root= (price+2)**.25;
run;
proc sort data=clean.Projectsample4;
by price;
run; 
ods select Extremeobs Histogram;
proc univariate data=clean.Projectsample4 plot nextrobs=100;
var price price_log price_root;
id id;
histogram;
run;
* the situation is much more better ;
*but not good enough we try to cut more ;


ODS SELECT TestsForNormality Plots;
PROC UNIVARIATE DATA = clean.Projectsample4 NORMAL PLOT;
var price price_log price_root;
RUN;


title ' we still can remove from the right but as our distribution is following the normal distribution is good enough';

                   title2 ' our new data set is following data set with new variable price_log';
data clean.projectsapmle;
set Clean.projectsample;
if _n_=1 then set clean.price_outliers; 
if price ge price_Q1 - 1.5*price_QRange  and
      price le price_Q3 + 1.5*price_QRange;
      price_log= log(price);
run;

*********************************************************************************************************;
title ' univariate analysis for reviews_per_month';

title2 'highly skewed data finding extreme values: between (27 and 60)';
proc univariate data=clean.Projectsample plot nextrobs=100;
var reviews_per_month;
id id;
histogram;
run;

proc univariate data=clean.Projectsample plot nextrobs=100;
var reviews_per_month;
id id;
where reviews_per_month lt 27;
histogram;
run;

/*data clean.Projectsample5;
set clean.Projectsample( where= (reviews_per_month lt 27 ));
reviews_per_month_log= log(reviews_per_month);
reviews_per_month_root= (reviews_per_month+2)**.25;
run;

ods select Extremeobs Histogram;
proc univariate data=clean.Projectsample5 plot nextrobs=100;
var reviews_per_month reviews_per_month_log reviews_per_month_root;
id id;
histogram;
run;
*/*wont help;
/*
proc sgplot data=clean.projectsample(keep=id reviews_per_month );
   hbox reviews_per_month ;
run;
proc means data= clean.projectsample;
var reviews_per_month; 
output out=reviews_per_month_range Q1= Q3=   QRange= / autoname;
run;
title 'we start trying to by deleting ouliers reach to the normal distribution but the distribution is not following normal distribution
and it seems more curve in this case we decide to using binning and groping'
data clean.reviews_per_month_outliers;
   file print;
   set Clean.projectsample (keep=id reviews_per_month);
   if _n_ = 1 then set reviews_per_month_range;
   if reviews_per_month le reviews_per_month_Q1 - 2*reviews_per_month_QRange and not missing(reviews_per_month) or
      reviews_per_month ge reviews_per_month_Q3 + 2*reviews_per_month_QRange then
      put "Possible Outlier for id " id "Value of price is " reviews_per_month;
run;
*this showing us upper bound is 1050;
data clean.projectsapmle_reviews_per_month;
set Clean.projectsample (keep=id reviews_per_month);
   if _n_ = 1 then set reviews_per_month_range;
   if reviews_per_month ge reviews_per_month_Q1 - 2*reviews_per_month_QRange and 
      reviews_per_month le reviews_per_month_Q3 + 2*reviews_per_month_QRange;
      reviews_per_month_log= log(reviews_per_month);
reviews_per_month_root= (reviews_per_month+2)**.25;
run;
ODS SELECT TestsForNormality Plots;
PROC UNIVARIATE DATA =  clean.projectsapmle_reviews_per_month NORMAL PLOT;
var reviews_per_month reviews_per_month_log reviews_per_month_root;
RUN;
*/

title ' lets check the frequency of the reviews per month';

proc freq data= clean.projectsample; 
table reviews_per_month;
run;
PROC RANK DATA = clean.projectsample OUT = projectsample_binninglength
          GROUPS = 7;
          where reviews_per_month lt 27;
 VAR reviews_per_month;
 RANKS reviews_per_month_bin;
RUN;


proc sort data=projectsample_binninglength; 
by reviews_per_month_bin; 
run;



proc univariate data=projectsample_binninglength;
var reviews_per_month_bin;
histogram/normal;
run;

*BINNING EQUAL WIDTH , here is 10 width;

Title ' equal with also does not work';

/*proc means data= clean.Projectsample;*(where=(reviews_per_month between  0.5 and 27));
var reviews_per_month;
output out= reviews_min min=/autoname;
run;

DATA projectsample_binningwidth;
 SET clean.projectsample;
 if _n_= 1 then set reviews_min;
 do i= 1 to 10; 
  if reviews_per_month gt (reviews_per_month_min+(i-1)*2.66) and reviews_per_month lt (reviews_per_month_min+(i)*2.66) then 
  reviews_per_month_bin2= round(((reviews_per_month_min+(i-1)*2.66)+(reviews_per_month_min+(i)*2.66))/2);
  end;
RUN;


proc sort data=projectsample_binningwidth; 
by reviews_per_month_bin2; 
run;

proc univariate data=projectsample_binningwidth;
var reviews_per_month_bin2;
histogram/normal;
run;
*/
proc univariate data=clean.projectsample;
var reviews_per_month;
histogram/normal;
run;
Title 'Custome Bining';
data clean.projectsample5; 
     set clean.projectsample; 
     format reviews_per_month_bin2 $15.; 
     
     if  reviews_per_month gt .5 and reviews_per_month lt .8  then reviews_per_month_bin2= '1';
     else if reviews_per_month <1 then reviews_per_month_bin2 = '2';
     else if reviews_per_month<2.5 then reviews_per_month_bin2= '3';
     else                  reviews_per_month_bin2 = '4' ; 
     
run; 
proc sgplot data=clean.projectsample5;
vbar reviews_per_month_bin2;
run;






*Our new data set is ;

Title 'new data set';
data clean.projectsample; 
     set clean.projectsample(where=(reviews_per_month gt .5)); 
     format reviews_per_month_bin2 $15.; 
     
     if  reviews_per_month gt .5 and reviews_per_month lt .8  then reviews_per_month_bin2= '1';
     else if reviews_per_month <1 then reviews_per_month_bin2 = '2';
     else if reviews_per_month<2.5 then reviews_per_month_bin2= '3';
     else                  reviews_per_month_bin2 = '4' ; 
     
run; 



****************************************************************************************************;

title2 'calculated_host_listings_count';
proc univariate data=clean.Projectsample plot nextrobs=100;
var calculated_host_listings_count;
id id;
histogram;
run;
 *for this we do also binning ;
 data clean.projectsample6; 
     set clean.projectsample; 
     format cal_host_list_count_bin $15.; 
     if calculated_host_listings_count <2 then cal_host_list_count_bin = '1';
      else  if  calculated_host_listings_count ge 2 and calculated_host_listings_count le 14  then cal_host_list_count_bin= '2';
     else                  cal_host_list_count_bin = '3' ; 
     
run; 
 
proc sgplot data=clean.projectsample6;
vbar cal_host_list_count_bin;
run;

* update data set;
 data clean.projectsample; 
     set clean.projectsample; 
     format cal_host_list_count_bin $15.; 
     if calculated_host_listings_count <2 then cal_host_list_count_bin = '1';
      else  if  calculated_host_listings_count ge 2 and calculated_host_listings_count le 14  then cal_host_list_count_bin= '2';
     else                  cal_host_list_count_bin = '3' ; 
     
run; 


*******************************************************************************************************;
title2 'availability_365';


proc univariate data=clean.Projectsample plot nextrobs=100;
var availability_365;
id id;
where  availability_365 gt 30 and availability_365 lt 300;
histogram;
run;
data clean.projectsapmle1;
set Clean.projectsample; 
where  availability_365 gt 30 and availability_365 lt 300;
 
     availability_365_log= log(availability_365);
run;

proc univariate data=clean.projectsapmle1 plot nextrobs=100;
var availability_365 availability_365_log;
id id;

histogram;
run;


/* trying to  remove outliers , this also did not work;
proc means data=clean.Projectsample noprint ;
   var availability_365;
   where availability_365 not in (0,365); 
   output out=Mean_Std(drop=_type_ _freq_)
          mean=
          std= / autoname;
run;

title "Outliers for HR Based on 2 Standard Deviations";
data _null_;
   file print;
   set clean.Projectsample(keep=id  availability_365);
   ***bring in the means and standard deviations;
   if _n_ = 1 then set Mean_Std;
   if availability_365 lt availability_365_Mean - 1.5*availability_365_StdDev and not missing(availability_365)
      or availability_365 gt availability_365_Mean + 1.5*availability_365_StdDev then put id= availability_365=;
run;
data _null_;
   file print;
   set clean.Projectsample(keep=id  availability_365);
   ***bring in the means and standard deviations;
   if _n_ = 1 then set Mean_Std;
   if availability_365 lt availability_365_Mean - 1.5*availability_365_StdDev and not missing(availability_365)
      or availability_365 gt availability_365_Mean + 1.5*availability_365_StdDev then put id= availability_365=;
run;
data  clean.projectsapmle_availability_365;
 
   set clean.Projectsample(keep=id  availability_365);
   ***bring in the means and standard deviations;
   if _n_ = 1 then set Mean_Std;
   if availability_365 gt availability_365_Mean - 1.5*availability_365_StdDev and
      availability_365 lt availability_365_Mean + 1.5*availability_365_StdDev ;
run;
ODS SELECT TestsForNormality Plots;
PROC UNIVARIATE DATA = clean.projectsapmle_availability_365 NORMAL PLOT;
var availability_365 ;
RUN;





proc means data= clean.projectsample;
var availability_365; 
where availability_365 not in (0, 365);
output out=availability_365_range Q1= Q3=   QRange= / autoname;
run;

data _NULL_;
   file print;
   set Clean.projectsample (keep=id availability_365);
   if _n_ = 1 then set availability_365_range;
   if availability_365 le availability_365_Q1 - 2*availability_365_QRange and not missing(availability_365) or
      availability_365 ge availability_365_Q3 + 2*availability_365_QRange then
      put "Possible Outlier for id " id "Value of availability_365 is " availability_365;
run;
*this showing us upper bound is 1050;
data clean.projectsapmle_availability_365;
set Clean.projectsample (where= (availability_365 ne 0));
if _n_=1 then set clean.availability_365_outliers; 
if availability_365 ge availability_365_Q1 - 1.5*availability_365_QRange  and
      availability_365 le availability_365_Q3 + 1.5*availability_365_QRange;
run;
proc univariate data=clean.projectsapmle_availability_365 plot nextrobs=100;
var availability_365 ;
id id;
histogram;
run;
ODS SELECT TestsForNormality Plots;
PROC UNIVARIATE DATA = clean.Projectsample3 NORMAL PLOT;
var availability_365 availability_365_log availability_365_root;
RUN;
*/


proc univariate data=clean.Projectsample plot nextrobs=100;
var minimum_nights;
id id;
where  minimum_nights lt 18;
histogram;
run;
*this shows this data shoud be grouped;


Title 'new data set';
data clean.projectsample; 
     set clean.projectsample; 
     format minimum_nights_bin2 $15.; 
     
     if  minimum_nights le 1  then minimum_nights_bin2= 'one-night';
     else if minimum_nights le 2 then minimum_nights_bin2 = 'two-night';
     else if minimum_nights le 3 then minimum_nights_bin2= 'three-night';
      else if minimum_nights le 4 then minimum_nights_bin2= 'four-night';
       else if minimum_nights le 5 then minimum_nights_bin2= 'five-night';
     else                 minimum_nights_bin2 = 'longterm' ; 
     
run; 
proc sgplot data=clean.Projectsample1;
vbar minimum_nights_bin2;
run;

******************************************************************************************************;

*year;

proc print data=clean.Projectsample;
var year; run;

proc sgplot data=clean.Projectsample;
vbar year;
run;

data clean.projectsample; 
     set clean.projectsample; 
     format year_bin $15.; 
     
     if  year ge 2019  then year_bin2= 'recent';
     else  year_bin2 = 'dated' ; 
     
run; 
proc sgplot data=clean.Projectsample;
vbar year_bin2;
run;
*************************************************************************************************;
*last review;

Title 'new data set';
data clean.projectsample; 
     set clean.projectsample; 
     format last_review_bin2 $15.; 
     
     if  last_review le '15jan2019'd  then last_review_bin2= 'very_old';
   
     if  last_review gt '15jan2019'd  then last_review_bin2= last_review_bin2;
run; 
proc sgplot data=clean.Projectsample;
vbar  last_review_bin2;
run;

*these two are good enough;
proc univariate data=clean.Projectsample plot nextrobs=100;
var latitude
longitude
histogram;
run;