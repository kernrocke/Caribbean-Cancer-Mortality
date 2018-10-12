

** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends"
log using "Log files\Data Preparation\Cancer_deaths_who_002", replace


**  GENERAL DO-FILE COMMENTS
**  program:		Cancer_deaths_icd_prep_002.do
**  project:      	Caribbean mortality trends 
**  author:       	Rocke&Hambleton \ 10-AUG-2016 \ revised 08-OCT-2018
**  task:          	Prepare WHO mortality dataset
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200


** Merging WHO cancer death data with UN population data
use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_001", clear

** CREATE wider age bands (5-year groups, 17 groups + 1 unclassified)--> for merging with UN population data
** 0-4, 5-9, ..... , 80+
gen age5 = .
replace age5 = 1 if ag==0|ag==1|ag==2|ag==3|ag==4
replace age5 = 2 if ag==5
replace age5 = 3 if ag==6
replace age5 = 4 if ag==7
replace age5 = 5 if ag==8
replace age5 = 6 if ag==9
replace age5 = 7 if ag==10
replace age5 = 8 if ag==11
replace age5 = 9 if ag==12
replace age5 = 10 if ag==13
replace age5 = 11 if ag==14
replace age5 = 12 if ag==15
replace age5 = 13 if ag==16
replace age5 = 14 if ag==17
replace age5 = 15 if ag==18
replace age5 = 16 if ag==19
replace age5 = 17 if ag==20
replace age5 = 18 if ag==21 | ag==22 | ag==23
replace age5 = 19 if ag==24
** Labelling age5
label define age5	1 "0-4"		///
					2 "5-9"		///
					3 "10-14"	///
					4 "15-19"		///
					5 "20-24"	///
					6 "25-29"		///
					7 "30-34"	///
					8 "35-39"		///
					9 "40-44"	///
					10 "45-49"		///
					11 "50-54"	///
					12 "55-59"		///
					13 "60-64"	///
					14 "65-69"		///
					15 "70-74"	///
					16 "75-79"		///
					17 "80-84"	///
					18 "85+" ///
					19 "unk", modify
label values age5 age5			
label var age5 "5-year age groups"


** CREATE wider age bands (11 groups)--> may be useful for small island statistics
** 0-1, 1-4, 5-14, 15-24, 25-34, 35-44, 45-54, 55-64, 65-74, 75,84, 85+
gen age10 = .
replace age10 = 1 if ag==0
replace age10 = 2 if ag==1|ag==2|ag==3|ag==4
replace age10 = 3 if ag==5 | ag==6
replace age10 = 4 if ag==7 | ag==8
replace age10 = 5 if ag==9 | ag==10
replace age10 = 6 if ag==11 | ag==12
replace age10 = 7 if ag==13 | ag==14
replace age10 = 8 if ag==15 | ag==16
replace age10 = 9 if ag==17 | ag==18
replace age10 = 10 if ag==19 | ag==20
replace age10 = 11 if ag==21|ag==22|ag==23 
replace age10 = 12 if ag == 24
** Labelling age10
label define age10	1 "0-1"		///
					2 "1-4"		///
					3 "5-14"		///
					4 "15-24"		///
					5 "25-34"		///
					6 "35-44"		///
					7 "45-54"		///
					8 "55-64"		///
					9 "65-74"		///
					10 "75-84"		///
					11 "85+"        ///
					12 "unk",modify
label values age10 age10			
label var age10 "10-year age groups"


** COLLAPSE. Summation of deaths into (country, year, sex, 5-year age) groups  
collapse (sum) deaths, by(cid year sex cod age5 age10)


** -------------------------------------------------------------
** Merge Annual Death and Population data
merge m:1 cid year sex age5 using "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_pop_001"
** -------------------------------------------------------------

** Years without death data in WHO Mortality database
** Analysis note: 		Merge=1 occus when death has an unknown age OR
**					When line items of unused causes occurs (the top 6-10 CoDs --> assault, nephrotic, alzheimers etc)
**
**					Merge=2 occurs when there are no mortality information
**					2330 a major contributor = Curacao, which has no moratlity database entry
**					Others = countries with missing years
**					We tabulate the mising years, then drop
drop if cid==2330
** Countries with missing data-years
preserve
	keep if _merge==2
	egen tag = tag(cid year)
	list cid year if tag==1, sepby(cid)
restore
drop if _merge==2

** Merge variable highlights those deaths for which age was unknown
rename _merge ageunk
recode ageunk 3=0
label define ageunk 0 "age known" 1 "age unknown",modify
label values ageunk ageunk
label var ageunk "Deaths for which age was unknown"
order cid cidun year sex age5 age10 ageunk cod deaths pop

#delimit ;
label define cid	 	
						2010 "Antigua and Barbuda"
						2025 "Aruba"
						2030 "Bahamas"
						2040 "Barbados"
						2045 "Belize"
						2150" Cuba"
						2170 "Dominican Republic"
						2210 "French Guiana"
						2230 "Grenada"
						2240 "Guadeloupe"
						2260 "Guyana"
						2270 "Haiti"
						2290 "Jamaica"
						2300 "Martinique"
						2380 "Puerto Rico"
						2400 "St.Lucia"
						2420 "St.Vincent & Grenadines"
						2430 "Suriname"
						2440 "Trinidad & Tobago"
						2455 "USVI"				
						, modify;
	label values cid cid;						
#delimit cr


***Added an additional 5 year age group to give an 85+ group on Aug28

** THIS DATASET IS
** AGE-ADJUSTED
** QUALITY-ADJUSTED 
** Save the final combined deaths + population dataset
save "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_002", replace

