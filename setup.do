					*SESTAT 2003 - 2010*
						*SETUP*

cd "C:\Users\u0091183\Desktop\"
			  
clear all 
log close _all
set more off 
log using "joiners_setup.log", replace text name(SESTAT_2003_2013_Joiners_setup)

use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat06.dta"
rename salarp wage06
save sestat06, replace

use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat08.dta"
rename salarp wage08
save sestat08, replace

use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat10.dta"
rename salarp wage10
save sestat10, replace




