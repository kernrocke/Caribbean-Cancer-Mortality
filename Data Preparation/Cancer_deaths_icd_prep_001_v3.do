cls

** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends"
log using "Log files\Data Preparation\Cancer_deaths_icd_prep", replace

**  GENERAL DO-FILE COMMENTS
**  program:		Cancer_deaths_icd_prep_001_v3.do
**  project:      	Caribbean Cancer mortality trends 
**  author:       	Rocke,Sobers&Hambleton\ 10-OCT-2018
**  task:          	Preparation of WHO mortality dataset


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200


use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\icd10combine.dta", clear


** Original WHO format --> sex
** We will recode this later to match the UN ordering (female first)
label define sex 1 "male" 2 "female" 9 "not specified", modify
label values sex sex

** AGE FORMAT
rename frmat af
label define af 	0 "24 groups: 0,1,2,3,4,5y...,95+" 	///
					1 "22 groups: 0,1,2,3,4,5y...,85+" 	///
					2 "19 groups: 0,1-4,5y...,85+" 	///
					3 "20 groups: 0,1,2,3,4,5y...,75+" 	///
					4 "17 groups: 0,1-4,5y...,75+" 	///
					5 "16 groups: 0,1-4,5y...,70+" 	///
					6 "15 groups: 0,1-4,5y...,65+" 	///
					7 "10 groups: 0,1-4,10y...,75+" ///
					8 "09 groups: 0,1-4,5y...,65+" ///
					9 "no age grouping", modify
label values af af			
label var af "Age stratification of death counts"

** INFANT AGE format
rename im_frmat iaf
label define iaf 	1 "4 groups: 0,1-6d,7-27d,28-365d"	///
					2 "3 groups: 0-6d,7-27d,28-365d" 	///
					8 "1 group: 0-365d"					///
					9 "no age grouping", modify
label values iaf iaf			
label var iaf "Age stratification of infant death counts"

** Labelling the death variables
label var deaths1 "Deaths at all ages"
label var deaths2 "Deaths at age 0 year"
label var deaths3 "Deaths at age 1 year"
label var deaths4 "Deaths at age 2 years"
label var deaths5 "Deaths at age 3 years"
label var deaths6 "Deaths at age 4 years"
label var deaths7 "Deaths at age 5-9 years"
label var deaths8 "Deaths at age 10-14 years"
label var deaths9 "Deaths at age 15-19 years"
label var deaths10 "Deaths at age 20-24 years"
label var deaths11 "Deaths at age 25-29 years"
label var deaths12 "Deaths at age 30-34 years"
label var deaths13 "Deaths at age 35-39 years"
label var deaths14 "Deaths at age 40-44 years"
label var deaths15 "Deaths at age 45-49 years"
label var deaths16 "Deaths at age 50-54 years"
label var deaths17 "Deaths at age 55-59 years"
label var deaths18 "Deaths at age 60-64 years"
label var deaths19 "Deaths at age 65-69 years"
label var deaths20 "Deaths at age 70-74 years"
label var deaths21 "Deaths at age 75-79 years"
label var deaths22 "Deaths at age 80-84 years"
label var deaths23 "Deaths at age 85-89 years"
label var deaths24 "Deaths at age 90-94 years"
label var deaths25 "Deaths at age 95 years and above" 
label var deaths26 "Deaths at age unspecified" 
label var im_deaths1 "Infant deaths at age 0 day"
label var im_deaths2 "Infant deaths at age 1-6 days"
label var im_deaths3 "Infant deaths at age 7-27 days"
label var im_deaths4 "Infant deaths at age 28-364 days"

rename country cid
order cid year sex cause af iaf deaths* im_deaths*
sort cid year sex cause

** -----------------------------------------------------------
** INDICATORS FOR VARIOUS CAUSES OF DEATH
** -----------------------------------------------------------


** -----------------------------------------------------------
** Cause of death 0. 	ALL CAUSE
** -----------------------------------------------------------
gen cod00 = 0
** ICD10
replace cod00 = 1 if(regexm(cause, "([A][A][A])")) & list=="104"


** -----------------------------------------------------------
** Cause of Death 61. 	NEOPLASM DISEASE 
**						PROSTATE CANCER
**						     (C61)
** -----------------------------------------------------------
gen cod61 = 0
** ICD10
replace cod61 = 1 if cause == "C61"
replace cod61 = 1 if cause == "C610"
replace cod61 = 1 if cause == "C611"
replace cod61 = 1 if cause == "C612"
replace cod61 = 1 if cause == "C613"
replace cod61 = 1 if cause == "C614"
replace cod61 = 1 if cause == "C615"
replace cod61 = 1 if cause == "C616"
replace cod61 = 1 if cause == "C617"
replace cod61 = 1 if cause == "C618"
replace cod61 = 1 if cause == "C619"


** -----------------------------------------------------------
** Cause of Death 50. 	NEOPLASM DISEASE 
**						BREAST CANCER
**						(C50, D05 & D24)
** -----------------------------------------------------------
gen cod50 = 0
** ICD10
replace cod50 = 1 if cause == "C50"
replace cod50 = 1 if cause == "C500"
replace cod50 = 1 if cause == "C501"
replace cod50 = 1 if cause == "C502"
replace cod50 = 1 if cause == "C503"
replace cod50 = 1 if cause == "C504"
replace cod50 = 1 if cause == "C505"
replace cod50 = 1 if cause == "C506"
replace cod50 = 1 if cause == "C507"
replace cod50 = 1 if cause == "C508"
replace cod50 = 1 if cause == "C509"

replace cod50 = 1 if cause == "D05"
replace cod50 = 1 if cause == "D050"
replace cod50 = 1 if cause == "D051"
replace cod50 = 1 if cause == "D052"
replace cod50 = 1 if cause == "D053"
replace cod50 = 1 if cause == "D054"
replace cod50 = 1 if cause == "D055"
replace cod50 = 1 if cause == "D056"
replace cod50 = 1 if cause == "D057"
replace cod50 = 1 if cause == "D058"
replace cod50 = 1 if cause == "D059"

replace cod50 = 1 if cause == "D24"
replace cod50 = 1 if cause == "D240"
replace cod50 = 1 if cause == "D241"
replace cod50 = 1 if cause == "D242"
replace cod50 = 1 if cause == "D243"
replace cod50 = 1 if cause == "D244"
replace cod50 = 1 if cause == "D245"
replace cod50 = 1 if cause == "D246"
replace cod50 = 1 if cause == "D247"
replace cod50 = 1 if cause == "D248"
replace cod50 = 1 if cause == "D249"



** -----------------------------------------------------------
** Cause of Death 18. 	NEOPLASM DISEASE 
**						COLON/RECTUM/ANAL CANCER
**						(C18-21 & D12)
** -----------------------------------------------------------
gen cod18 = 0
** ICD10
replace cod18 = 1 if cause == "C18"
replace cod18 = 1 if cause == "C180"
replace cod18 = 1 if cause == "C181"
replace cod18 = 1 if cause == "C182"
replace cod18 = 1 if cause == "C183"
replace cod18 = 1 if cause == "C184"
replace cod18 = 1 if cause == "C185"
replace cod18 = 1 if cause == "C186"
replace cod18 = 1 if cause == "C187"
replace cod18 = 1 if cause == "C188"
replace cod18 = 1 if cause == "C189"

replace cod18 = 1 if cause == "C19"
replace cod18 = 1 if cause == "C190"
replace cod18 = 1 if cause == "C191"
replace cod18 = 1 if cause == "C192"
replace cod18 = 1 if cause == "C193"
replace cod18 = 1 if cause == "C194"
replace cod18 = 1 if cause == "C195"
replace cod18 = 1 if cause == "C196"
replace cod18 = 1 if cause == "C197"
replace cod18 = 1 if cause == "C198"
replace cod18 = 1 if cause == "C199"

replace cod18 = 1 if cause == "C20"
replace cod18 = 1 if cause == "C200"
replace cod18 = 1 if cause == "C201"
replace cod18 = 1 if cause == "C202"
replace cod18 = 1 if cause == "C203"
replace cod18 = 1 if cause == "C204"
replace cod18 = 1 if cause == "C205"
replace cod18 = 1 if cause == "C206"
replace cod18 = 1 if cause == "C207"
replace cod18 = 1 if cause == "C208"
replace cod18 = 1 if cause == "C209"

replace cod18 = 1 if cause == "C21"
replace cod18 = 1 if cause == "C210"
replace cod18 = 1 if cause == "C211"
replace cod18 = 1 if cause == "C212"
replace cod18 = 1 if cause == "C213"
replace cod18 = 1 if cause == "C214"
replace cod18 = 1 if cause == "C215"
replace cod18 = 1 if cause == "C216"
replace cod18 = 1 if cause == "C217"
replace cod18 = 1 if cause == "C218"
replace cod18 = 1 if cause == "C219"

replace cod18 = 1 if cause == "D12"
replace cod18 = 1 if cause == "D120"
replace cod18 = 1 if cause == "D121"
replace cod18 = 1 if cause == "D122"
replace cod18 = 1 if cause == "D123"
replace cod18 = 1 if cause == "D124"
replace cod18 = 1 if cause == "D125"
replace cod18 = 1 if cause == "D126"
replace cod18 = 1 if cause == "D127"
replace cod18 = 1 if cause == "D128"
replace cod18 = 1 if cause == "D129"


** -----------------------------------------------------------
** Cause of Death 34. 	NEOPLASM DISEASE 
**						BRONCHUS & LUNG CANCER
**						(C34)
** -----------------------------------------------------------
gen cod34 = 0
** ICD10
replace cod34 = 1 if cause == "C34"
replace cod34 = 1 if cause == "C340"
replace cod34 = 1 if cause == "C341"
replace cod34 = 1 if cause == "C342"
replace cod34 = 1 if cause == "C343"
replace cod34 = 1 if cause == "C344"
replace cod34 = 1 if cause == "C345"
replace cod34 = 1 if cause == "C346"
replace cod34 = 1 if cause == "C347"
replace cod34 = 1 if cause == "C348"
replace cod34 = 1 if cause == "C349"



** -----------------------------------------------------------
** Cause of Death 16. 	NEOPLASM DISEASE 
**						STOMACH CANCER
**						(C16)
** -----------------------------------------------------------
gen cod16 = 0
** ICD10
replace cod16 = 1 if cause == "C16"
replace cod16 = 1 if cause == "C160"
replace cod16 = 1 if cause == "C161"
replace cod16 = 1 if cause == "C162"
replace cod16 = 1 if cause == "C163"
replace cod16 = 1 if cause == "C164"
replace cod16 = 1 if cause == "C165"
replace cod16 = 1 if cause == "C166"
replace cod16 = 1 if cause == "C167"
replace cod16 = 1 if cause == "C168"
replace cod16 = 1 if cause == "C169"


** -----------------------------------------------------------
** Cause of Death 53. 	NEOPLASM DISEASE 
**						CERVIX UTERI CANCER
**						(C53 & D06)
** -----------------------------------------------------------
gen cod53 = 0
** ICD10
replace cod53 = 1 if cause == "C53"
replace cod53 = 1 if cause == "C530"
replace cod53 = 1 if cause == "C531"
replace cod53 = 1 if cause == "C532"
replace cod53 = 1 if cause == "C533"
replace cod53 = 1 if cause == "C534"
replace cod53 = 1 if cause == "C535"
replace cod53 = 1 if cause == "C536"
replace cod53 = 1 if cause == "C537"
replace cod53 = 1 if cause == "C538"
replace cod53 = 1 if cause == "C539"

replace cod53 = 1 if cause == "D06"
replace cod53 = 1 if cause == "D060"
replace cod53 = 1 if cause == "D061"
replace cod53 = 1 if cause == "D062"
replace cod53 = 1 if cause == "D063"
replace cod53 = 1 if cause == "D064"
replace cod53 = 1 if cause == "D065"
replace cod53 = 1 if cause == "D066"
replace cod53 = 1 if cause == "D067"
replace cod53 = 1 if cause == "D068"
replace cod53 = 1 if cause == "D069"


** -----------------------------------------------------------
** Cause of Death 8. 	MIS-CLASSIFICATION (R00 - R00)
** -----------------------------------------------------------
gen cod08 = 0
** ICD10
replace cod08 = 1 if(regexm(cause, "(^R[0-9][0-9])"))

** -----------------------------------------------------------
** Match SEX coding to UN population file
** Fillin-in missing age stratifications to be zero counts
** reshape to long 
** -----------------------------------------------------------

** Recode SEX (switch coding of women and men to Match UN WPP data)
recode sex (2=1) (1=2), test
** NEW UN SEX format
label define sex 1 "female" 2 "male" 9 "not specified", modify
label values sex sex

** Remove INFANT GROUPS
** Drop total deaths (deaths1) to prevent overcount
** These also included in "year 0-4" age grouping
drop deaths1 iaf im*

** Deaths stratified into 24 age groups (all ICD10, some ICD9)
** or in 22 groups (some ICD9 countries)
** The collapse to standard age groups occurs in the next DO file (irh_who_002.do)
** So convert missing to zero counts in preparation for this collapse
replace deaths24 = 0 if deaths24==. 
replace deaths25 = 0 if deaths25==.  


** Start from here to reduce runtime
**save "D:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\who_cancer_deaths_interim_prep_001", replace

**use "D:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\who_cancer_deaths_interim_prep_001", clear


** Create single FACTOR variable for all CODs
gen cod = .
replace cod = 0 	if cod==. & 	cod00==1
replace cod = 61 	if cod==. & 	cod61==1
replace cod = 50 	if cod==. & 	cod50==1
replace cod = 18 	if cod==. & 	cod18==1
replace cod = 34 	if cod34==1
replace cod = 16 	if cod16==1 
replace cod = 53 	if cod53==1 
replace cod = 08 	if cod==. & 	cod08==1
replace cod = 9		if cod==.

label define cod 	0 "all-cause" 61 "Prostate Cancer" 50 "Breast Cancer" 	///
					18 "Colon/Rectal/Anal Cancer" 34 "Bronchus & Lung Cancer" ///
					16 "Stomach Cancer" 53 "Cervix Uteri Cancer" 9 "residual" ///
					8 "Mis-classification"
					
label values cod cod

drop cod00 cod61 cod50 cod18 cod34 cod16 cod53 cod08

keep if cid==2010 |  cid==2025 | cid==2030 | cid==2040 | cid==2045 | cid==2150 | cid==2170 | cid==2210 | cid==2230 | cid==2240 | cid==2260 | cid==2270 | cid==2290 | cid==2300 | cid==2380 | cid==2400 | cid==2420 | cid==2430 | cid==2440 | cid==2455

** WHO age stratification (in years) --> 0,1,2,3,4,...then 5y groups...,95+
** Reshape to long format (to match the population dataset)
egen id= seq()
order id
reshape long deaths, i( id cid year sex cod) j(ag)
sort cid year sex ag cause


***Also need to reassign deaths if age and sex are missing.
****I didn't think I was reassigning deaths I thought I was reassigning *****them to diffferent ages and sexes

** Age groups 25 groups (from 0-24 --> recoded from 2-26)
replace ag = ag-2
** Labelling age
label define ag	0 "0-1"		///
				1 "1-2"		///
				2 "2-3"		///
				3 "3-4"		///
				4 "4-5"		///
				5 "5-9"		///
				6 "10-14"		///
				7 "15-19"		///
				8 "20-24"		///
				9 "25-29"		///
				10 "30-34"		///
				11 "35-39"		///
				12 "40-44"		///
				13 "45-49"		///
				14 "50-54"		///
				15 "55-59"		///
				16 "60-64"		///
				17 "65-69"		///
				18 "70-74"		///
				19 "75-79"		///
				20 "80-84"		///
				21 "85-59"		///
				22 "90-94"		///
				23 "95+"		///
				24 "unspecified", modify
label values ag ag			
label var ag "24 Age groups"

** Save the file reading for further data management
** NB. SEX is in LONG format in this dataset (female=1, male=2)
tempfile female_male both
save "female_male"

** Add female + Male combined (to match UN file)
**  (1=female, 2=male, 3=both)
***so far to make this collapse I have removed cause, cod and af)
***feels wrong I think I will have to go back and reshap before the collapse
collapse (sum) deaths, by(cid year ag cod)
gen sex = 3
save "both"

use "female_male", clear
append using "both"

** NEW UN SEX format
label define sex 1 "female" 2 "male" 3 "both" 9 "not specified", modify
label values sex sex
*drop list
sort cid year sex ag
save "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_001", replace
