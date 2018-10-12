***An age-standardization do file to create age-standardized Cancer Mortality rates for all Caribbean countries
***For ages 30-69
** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Analysis\cancer_canstr_3069"
log using "cancer_agestd3069_count", replace

**  GENERAL DO-FILE COMMENTS
**  program:		irh_age_std.do
**  project:      	Caribbean mortality trends 
**  author:       	Rocke&Sobers \ 26-AUG-2016 \ revised 10 OCT 2018
**  task:          	create age-standardised mortality rates 
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 255

** Load the prepared dataset
use "G:\Statistical Data Anlaysis\2018\Cancer Mortality Trends\Data\carib_cancer_deaths_002", clear

keep if cid ==2010 | cid ==2030 | cid ==2040 
**| cid== 2045 | cid==2230 | cid==2260 | cid== 2400 | cid==2420 | cid==2430 | cid==2440

drop if pop ==.
drop if age5 == 1 | age5 == 2| age5 == 3 | age5 == 4 | age5 == 5 | age5 == 6 ///
			| age5 == 15 | age5 == 16 | age5 == 17 | age5 == 18 | age5 == 19

gen pop2 = pop*1000

keep if cod ==102 | cod == 4
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
	distrate deaths pop2 using "world_pop3.dta" if country4 == "`x'", stand(age5) popstand(pop_std) by(year sex cod) mult(100000) format(%8.2f) ///
	saving(data3069_`x'.dta, replace) 
	}




	
	/****In this section I am creating a loop for the creation of graphs

	foreach x of local levels2 {
		use data3069_`x'.dta,clear
		
		export excel using "C:\analysis\a001_phd\data3069_`x'.xls", replace firstrow(variables)	
	  gen year10 = year/10
		
		keep if sex==3 
	
	lowess rateadj year if cod == 102, gen(lowi_`x') nog
	
	lowess rateadj year if cod == 4, gen(lows_`x')nog
	
	dis as text "POISSON BASED ON COUNTRY = " "`x'"

	poisson rateadj year10 if cod == 102, irr

	predict predi_`x', ir
	
	poisson rateadj year10 if cod == 4, irr
	
	predict preds_`x', ir

	sort year
/*
** Graph --> Adjusted IHD and Stroke mortality rate for Antigua (women and men combined)
#delimit ;
	graph twoway 	
		/// Lowess smoother IHD
		(line lowi_`x' year if sex == 2, clw(0.25) clc(gs13) clp("-#-#") )
		///(sc rateadj year if sex == 2, msymbol(O) mc(gs0) msize(1.5))
		/// Lowess smoother Stroke
		(line lows_`x' year if sex == 2, clw(0.25) clc(gs12) clp("l") )
		/// Poisson 1 --> IHD
		(line predi_`x' year if sex == 2, clw(0.25) clc(orange*0.5) clp("l") )
		/// Poisson 2 --> Stroke
		(line preds_`x' year if sex == 2, clw(0.25) clc(green*0.5) clp("l") )
		,
		
		
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(6) xsize(10)

	    xlab(1990(5)2010, 
	    labs(3) nogrid glc(gs12) angle(0)) 
	    xtitle("Year", size(3) margin(t=5)) 
		xmtick(1990(1)2012)

	    ylab(20(20)400, axis(1) labs(3) nogrid glc(gs12) angle(0) format(%9.0f))
	    ytitle("Mortality Rate (per 100,000)", axis(1) size(3) margin(r=3)) 
		ytick(20(10)400)
		ymtick(15(5)400)
		
		title("`x' CHD and Stroke Rates")
		
		legend(nobox size(3) fcolor(gs16) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(1 2 3 4)
		lab(1 "Smoothed IHD rate") 
		lab(2 "Smoothed stroke rate")
		lab(3 "Poisson model IHD")
		lab(4 "Poisson model Stroke")
		);
		
#delimit cr

graph save Graph "C:\Users\Pshawn\Documents\IHD trends\Results\Graphs3069\graphmales_`x'.gph", replace
*/
	}


	

