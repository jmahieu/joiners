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

/*	DEMOGRAPHIC VARIABLES */

//age
label var age "Age"

gen sqrdage = age^2
label var sqrdage "Age²"

//generate dummy for male
gen male = 0 if gender == "F"
replace male = 1 if gender == "M"
label var male "Male"

//generate dummy for married
gen mar = 0 if marind == "N"
replace mar = 1 if marind == "Y"
label var mar "Married"

//gen categorical variable for race
gen race = real(racem)
label var race "Race"
label define race 1 "Asian" 2 "American Indian/Alaska Native" 3 "Black" 4 "White" 5 "Native Hawaiian/Other Pacific Islander" 6 "Multiple"

/*	EDUCATION */

//Highest degree type
gen degree = real(dgrdg)
label var degree "Highest degree"

//Carnegie Classification of Institution granting highest degree
gen hdclas = real(hdcarn)
label var hdclas "Carnegie Classification"


/* EMPLOYMENT */

//gen tenure var
gen tenure = refyr - strtyr
label var tenure "Tenure"

//generate dummy for newbus
gen nb = 0
replace nb = 1 if newbus == "Y"
drop newbus
rename nb newbus
label var newbus "Young Firm"

//make numeric vars
foreach i in emsize emtp ndgmemg ndgmeng emsmi emrg emsecdt facadv facben facchal facind facloc facresp facsal facsoc nedtp nocpr nocprng nocprmg indcode waprsm wascsm wapri wasec jobsatis{
 gen `i'_n = real(`i')
 drop `i'
 rename `i'_n `i'
}

*emsize = employer size 
label var emsize "Employer Size"
*nedtp = Employer type [not taking into account if it was an educational institution]
*emtp = Employer type [taking into account educational institutions]
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

//generate dummies for work activities
foreach i in waacc waaprsh wabrsh wacom wadev wadsn waemrl wamgmt waot waprod waqm wasale wasvc watea {
gen `i'_dum = 1
replace `i'_dum = 0 if `i' == "N"
drop `i'
rename `i'_dum `i'
}

//commercial work activities (cf. Elfenbein et al 2010)
*waacc = accounting, finance, contracts
label var waacc "Accounting, Finance, Contracts"
*waemrl = employee relations
label var waemrl "Employee Relations"
*wamgmt = managing or supervising people/projects
label var wamgmt "Managing or Supervising"
*waprod = production, operations, maintenance
label var waprod "Production, Operations, Maintenance"
*waqm = quality or productivity management
label var waqm "Quality or Productivity Management"
*wasale = sales, purchasing, marketing
label var wasale "Sales, Purchasing, Marketing"
*wasvc = professional services
label var wasvc "Professional Services"

//research activities (cf. Elfenbein et al. 2010)
*waaprsh = applied research
label var waaprsh "Applied Research"
*wabrsh = basich research
label var wabrsh "Basic Research"
*wacom = computer applications
label var wacom "Computer Applications"
*wadev = development
label var wadev "Development"
*wadsn = design
label var wadsn "Design"

*waot = Other
label var waot "Other"
*watea = Teaching
label var watea "Teaching"

//generate count of all work activities
gen wan = waacc + waaprsh + wabrsh + wacom + wadev + wadsn + waemrl + wamgmt + waot + waprod + waqm + wasale + wasvc + watea
label var wan "Number of Work Activities"

//gen count of commercial activities (cf. Elfenbein)  
gen cmrcn = waacc + waemrl + wamgmt + waprod + waqm + wasale + wasvc
label var cmrcn "Number of Commercial Activities"

//gen count of research activities (cf. Elfenbein)
gen resn = waaprsh + wabrsh + wacom + wadev + wadsn
label var resn "Number of Research Activities"


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






