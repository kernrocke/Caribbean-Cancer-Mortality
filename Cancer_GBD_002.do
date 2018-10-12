
** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends"
log using "Log files\Data Preparation\Cancer_deaths_GBD_002", replace


**  GENERAL DO-FILE COMMENTS
**  program:		Cancer_GBD_002.do
**  project:      	Caribbean mortality trends 
**  author:       	Rocke&Hambleton \ 10-AUG-2016 \ revised 08-OCT-2018
**  task:          	Prepare WHO mortality dataset
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200
set matsize 1200

***Importing Cancer Deaths from the GBD Database
import delimited "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\IHME-GBD_2016_DATA-8f50e005-1.csv"


***Conversion of string data to nominal categorical form (numeric)
encode cause_name, gen(cancer)
encode location_name , gen(country)
encode age_name, gen(age_cat)

***Recoding country variable to WHO country code format
recode country	(1=2010)	///
				(2=2040)	///
				(3=2045)	///
				(4=2150)	///
				(5=.)	///
				(6=2170)	///
				(7=.)	///
				(8=2230)	///
				(9=2260)	///
				(10=2270)	///
				(11=2290)	///
				(13=2380)	///
				(14=2400)	///
				(15=2420)	///
				(16=2430)	///
				(17=2440)	///
				(18=2455)	///

*Removing GLobal and Dominica from the analysis
drop if country==.
	
label variable year "Year"

label variable country "Country"
rename country cid

label variable age_cat "Age Categories"
rename age_cat ag

label variable cancer "Cancer Type"

***Collapsing file to make the data similar to the WHO mortality data
collapse (rawsum) val, by(location_id year cid cancer ag sex_id)
format %1.0f val
rename val deaths
label variable deaths "Raw deaths"

	
*Renaming variable to match WHO and UN datasets	
rename sex_id sex
label variable sex "Gender"
label define sex 1"Male" 2"Female"
label value sex sex

** Save the file reading for further data management
** NB. SEX is in LONG format in this dataset (female=1, male=2)
tempfile female_male1 both1
save "female_male1"

** Add female + Male combined (to match UN file)
**  (1=female, 2=male, 3=both)
***so far to make this collapse I have removed cause, cod and af)
***feels wrong I think I will have to go back and reshap before the collapse
collapse (sum) deaths, by(cid year ag cancer)
gen sex = 3
save "both1"

use "female_male1", clear
append using "both1"

** NEW UN SEX format
label define sex 1 "female" 2 "male" 3 "both" 9 "not specified", modify
label values sex sex



order cid year sex ag cancer


gen age5 = .
replace age5 = 1 if ag==1
replace age5 = 2 if ag==2
replace age5 = 3 if ag==3
replace age5 = 4 if ag==4
replace age5 = 5 if ag==5
replace age5 = 6 if ag==6
replace age5 = 7 if ag==7
replace age5 = 8 if ag==8
replace age5 = 9 if ag==9
replace age5 = 10 if ag==10
replace age5 = 11 if ag==11
replace age5 = 12 if ag==12
replace age5 = 13 if ag==13
replace age5 = 14 if ag==14
replace age5 = 15 if ag==15
replace age5 = 16 if ag==16
replace age5 = 17 if ag==17
replace age5 = 18 if ag==18 | ag==19 | ag==20

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
					
label value age5 age5
label var age5 "5-year age groups"



** CREATE wider age bands (11 groups)--> may be useful for small island statistics
** 15-24, 25-34, 35-44, 45-54, 55-64, 65-74, 75,84, 85+

gen age10=.
replace age10 = 1 if ag==1 
replace age10 = 2 if ag==2 | ag==3
replace age10 = 3 if ag==4 | ag==5
replace age10 = 4 if ag==6 | ag==7
replace age10 = 5 if ag==8 | ag==9
replace age10 = 6 if ag==10 | ag==11
replace age10 = 7 if ag==12 | ag==13
replace age10 = 8 if ag==14 | ag==15 
replace age10 = 9 if ag==16 | ag==17 
replace age10 = 10 if ag==18 | ag==19  | ag==20 


** Labelling age10
label define age10	1 "1-4"		///
					2 "5-14"		///
					3 "15-24"		///
					4 "25-34"		///
					5 "35-44"		///
					6 "45-54"		///
					7 "55-64"		///
					8 "65-74"		///
					9 "75-84"		///
					10 "85+",modify
label value age10 age10
label var age10 "10-year age groups"

** COLLAPSE. Summation of deaths into (country, year, sex, 5-year age) groups  
collapse (sum) deaths, by(cid year sex cancer age5 age10)


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
order cid cidun year sex age5 age10 ageunk cancer deaths pop

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
save "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_GBD_002", replace

