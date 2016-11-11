						*SESTAT 2003-2013*
							*ANALYSIS*
							
cd "C:\Users\u0091183\Desktop\Phd\Papers\startup joiners\joiners\"
			  
clear all 
log close _all
set more off 
log using "joiners_analysis.log", replace text name(Analysis)
							
use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\2003\nscg2003.dta"

merge 1:1 refid using sestat06.dta, keepus(wage06)
drop if refyr == .
drop _merge
merge 1:1 refid using sestat08.dta, keepus(wage08)
drop if refyr == .
drop _merge
merge 1:1 refid using sestat10.dta, keepus(wage10)
drop if refyr == .
drop _merge



append using "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat06.dta", keep(refid refyr salarp)
append using "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat08.dta", keep(refid refyr salarp)
append using "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat10.dta", keep(refid refyr salarp)
append using "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat13.dta", keep(refid refyr salarp)

sort refid refyr
