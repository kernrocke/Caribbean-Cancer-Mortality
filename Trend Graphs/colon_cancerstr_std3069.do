****This file produces data for colon cancer both, male and female sex cats
****It will also using it as a prep file for the equiplots



** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends"
log using "Log files\Trend Graphs\colon_cancer_canstr_std3069", replace


**  GENERAL DO-FILE COMMENTS
**  program:		colon_cancerstr_std3069.do
**  project:      	Caribbean Cancer mortality trends 
**  author:       	Rocke&Sobers \ 6-April-2017 \ revised 14-OCT-2018
**  task1:          create trend graphs
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

** Load the prepared dataset. using the excel spreadh sheet 
*** with all the adjusted rates in one place
** Load the prepared dataset

use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_002.dta", clear

drop if pop ==.
drop if age5 == 1 | age5 == 2| 
	age5 == 3 | age5 == 4 | 
	age5 == 5 | age5 == 6 |
	age5 == 15 | age5 == 16 | 
	age5 == 17 | age5 == 18 | 
	age5 == 19;

gen pop2 = pop*1000

keep if cod ==18
 ***change format of pop2 to double or float- ensure it is one of these

drop if age10 == 1

keep if sex== 3

**distrate deaths pop2 using "world_pop2.dta" if cid ==2010 | cid ==2030 | cid ==2040 | cid== 2045 | cid==2230 | cid==2260 | cid== 2400 | cid==2420 | cid==2430 | cid==2440,stand(age5) popstand(pop_std) by(year sex) mult(100000) format(%8.2f) saving(agestd2_30.dta, replace) 

distrate deaths pop2 using "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop3.dta" ,stand(age5) popstand(pop_std) by(year cid) mult(100000) format(%8.2f) saving(colon_agestd3i_3069.dta, replace) 

use "colon_agestd3i_3069.dta", clear

****Now for females which is sex =1

use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_002.dta", clear

drop if pop ==.
drop if age5 == 1 | age5 == 2| age5 == 3 | age5 == 4 | age5 == 5 | age5 == 6

gen pop2 = pop*1000

keep if cod ==18
 ***change format of pop2 to double or float- ensure it is one of these

drop if age10 == 1

keep if sex== 1

**distrate deaths pop2 using "world_pop2.dta" if cid ==2010 | cid ==2030 | cid ==2040 | cid== 2045 | cid==2230 | cid==2260 | cid== 2400 | cid==2420 | cid==2430 | cid==2440,stand(age5) popstand(pop_std) by(year sex) mult(100000) format(%8.2f) saving(agestd2_30.dta, replace) 

distrate deaths pop2 using "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop3.dta" ,stand(age5) popstand(pop_std) by(year cid) mult(100000) format(%8.2f) saving(colon_agestd1s_3069.dta, replace) 

use "colon_agestd1s_3069.dta", clear

***And for males which is sex = 2

use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_002.dta", clear

drop if pop ==.
drop if age5 == 1 | age5 == 2| age5 == 3 | age5 == 4 | age5 == 5 | age5 == 6

gen pop2 = pop*1000

keep if cod ==18
 ***change format of pop2 to double or float- ensure it is one of these

drop if age10 == 1

keep if sex== 2

**distrate deaths pop2 using "world_pop2.dta" if cid ==2010 | cid ==2030 | cid ==2040 | cid== 2045 | cid==2230 | cid==2260 | cid== 2400 | cid==2420 | cid==2430 | cid==2440,stand(age5) popstand(pop_std) by(year sex) mult(100000) format(%8.2f) saving(agestd2_30.dta, replace) 

distrate deaths pop2 using "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop3.dta" ,stand(age5) popstand(pop_std) by(year cid) mult(100000) format(%8.2f) saving(colon_agestd2s_3069.dta, replace) 

use "colon_agestd2s_3069.dta", clear



/// Graphs of Colorectum Cancer Mortalitiy for men and women
/// NOTE: For sex-specific graphs, load in the relevant data file

/*
///Women and Men
use "colon_agestd3i_3069.dta", clear

///Women
use "colon_agestd1s_3069.dta", clear

///Men
use "colon_agestd2s_3069.dta", clear

*/

use "colon_agestd3i_3069.dta", clear


foreach x in 2040  {

lowess rateadj year if cid == `x', gen(lowi`x')nog
	
}
poisson rateadj, irr
	
predict predi, ir
	
poisson rateadj, irr

predict preds, ir

fp<year> , power(-2,2): poisson rateadj <year>, irr
predict pred2, ir

sort year


******THE GRAPHS
#delimit ;
	graph twoway 
		/// Observed adjusted rates
		(line rateadj year, clw(0.25) clc(gs13) clp("-#-#"))
		(sc rateadj year, msymbol(O) mc(gs0) msize(1.5))
		/// Poisson 1
		(line predi year, clw(0.25) clc(green) clp("-#-#"))
		/// Poisson 2
		(line pred2 year, clw(0.25) clc(gs12) clp("l") )
		, by (cid)
		/*
		/// Lowess smoother
		(line lowi year, clw(0.25) clc(gs12) clp("l") )
		(sc rateadj year, msymbol(O) mc(gs0) msize(1.5))

		/// Poisson 1 --> year as a linear term
		(line predi year, clw(0.25) clc(orange*0.5) clp("l") )
		, by (cid)
		
		/// Poisson 2 --> year as a fractional polynomial term (-2 -2)
		(line pred2 year if cod==18, clw(0.25) clc(green*0.5) clp("l") )
		,*/
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(6) xsize(10)

	    xlab(1995(5)2016, 
	    labs(3) nogrid glc(gs12) angle(0)) 
	    xtitle("Year", size(3) margin(t=5)) 
		xmtick(1995(1)2016)

	    ylab(0(5)50, axis(1) labs(3) nogrid glc(gs12) angle(0) format(%9.0f))
	    ytitle("Colorectm Cancer Rate (per 100,000)", axis(1) size(3) margin(r=3)) 
		ytick(0(5)50)
		ymtick(0(5)50)
				
		legend(nobox size(3) fcolor(gs16) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(2 3 4 5)
		lab(2 "Directly Age-adjusted") 
		lab(3 "Poisson model 1")
		lab(4 "Poisson model 2")
		///lab(5 "Poisson model 2")
		///lab(6 "Smooth rate")
		);
#delimit cr

graph save Graph "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Graphs\colon_trend_str_3069
