

version 13
clear all
macro drop _all
set more 1
set linesize 200
set matsize 1200

import delimited "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\IHME-GBD_2016_DATA-4309b69d-1.csv"


***Conversion of string data to nominal categorical form (numeric)
encode cause_name, gen(cancer)
encode location_name , gen(country)
encode age_name, gen(age_cat)

***Recoding country variable to WHO country code format
recode country	(1=2010)	///
				(2=2025)	///
				(3=2010)	///
				(4=2010)	///
				(5=2010)	///
				(6=2010)	///
				(7=2010)	///
				(8=2010)	///
				(9=2010)	///
				(10=2010)	///
				(11=2010)	///
				(13=2010)	///
				(14=2010)	///
				(15=2010)	///
				(16=2010)	///
				(17=2010)	///
				(18=2010)	///
				(1=2010)	///
		

rename sex_id sex
label variable sex "Gender"
label define sex 1"Male" 2"Female"
label value sex sex
order year country sex age_cat cancer
label variable year "Year"
label variable country "Country"
label variable age_cat "Age Categories"
label variable cancer "Cancer Type"
collapse (rawsum) val, by(location_id year country cancer age_cat)
format %1.0f val
rename val deaths
label variable deaths "Raw deaths"

** CREATE wider age bands (11 groups)--> may be useful for small island statistics
** 15-24, 25-34, 35-44, 45-54, 55-64, 65-74, 75,84, 85+

gen age10=.
replace age10 = 1 if age_cat==1 | age_cat==2
replace age10 = 2 if age_cat==3 | age_cat==4
replace age10 = 3 if age_cat==5 | age_cat==6
replace age10 = 4 if age_cat==7 | age_cat==8
replace age10 = 5 if age_cat==9 | age_cat==10
replace age10 = 6 if age_cat==11 | age_cat==12
replace age10 = 7 if age_cat==13 | age_cat==14
replace age10 = 8 if age_cat==15 | age_cat==16 | age_cat==16

** Labelling age10
label define age10	1 "15-24"		///
					2 "25-34"		///
					3 "35-44"		///
					4 "45-54"		///
					5 "55-64"		///
					6 "65-74"		///
					7 "75-84"		///
					8 "85+",modify
label values age10 age10			
label var age10 "10-year age groups"


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

#delimit ;
#delimit cr


