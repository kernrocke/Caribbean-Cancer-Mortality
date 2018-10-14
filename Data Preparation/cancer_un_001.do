
** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "D:\Statistical Data Anlaysis\2018\Cancer Mortality Trends"
log using "Log files\Data Preparation\cancer_un_001", replace

**  GENERAL DO-FILE COMMENTS
**  program:		cancer_un_001.do
**  project:      	Caribbean Cancer mortality trends 
**  author:       	Hambleton \ 11-NOV-2017\revised December 15,2016
**  task:          	Prepare UN population dataset 
 
** DO-FILE SET UP COMMANDS. 
version 13
clear all
macro drop _all
set more 1
set linesize 200

** Reading the Caribbean Population data
insheet using "D:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\WPP2017_PopulationByAgeSex_Medium.csv", comma
drop varid variant midperiod agegrp agegrpspan 

** CHECK THIS
** Select 21 Caribbean countries have populations >90k and so have UN LE estimates.
#delimit ;
keep if 	locid==28 | 		/* Antigua & Barbuda */
			locid==533 |        /* Aruba */
			locid==44 |         /* Bahamas */
			locid==52 |         /* Barbados */
			locid==84 |	        /* Belize */
			locid==192 |        /* Cuba */
			locid==531 |        /* Curacao */
			locid==214 |        /* Dominican Republic */
			locid==254 |        /* French Guiana */
			locid==308 |        /* Grenada */
			locid==312 |        /* Guadeloupe */
			locid==328 |        /* Guyana */
			locid==332 |        /* Haiti */
			locid==388 |        /* Jamaica */
			locid==474 |        /* Martinique */
			locid==630 |        /* Puerto Rico */
			locid==662 |        /* Saint Lucia */
			locid==670 |        /* Saint Vincent and Grenadines */
			locid==740 |        /* Suriname */
			locid==780 |        /* Trinidad & Tobago */
			locid==850          /* USVI */
			;    
#delimit cr

** A little dataset house-keeping / file preparation
rename locid cidun 
label var cidun "UN country ID"

** Country ID using the WHO Mortality Database codes
** UN country coding system not same as UN. Code the 1:1 relationship
gen cid = .
replace cid = 2010 if cidun==28		/*Antigua & Barbuda*/
replace cid = 2025 if cidun==533 	/* ARUBA*/
replace cid = 2030 if cidun==44		/* Bahamas */
replace cid = 2040 if cidun==52		/* Barbados */
replace cid = 2045 if cidun==84		/* Belize */
replace cid = 2150 if cidun==192 	/* Cuba */
replace cid = 2330 if cidun==531 	/* CURACAO --> NB this is the cid value for Netherlands Antilles*/
replace cid = 2170 if cidun==214 	/* Dominican Republic */
replace cid = 2210 if cidun==254 	/* French Guiana */
replace cid = 2230 if cidun==308 	/* Grenada */
replace cid = 2240 if cidun==312 	/* Guadeloupe */
replace cid = 2260 if cidun==328 	/* Guyana */
replace cid = 2270 if cidun==332 	/* Haiti */
replace cid = 2290 if cidun==388 	/* Jamaica */
replace cid = 2300 if cidun==474 	/* Martinique */
replace cid = 2380 if cidun==630 	/* Puerto Rico */
replace cid = 2400 if cidun==662 	/* Saint Lucia */
replace cid = 2420 if cidun==670 	/* Saint Vincent and Grenadines */
replace cid = 2430 if cidun==740 	/* Suriname */
replace cid = 2440 if cidun==780 	/* Trinidad and Tobago */
replace cid = 2455 if cidun==850 	/* USVI */
label var cid "WHO country codes"

#delimit ;
label define cid	 	2010 "Antigua and Barbuda"
						2025 "Aruba"
						2030 "Bahamas"
						2040 "Barbados"
						2045 "Belize"
						2150 "Cuba"
						2330 "Curacao"
						2170 "Dominican Republic"
						2210 "French Guiana"
						2230 "Grenada"
						2240 "Guadeloupe"
						2260 "Guyana"
						2270 "Haiti"
						2290 "Jamaica"
						2300 "Martinique"
						2380 "Puerto Rico"
						2400 "Saint Lucia"
						2420 "Saint Vincent and Grenadines"
						2430 "Suriname"
						2440 "Trinidad and Tobago"
						2455 "USVI", modify;
label values cid cid;						
#delimit cr

keep if time>=1990 & time<=2017
rename time year
** Female=1, Male=2, Both=3
rename popfemale pop1
rename popmale pop2
rename poptotal pop3

** Age group creation
**Using the original UN dataset variable "agegrpstart" sidesteps the need for creating age5 from scratch
gen age5 = agegrpstart
recode age5 (0=1) (5=2) (10=3) (15=4) (20=5) (25=6) (30=7) (35=8) (40=9) (45=10) ///
			(50=11) (55=12) (60=13) (65=14) (70=15) (75=16) (80 =17) (85 90 95 100=18), test 
					
** Reshape UN file from Wide to Long --> creates THREE rows per (Country / Year / AGE) combination
** 1 for Female, 2 for Male, 3 for Both
**
** COLLAPSE CHECK. Should be 21 x 23 x 3 x 17 = 24,633 rows
reshape long pop, i(cid year agegrpstart) j(sex)
collapse (sum) pop, by(cid cidun year sex age5)


** Labels
label define sex 1 "female" 2 "male" 3 "both",modify
label values sex sex
label define age5 	1  "0-4"    2 "5-9"    3 "10-14"  4 "15-19"		///
					5  "20-24"  6 "25-29"  7 "30-34"  8 "35-39"		///		
					9  "40-44" 10 "45-49" 11 "50-54" 12 "55-59"		///		
					13 "60-64" 14 "65-69" 15 "70-74" 16 "75-79"		///		
					17 "80-85" 18 "85+", modify

label values age5 age5

** Restrict dataset variables
keep cid cidun year age5 sex pop
order cid cidun year age5 sex pop
sort cid year 

** UN POPULATION FILE FOR MERGING WITH WHO MORTALITY DATABASE
label data "Caribbean population totals using UN WPP (2017 rev): 1990-2016"
save "D:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_pop_001", replace
