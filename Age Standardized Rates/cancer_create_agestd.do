***Creating a standard population file for all ages and for those over age30

** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends"
log using "Log files\Data Preparation\Cancer_create_agestd", replace

**  GENERAL DO-FILE COMMENTS
**  program:		cancer_create_agestd.do
**  project:      	Caribbean mortality trends 
**  author:       	Rocke&Sobers \ 29-AUG-2016 \ revised 09 OCT-2018
**  task:          	Prepare WHO Cancer mortality dataset
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

***
set obs 18
gen pop_std = .

gen age5 = .


**Values entered manually

replace pop_std = 88569 in 1

replace pop_std = 86870 in 2

replace pop_std = 85970 in 3

replace pop_std = 84670 in 4

replace pop_std = 82171 in 5

replace pop_std = 79272 in 6

replace pop_std = 76073 in 7

replace pop_std = 71475 in 8

replace pop_std = 65877 in 9

replace pop_std = 60379 in 10

replace pop_std = 53681 in 11

replace pop_std = 45484 in 12

replace pop_std = 37187 in 13

replace pop_std = 29590 in 14

replace pop_std = 22092 in 15

replace pop_std = 15195 in 16

replace pop_std = 9097 in 17

replace pop_std = 6348 in 18


label variable pop_std "Pop World Standard 2000"


***Also entered manually"


replace age5 = 1 in 1

replace age5 = 2 in 2

replace age5 = 3 in 3

replace age5 = 4 in 4

replace age5 = 5 in 5

replace age5 = 6 in 6

replace age5 = 7 in 7

replace age5 = 8 in 8

replace age5 = 9 in 9

replace age5 = 10 in 10

replace age5 = 11 in 11

replace age5 = 12 in 12

replace age5 = 13 in 13

replace age5 = 14 in 14

replace age5 = 15 in 15

replace age5 = 16 in 16

replace age5 = 17 in 17

replace age5 = 18 in 18

 
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
					18 "85+", modify
					
label values age5 age5			
label var age5 "Age in 5 yr age groups"



*rename age5 age_5

***I only run this command when using dstdize instead of distrate
*rename pop_std pop2

sort age5
save "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop", replace

use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop", clear

**Creating a second world standard population that starts at age 30 for standardization purposes
gen age5_30 = .

replace age5_30 = 1 if age5 == 7

replace age5_30 = 2 if age5 == 8

replace age5_30 = 3 if age5 == 9

replace age5_30 = 4 if age5 == 10

replace age5_30 = 5 if age5 == 11

replace age5_30 = 6 if age5 == 12

replace age5_30 = 7 if age5 == 13

replace age5_30 = 8 if age5 == 14

replace age5_30 = 9 if age5 == 15

replace age5_30 = 10 if age5 == 16

replace age5_30 = 11 if age5 == 17

replace age5_30 = 12 if age5 == 18



label define age5_30	1 "30-34"	///
						2 "35-39"		///
						3 "40-44"	///
						4 "45-49"		///
						5 "50-54"	///
						6 "55-59"		///
						7 "60-64"	///
						8 "65-69"		///
						9 "70-74"	///
						10 "75-79"		///
						11 "80-84"  ///
						12 "85+", modify	
	
label values age5_30 age5_30	
label var age5_30 "Age from 30 in 5 yr age groups"

drop if age5_30 == .

save "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop2", replace


use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop", clear

**Creating a third world standard population that starts at age 30 and ends at 69 for standardization purposes
gen age5_3069 = .

replace age5_3069 = 1 if age5 == 7

replace age5_3069 = 2 if age5 == 8

replace age5_3069 = 3 if age5 == 9

replace age5_3069 = 4 if age5 == 10

replace age5_3069 = 5 if age5 == 11

replace age5_3069 = 6 if age5 == 12

replace age5_3069 = 7 if age5 == 13

replace age5_3069 = 8 if age5 == 14



label define age5_30 1 "30-34"	///
					2 "35-39"	///
					3 "40-44"	///
					4 "45-49"		///
					5 "50-54"	///
					6 "55-59"		///
					7 "60-64"	///
					8 "65-69"		///
					, modify	
	
label values age5_3069 age5_3069	
label var age5_3069 "Adults age 30-69 in 5 yr age groups"

drop if age5_3069 == .

save "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop3", replace

