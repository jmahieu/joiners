					*SESTAT 2003 - 2013*

cd "C:\Users\u0091183\Desktop\Phd\Papers\startup joiners\joiners\"
			  
clear all 
log close _all
set more off 
log using "joiners.log", replace text name(SESTAT_2003_2013_Joiners)

use "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\2003\nscg2003.dta"

append using "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat06.dta"
append using "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat08.dta"
append using "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat10.dta"
append using "C:\Users\u0091183\Desktop\Phd\Datasets\SESTAT\sestat13.dta"
