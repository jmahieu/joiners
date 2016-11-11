						*SESTAT 2003-2013*
							*ANALYSIS*
							
cd "C:\Users\u0091183\Desktop\Phd\Papers\startup joiners\joiners\"
			  
clear all 
log close _all
set more off 
log using "joiners_analysis.log", replace text name(Analysis)
							
use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\2003\nscg2003.dta"

rename salary wage03

merge 1:1 refid using sestat06.dta, keepus(wage06)
drop if refyr == .
drop _merge
merge 1:1 refid using sestat08.dta, keepus(wage08)
drop if refyr == .
drop _merge
merge 1:1 refid using sestat10.dta, keepus(wage10)
drop if refyr == .
drop _merge

// put incorrect wages to missing

foreach i in wage03 wage06 wage08 wage10 {
	replace `i' = . if `i' >= 999998
}




