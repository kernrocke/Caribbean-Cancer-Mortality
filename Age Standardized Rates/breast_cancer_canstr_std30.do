cls
***An age-standardization do file used to populate table 1(adults over 30)
**The file is modified before running analyses based on which sex is being examined

** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends"
log using "Log files\Age Standardization\breast_cancer_canstr_std30", replace

**  GENERAL DO-FILE COMMENTS
**  program:		cervical_cancer_canstr_std30.do
**  project:      	Caribbean Cancer mortality trends 
**  author:       	Rocke&Sobers \ 26-AUG-2016 \ revised 14-OCT-2018
**  task1:          create age-standardised Breast cancer rates
*** task2:          create trend graphs 
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

version 13
clear all
macro drop _all
set more 1
set linesize 200

** Load the prepared dataset
use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_002.dta", clear



drop if pop ==.
drop if age5 == 1 | age5 == 2| age5 == 3 | age5 == 4 | age5 == 5 | age5 == 6

gen pop2 = pop*1000
recast float pop2, force


keep if cod==50 
 ***change format of pop2 to double or float- ensure it is one of these


drop if age10 == 1



*Standardized rates by gender and year for 21 CARICOM countries
** Table title and saved files now have country names instead of country codes
decode cid, gen(country) 
gen country2 = subinstr(country," ","",.)
gen country3 = subinstr(country2,".","",.)
gen country4 = subinstr(country3,"&","",.)
levelsof country4, local(levels2) 
foreach x of local levels2 {
	dis as text " " _newline(4)
	dis as text "TABLE BASED ON COUNTRY = " "`x'"
	distrate deaths pop2 using "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Population Numbers\world_pop2.dta" if country4 == "`x'" , stand(age5) popstand(pop_std) by(year sex cod) mult(100000) format(%8.2f) ///
	saving(data30_`x'.dta, replace) 
	
	}




	


*In this section I am creating a loop for the creation of graphs

	

	foreach x of local levels2 {
	
	
		use data30_`x'.dta,clear
	export excel using "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Mortality Rates\Standardized_30\Breast\Breast_data30_`x'.xls", replace firstrow(variables)	
		keep if sex==3
	gen year10 = year/10
	
	
	lowess rateadj year if cod == 50, gen(lows_`x')nog
	
	dis as text "POISSON BASED ON COUNTRY = " "`x'"

	
	poisson rateadj if cod == 50, irr 
	
	predict preds_`x', ir
	
	sort year
	
	** Graph --> Adjusted Breast Cancer mortality rate for 21 Caribbean countries (women)
#delimit ;
	graph twoway 	
		/// Lowess smoother Breast
		(line lows_`x' year if sex == 3, clw(0.25) clc(gs12) clp("l") )
		/// Poisson  --> Breast
		(line preds_`x' year if sex == 3, clw(0.25) clc(green*0.5) clp("l") )
		,
		
		
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(6) xsize(10)

	    xlab(1995(5)2016, 
	    labs(3) nogrid glc(gs12) angle(0)) 
	    xtitle("Year", size(3) margin(t=5)) 
		xmtick(1995(1)2016)

	    ylab(0(5)50, axis(1) labs(3) nogrid glc(gs12) angle(0) format(%9.0f))
	    ytitle("Mortality Rate (per 100,000)", axis(1) size(3) margin(r=3)) 
		ytick(0(5)50)
		ymtick(0(5)50)
		
		title("`x' ")
		
		legend(nobox size(3) fcolor(gs16) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(1 2 3 4)
		lab(1 "Smoothed Breast rate") 
		lab(2 "Poisson model Breast")
		);
		
#delimit cr

graph save Graph "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\Mortality Rates\Standardized_30\Breast\graph_Breast_`x'.gph", replace

	
	}
