					*SESTAT 2003 - 2010*
						*SETUP*

cd "C:\Users\u0091183\Desktop\Phd\Papers\startup joiners\joiners\"
			  
clear all 
log close _all
set more off 
log using "joiners_setup.log", replace text name(SESTAT_2003_2013_Joiners_setup)

use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat06.dta"
rename salarp wage06
rename nocprpb nocprpb06
rename nocprmg nocprmg06
save sestat06, replace

use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat08.dta"
rename salarp wage08
rename nocprpb nocprpb08
rename nocprmg nocprmg08
save sestat08, replace

use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat10.dta"
rename salarp wage10
rename n2ocprmg nocprmg10
rename n2ocprpb nocprpb10
save sestat10, replace

clear all 

use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\2003\nscg2003.dta"

rename salarp wage03
rename nocpr nocpr03
rename nocprng nocprng03
rename nocprmg nocprmg03

merge 1:1 refid using sestat06.dta, keepus(wage06 nocprmg06 nocprpb06)
drop if refyr == .
drop _merge
merge 1:1 refid using sestat08.dta, keepus(wage08 nocprmg08 nocprpb08)
drop if refyr == .
drop _merge
merge 1:1 refid using sestat10.dta, keepus(wage10 nocprmg10 nocprpb10)
drop if refyr == .
drop _merge

save joiners.dta, replace




