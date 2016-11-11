						*SESTAT 2003-2013*
							*CLEANING*
							
cd "C:\Users\u0091183\Desktop\Phd\Papers\startup joiners\joiners\"
			  
clear all 
log close _all
set more off 
log using "joiners_cleaning.log", replace text name(Cleaning)

use joiners.dta
							

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

						CLEANING AND LABELING
			
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

//generate dummy for newbus
gen nb = 0
replace nb = 1 if newbus == "Y"
drop newbus
rename nb newbus
label var newbus "Young Firm"

//make numeric vars
foreach i in emsize emtp dgrdg ndgmemg ndgmeng emsmi emrg emsecdt facadv facben facchal facind facloc facresp facsal facsoc nedtp nocpr nocprng nocprmg indcode waprsm wascsm wapri wasec jobsatis{
 gen `i'_n = real(`i')
 drop `i'
 rename `i'_n `i'
}

*emsize = employer size 
label var emsize "Employer Size"
*nedtp = Employer type [not taking into account if it was an educational institution]
*emtp = Employer type [taking into account educational institutions]
*dgrdg = Highest degree type
label var dgrdg "Highest degree"
*emsmi = Employment status [same job/employer?], current and previous reference weeks
*emrg = Region code for employer
label var emrg "Employer Region"
*emsecdt = Employer sector [detailed codes]
*facadv = Importance of job"s opportunities for advancement
*facben = Importance of job"s benefits
*facchal = Importance of job"s intellectual challenge
*facind = Importance of job"s degree of independence
*facloc = Importance of job"s location
*facresp = Importance of job"s level of responsibility
*facsal = Importance of job's salary
*facsoc = Importance of job's contribution to society
*indcode = Census industry code for employer
label var indcode "Industry"
*nocpr = Job code for principal job - best code
label var nocpr "Principal Job"
*nocprmg = Occupation Major Group
label var nocprmg "Occupation Major Group"
*waprsm = Summarized primary work activity
*wascsm = Summarized secondary work activity
*wapri = work activity spent most hours on
*wasec = work activity spent second most hours on

//create variable employer type: 1= startup, 2 = small established firm, 3 = large established firms
gen emplr = .
replace emplr = 1 if nedtp > 2 & newbus == 1 & emsize < 4
replace emplr = 2 if nedtp > 2 & newbus == 0 & emsize < 4
replace emplr = 3 if nedtp > 2 & newbus == 0 & emsize >= 4

label var emplr "Employer Type"
label define emplr 1 "Startup" 2 "Small Established" 3 "Large Established"

// put incorrect wages to missing
foreach i in wage03 wage06 wage08 wage10 {
	replace `i' = . if `i' >= 999998
}

save joinersc.dta, replace






