						*SESTAT 2003-2010*
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
label values race race

/*	EDUCATION */

//Highest degree type
gen degree = real(dgrdg)
label var degree "Highest degree"
label define degree 1 "Bachelor's" 2 "Master's" 3 "Doctorate" 4 "Professional"
label values degree degree

//Major Field for highest degree
gen major = real(ndgmemg)
label var major "Major Field"
label define major 1 "Computer and mathematical sciences", add
label define major 2 "Life and related sciences", add
label define major 3 "Physical and related sciences", add
label define major 4 "Social and related sciences", add
label define major 5 "Engineering", add
label define major 6 "S and E-Related Fields", add
label define major 7 "Non-S and E Fields", add
label values major major 

//Carnegie Classification of Institution granting highest degree
gen hdclas = real(hdcarn)
label var hdclas "Carnegie Classification"
label define hdclas 11 "Research University I", add
label define hdclas 12 "Research University II", add
label define hdclas 13 "Doctorate Granting I", add
label define hdclas 14 "Doctorate Granting II", add
label define hdclas 21 "Comprehensive I", add
label define hdclas 22 "Comprehensive II", add
label define hdclas 31 "Liberal Arts I", add
label define hdclas 32 "Liberal Arts II", add
label define hdclas 40 "Two-year institutions", add
label define hdclas 51 "Theological seminaries, bible colleges", add
label define hdclas 52 "Medical schools and medical centers", add
label define hdclas 53 "Other separate health professional schools", add
label define hdclas 54 "Schools of engineering and technology", add
label define hdclas 56 "Schools of art, music, and design", add
label define hdclas 57 "Schools of law", add
label define hdclas 59 "Other specialized institutions", add
label define hdclas 60 "Indian Tribal Institutions", add
label values hdclas hdclas


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
foreach i in emsize emtp ndgmemg ndgmeng emsmi emrg emsecdt facadv facben facchal facind facloc facresp facsal facsoc indcode lfstat nedtp nocpr nocprng nocprmg waprsm wascsm wapri wasec jobsatis{
 gen `i'_n = real(`i')
 drop `i'
 rename `i'_n `i'
}

*emsize = employer size 
label var emsize "Employer Size"
label define emsize 1 "<10" 2 "10-24" 3 "25 - 99" 4 "100 - 499" 5 "500 - 999" 5 "500 - 999" 6 "1000 - 4999" 7 "5000 - 24999" 8 ">25000"
label values emsize emsize

*nedtp = Employer type [not taking into account if it was an educational institution]
*emtp = Employer type [taking into account educational institutions]
*emsmi = Employment status [same job/employer?], current and previous reference weeks
*emrg = Region code for employer
label var emrg "Employer Region"
*emsecdt = Employer sector [detailed codes]
label var emsecdt "Employer Sector"
label define emsecdt 11 "4-yr coll/univ; med schl; univ. res. inst.", add
label define emsecdt 12 "2-yr coll/pre-college institutions", add
label define emsecdt 21 "Bus/Ind, for-profit", add
label define emsecdt 22 "Bus/ind, self-employd, not-incorporated", add
label define emsecdt 23 "Bus/Ind, non-profit", add
label define emsecdt 31 "Federal government", add
label define emsecdt 32 "State/Local government", add
label values emsecdt emsecdt

*facadv = Importance of job"s opportunities for advancement
label var facadv "Importance of job's opportunities for advancement"
*facben = Importance of job"s benefits
label var facben "Importance of job's benefits"
*facchal = Importance of job"s intellectual challenge
label var facchal "Importance of job's intellectual challenge"
*facind = Importance of job"s degree of independence
label var facind "Importance of job's degree of independence"
*facloc = Importance of job"s location
label var facloc "Importance of job's location"
*facresp = Importance of job"s level of responsibility
label var facresp "Importance of job's level of responsibility"
*facsal = Importance of job's salary
label var facsal "Importance of job's salary"
*facsoc = Importance of job's contribution to society
label var facsoc "Importance of job's contribution to society"

foreach i in facadv facben facchal facind facloc facresp facsal facsoc {
	label define `i' 1 "Very important" 2 "Somewhat important" 3 "Somewhat unimportant" 4 "Not important at all"
	label values `i' `i'
}

*indcode = Census industry code for employer
rename indcode industry
label var industry "Industry"
label define industry 170 "Crop production", add
label define industry 180 "Animal production", add
label define industry 190 "Forestry except logging", add
label define industry 270 "Logging", add
label define industry 280 "Fishing, hunting, and trapping", add
label define industry 290 "Support activities for agriculture and forestry", add
label define industry 370 "Oil and gas extraction", add
label define industry 380 "Coal mining", add
label define industry 390 "Metal ore mining", add
label define industry 470 "Nonmetallic mineral mining and quarrying", add
label define industry 480 "Not specified type of mining", add
label define industry 490 "Support activities for mining", add
label define industry 570 "Electric power generation", add
label define industry 580 "Natural gas distribution", add
label define industry 590 "Electric and gas, and other combinations", add
label define industry 670 "Water, steam, air-conditioning, and irrigation systems", add
label define industry 680 "Sewage treatment facilities", add
label define industry 690 "Not specified utilities", add
label define industry 770 "Construction", add
label define industry 1070 "Animal food, grain and oilseed milling", add
label define industry 1080 "Sugar and confectionery products", add
label define industry 1090 "Fruit and vegetable preserving and specialty food", add
label define industry 1170 "Dairy product manufacturing", add
label define industry 1180 "Animal slaughtering and processing", add
label define industry 1190 "Retail bakeries", add
label define industry 1270 "Bakeries, except retail", add
label define industry 1280 "Seafood and other miscellaneous foods", add
label define industry 1290 "Not specified food industries", add
label define industry 1370 "Beverage manufacturing", add
label define industry 1390 "Tobacco manufacturing", add
label define industry 1470 "Fiber, yarn, and thread mills", add
label define industry 1480 "Fabric mills, except knitting", add
label define industry 1490 "Textile and fabric finishing and coating mills", add
label define industry 1570 "Carpet and rug mills", add
label define industry 1590 "Textile product mills, except carpets and rugs", add
label define industry 1670 "Knitting mills", add
label define industry 1680 "Cut and sew apparel manufacturing", add
label define industry 1690 "Apparel accessories and other apparel manufacturing", add
label define industry 1770 "Footwear manufacturing", add
label define industry 1790 "Leather tanning and products, except footwear", add
label define industry 1870 "Pulp, paper, and paperboard mills", add
label define industry 1880 "Paperboard containers and boxes", add
label define industry 1890 "Miscellaneous paper and pulp products", add
label define industry 1990 "Printing and related support activities", add
label define industry 2070 "Petroleum refining", add
label define industry 2090 "Miscellaneous petroleum and coal products", add
label define industry 2170 "Resin, synthetic rubber and fibers, and filaments", add
label values industry industry

*lfstat = Labor force status
label var lfstat "Labor force status"
label define lfstat 1 "Employed" 2 "Unemployed" 3 "Not in Labor Force"
label values lfstat lfstat


*nocpr = Job code for principal job - best code
label var nocpr "Principal Job"

*nocprmg = Occupation Major Group
label var nocprmg "Occupation Major Group"
label define nocprmg 1 "Computer and mathematical scientists", add
label define nocprmg 2 "Biological, agricultural and other life scientists", add
label define nocprmg 3 "Physical and related scientists", add
label define nocprmg 4 "Social and related scientists", add
label define nocprmg 5 "Engineers", add
label define nocprmg 6 "S and E related occupations", add
label define nocprmg 7 "Non-S and E Occupations", add
label values nocprmg nocprmg

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
label values emplr emplr

/* SALARY */

// put incorrect wages to missing
foreach i in wage03 wage06 wage08 wage10 {
	replace `i' = . if `i' >= 999998
}

//generate lnwage
foreach i in wage03 wage06 wage08 wage10 {
	gen ln`i' = log(`i') if `i' > 0
	replace ln`i' = 0 if `i' == 0
}

//gen log yearly wage growth

gen dlnwage = (lnwage10 - lnwage03)/7 if wage10 != .
replace dlnwage = (lnwage08 - lnwage03)/5 if dlnwage == . & wage08 != .
replace dlnwage = (lnwage06 - lnwage03)/3 if dlnwage == . & wage06 != .


save joinersc.dta, replace






