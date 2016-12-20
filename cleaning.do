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

gen age2 = age^2
label var age2 "Age²"

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
qui tab race, gen (race)
label var race1 "Asian"
label var race2 "American Indian/Alaska Native"
label var race3 "Black"
label var race4 "White"
label var race5 "Native Hawaiian/Other Pacific Islander"
label var race6 "Multiple"

//count number of children living in the same household in 2003
foreach i in  ch1218 ch611 ch6 {
	replace `i' = 0 if `i' == 98
}

egen children03 = rsum(ch1218 ch611 ch6) 
label var children03 "Number of children in 2003"

//gen numerical values for # children in 2006-2010
foreach i in children06 children08 children10 {
	gen `i'_n = real(`i')
	drop `i'
	rename `i'_n `i'
	replace `i' = 0 if `i' == 98
}

label var children06 "Number of children in 2006"
label define children 0 "0" 1 "1" 2 "2 or more"
label values children06 children

label var children08 "Number of children in 2008"
label values children08 children

label var children10 "Number of children in 2010"
label values children10 children


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
replace strtyr = . if strtyr == 9998
gen tenure = refyr - strtyr
label var tenure "Tenure (years)"

//generate dummy for newbus
gen nb = .
replace nb = 1 if newbus == "Y"
replace nb = 0 if newbus == "N"
drop newbus
rename nb newbus
label var newbus "Young Firm"

//make numeric vars
foreach i in emsize emsize06 emsize08 emsize10 emtp ndgmemg ndgmeng emsmi emrg emsecdt facadv facben facchal facind facloc facresp facsal facsec facsoc fptind indcode lfstat03 lfstat06 lfstat08 lfstat10 nedtp nocpr03 nocprng03 nocprpb06 nocprpb08 nocprpb10 nocprmg03 nocprmg06 nocprmg08 nocprmg10 waprsm wascsm wapri wasec jobsatis{
 gen `i'_n = real(`i')
 drop `i'
 rename `i'_n `i'
}

*emsize = employer size 
label var emsize "Employer Size"
label define emsize 1 "<10" 2 "10-24" 3 "25 - 99" 4 "100 - 499" 5 "500 - 999" 5 "500 - 999" 6 "1000 - 4999" 7 "5000 - 24999" 8 ">25000"
label values emsize emsize

foreach i in 06 08 10 {
	label var emsize`i' "Employer Size in 20`i'"
	label values emsize`i' emsize
}

*nedtp = Employer type [not taking into account if it was an educational institution]
*emtp = Employer type [taking into account educational institutions]
*emsmi = Employment status [same job/employer?], current and previous reference weeks
*emrg = Region code for employer
label var emrg "Employer Region"
label define emrg 1 "New England", add
label define emrg 2 "Middle Atlantic", add
label define emrg 3 "East North Central", add
label define emrg 4 "West North Central", add
label define emrg 5 "South Atlantic", add
label define emrg 6 "East South Central", add
label define emrg 7 "West South Central", add
label define emrg 8 "Mountain", add
label define emrg 9 "Pacific", add
label define emrg 10 "Europe", add
label define emrg 20 "Asia", add
label define emrg 30 "North America", add
label define emrg 31 "Central America", add
label define emrg 33 "Caribbean", add
label define emrg 37 "South America", add
label define emrg 50 "Oceania", add
label define emrg 55 "Other", add
label values emrg emrg

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

//reshape values for fac* variables so that value 1 corresponds with "Not important at all" 4 corresponds with "Very Important" --> for ordered logit
foreach i in facadv facben facchal facind facloc facresp facsal facsec facsoc {
	gen `i'_n = 1 if `i' == 4
	replace `i'_n = 2 if `i' == 3
	replace `i'_n = 3 if `i' == 2
	replace `i'_n = 4 if `i' == 1
	drop `i'
	rename `i'_n `i'
}

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
*facsec = Importance of job"s security
label var facsec "Importance of job's security"
*facsoc = Importance of job's contribution to society
label var facsoc "Importance of job's contribution to society"


foreach i in facadv facben facchal facind facloc facresp facsal facsoc {
	label define `i' 4 "Very important" 3 "Somewhat important" 2 "Somewhat unimportant" 1 "Not important at all"
	label values `i' `i'
}

*fptind = Full-time/part-time status counting all jobs during reference week
label var fptind "Working full-time"
replace fptind = 0 if fptind == 2

*wkswk = number of weeks yearly salary is based on
replace wkswk = 0 if wkswk == 98
label var wkswk "Number of weeks worked"

foreach i in 06 08 10 {
	gen wkswkp`i'_n = real(wkswkp`i')
	drop wkswkp`i'
	rename wkswkp`i'_n wkswkp`i'
	replace wkswkp`i' = . if wkswkp`i' == 98
}

*principal job: hours per week typically worked
replace hrswk = 0  if hrswk == 98
label var hrswk "Number of hours per week worked"

foreach i in 06 08 10 {
	replace hrswkp`i' = . if hrswkp`i' == 98
}

*indcode = Census industry code for employer
rename indcode industry
replace industry = . if industry >= 9990 //put missing and skipped to missing values
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
label define industry 2180 "Agricultural chemical manufacturing", add
label define industry 2190 "Pharmaceutical and medicine manufacturing", add
label define industry 2270 "Paint, coating, and adhesive manufacturing", add
label define industry 2280 "Soap, cleaning compound, and cosmetics manufacturing", add
label define industry 2290 "Industrial and miscellaneous chemicals", add
label define industry 2370 "Plastics product manufacturing", add
label define industry 2380 "Tire manufacturing", add
label define industry 2390 "Rubber products, except tires, manufacturing", add
label define industry 2470 "Pottery, ceramics, and related products manufacturing", add
label define industry 2480 "Structural clay product manufacturing", add
label define industry 2490 "Glass and glass product manufacturing", add
label define industry 2570 "Cement, concrete, lime, and gypsum product manufacturing", add
label define industry 2590 "Misc nonmetallic mineral product manufacturing", add
label define industry 2670 "Iron and steel mills and steel product manufacturing", add
label define industry 2680 "Aluminum production and processing", add
label define industry 2690 "Nonferrous metal, except aluminum, production and processing", add
label define industry 2770 "Foundries", add
label define industry 2780 "Metal forgings and stampings", add
label define industry 2790 "Cutlery and hand tool manufacturing", add
label define industry 2870 "Structural metals, and tank and shipping container", add
label define industry 2880 "Machine shops", add
label define industry 2890 "Coating, engraving, heat treating and allied activities", add
label define industry 2970 "Ordnance", add
label define industry 2980 "Miscellaneous fabricated metal products manufacturing", add
label define industry 2990 "Not specified metal industries", add
label define industry 3070 "Agricultural implement manufacturing", add
label define industry 3080 "Construction, mining and oil field machinery manufacturing", add
label define industry 3090 "Commercial and service industry machinery manufacturing", add
label define industry 3170 "Metalworking machinery manufacturing", add
label define industry 3180 "Engines, turbines, and power transmission equipment manufacturing", add
label define industry 3190 "Machinery manufacturing, n.e.c.", add
label define industry 3290 "Not specified machinery manufacturing", add
label define industry 3360 "Computer and peripheral equipment manufacturing", add
label define industry 3370 "Communications, audio, and video equipment manufacturing", add
label define industry 3380 "Navigational, measuring, electromedical, and control", add
label define industry 3390 "Electronic component and product manufacturing, n.e.c", add
label define industry 3470 "Household appliance manufacturing", add
label define industry 3490 "Electrical lighting, equipment, and supplies manufacturing", add
label define industry 3570 "Motor vehicles and motor vehicle equipment manufacturing", add
label define industry 3580 "Aircraft and parts manufacturing", add
label define industry 3590 "Aerospace products and parts manufacturing", add
label define industry 3670 "Railroad rolling stock manufacturing", add
label define industry 3680 "Ship and boat building", add
label define industry 3690 "Other transportation equipment manufacturing", add
label define industry 3770 "Sawmills and wood preservation", add
label define industry 3780 "Veneer, plywood, and engineered wood products", add
label define industry 3790 "Prefabricated wood buildings and mobile homes", add
label define industry 3870 "Miscellaneous wood products", add
label define industry 3890 "Furniture and related product manufacturing", add
label define industry 3960 "Medical equipment and supplies manufacturing", add
label define industry 3970 "Toys, amusement, and sporting goods manufacturing", add
label define industry 3980 "Miscellaneous manufacturing, n.e.c.", add
label define industry 3990 "Not specified manufacturing industries", add
label define industry 4070 "Motor vehicles, parts and supplies, merchant wholesalers", add
label define industry 4080 "Furniture and home furnishing, merchant wholesalers", add
label define industry 4090 "Lumber and other construction materials, merchant wholesalers", add
label define industry 4170 "Professional and commercial equipment and supplies, merchant wholesalers", add
label define industry 4180 "Metals and minerals, except petroleum, merchant wholesalers", add
label define industry 4190 "Electrical goods, merchant wholesalers", add
label define industry 4260 "Hardware, plumbing and heating equipment, and supplies merchants wholesalers", add
label define industry 4270 "Machinery, equipment, and supplies, merchant wholesalers", add
label define industry 4280 "Recyclable material, merchant wholesalers", add
label define industry 4290 "Miscellaneous durable goods, merchant wholesalers", add
label define industry 4370 "Paper and paper products, merchant wholesalers", add
label define industry 4380 "Drugs, sundries, and chemical and allied products, merchant wholesalers", add
label define industry 4390 "Apparel, fabrics, and notions, merchant wholesalers", add
label define industry 4470 "Groceries and related products, merchant wholesalers", add
label define industry 4480 "Farm product raw materials, merchant wholesalers", add
label define industry 4490 "Petroleum and petroleum products, merchant wholesalers", add
label define industry 4560 "Alcoholic beverages, merchant wholesalers", add
label define industry 4570 "Farm supplies, merchant wholesalers", add
label define industry 4580 "Miscellaneous nondurable goods, merchant wholesalers", add
label define industry 4590 "Not specified wholesale trade", add
label values industry industry

// gen var covering broad industry classes using NAICS 2002
recode industry (170/290=1) (370/490=2) (570/690=3) (770=4) (1070/3990=5) (4070/4590=6) (4670/5790=7) (6070/6390=8) (6470/6780=9) (6870/6990=10) (7070/7190=11) (7270/7490=12) (7570=13) (7580/7790=14) (7860/7890=15) (7970/8470=16) (8560/8590=17) (8660/8690=18) (8770/9290=19) (9300=20) , gen(bindustry)
label var bindustry "Industry"
label define bindustry 1 "Agriculture, Forestry, Fishing and Hunting", add
label define bindustry 2 "Mining", add
label define bindustry 3 "Utilities", add
label define bindustry 4 "Construction", add
label define bindustry 5 "Manufacturing", add
label define bindustry 6 "Wholesale Trade", add
label define bindustry 7 "Retail Trade", add
label define bindustry 8 "Transportation and Warehousing", add
label define bindustry 9 "Information", add
label define bindustry 10 "Finance and Insurance", add
label define bindustry 11 "Real Estate and Rental and Leasing", add
label define bindustry 12 "Professional, Scientific, and Technical Services", add
label define bindustry 13 "Management of Companies and Enterprises", add
label define bindustry 14 "Administrative and Support and Waste Management and Remediation Services", add
label define bindustry 15 "Educational Services", add
label define bindustry 16 "Health Care and Social Assistance", add
label define bindustry 17 "Arts, Entertainment, and Recreation", add
label define bindustry 18 "Accommodation and Food Services", add
label define bindustry 19 "Other Services (except Public Administration)", add
label define bindustry 20 "Public Administration", add
label values bindustry bindustry 

*lfstat = Labor force status
foreach i in lfstat03 lfstat06 lfstat08 lfstat10 {
label var `i' "Labor force status `i' "
label define `i' 1 "Employed" 2 "Unemployed" 3 "Not in Labor Force"
label values `i' `i'
}

*nocpr = Job code for principal job - best code 2003
label var nocpr03 "Principal Job"
replace nocpr03 = . if nocpr03 == 999989 //put missing or skip to missing value

*nocprmg = Occupation Major Group
foreach i in 03 06 08 10 {
replace nocprmg`i' = . if nocprmg`i' == 8
label var nocprmg`i' "Occupation (Major Group)"
label define nocprmg`i' 1 "Computer and mathematical scientists", add
label define nocprmg`i' 2 "Biological, agricultural and other life scientists", add
label define nocprmg`i' 3 "Physical and related scientists", add
label define nocprmg`i' 4 "Social and related scientists", add
label define nocprmg`i' 5 "Engineers", add
label define nocprmg`i' 6 "S and E related occupations", add
label define nocprmg`i' 7 "Non-S and E Occupations", add
label values nocprmg`i' nocprmg`i'
}

*nocprng03 = Occupation minor group for principal Job 2003
label var nocprng03 "Occupation (minor group)"
replace nocprng03 = . if nocprng03 == 98
label define nocprng03 11 "Computer and information scientists", add
label define nocprng03 12 "Mathematical scientists", add
label define nocprng03 18 "Postsecondary teachers - computer and math sciences", add
label define nocprng03 21 "Agricultural and food scientists", add
label define nocprng03 22 "Biological and medical scientists", add
label define nocprng03 23 "Environmental life scientists", add
label define nocprng03 28 "Postsecondary teachers - life and related sciences", add
label define nocprng03 31 "Chemists, except biochemists", add
label define nocprng03 32 "Earth scientists, geologists and oceanographers", add
label define nocprng03 33 "Physicists and astronomers", add
label define nocprng03 34 "Other physical and related scientists", add
label define nocprng03 38 "Postsecondary teachers - physical and related sciences", add
label define nocprng03 41 "Economists", add
label define nocprng03 42 "Political scientists", add
label define nocprng03 43 "Psychologists", add
label define nocprng03 44 "Sociologists and anthropologists", add
label define nocprng03 45 "Other social and related scientists", add
label define nocprng03 48 "Postsecondary teachers - social and related sciences", add
label define nocprng03 51 "Aerospace and related engineers", add
label define nocprng03 52 "Chemical engineers", add
label define nocprng03 53 "Civil and architectural engineers", add
label define nocprng03 54 "Electrical and related engineers", add
label define nocprng03 55 "Industrial engineers", add
label define nocprng03 56 "Mechanical engineers", add
label define nocprng03 57 "Other engineers", add
label define nocprng03 58 "Postsecondary teachers - engineering", add
label define nocprng03 61 "Health-related occupations", add
label define nocprng03 62 "S and E managers", add
label define nocprng03 63 "S and E Pre-college Teachers", add
label define nocprng03 64 "S and E technicians and technologists", add
label define nocprng03 65 "Other S and E-related occupations", add
label define nocprng03 71 "Non-S and E Managers", add
label define nocprng03 72 "Management-related occupations", add
label define nocprng03 73 "Non-S and E precollege teachers", add
label define nocprng03 74 "Non-S and E postsecondary teachers", add
label define nocprng03 75 "Social services and related occupations", add
label define nocprng03 76 "Sales and marketing occupations", add
label define nocprng03 77 "Art, humanties and related occupations", add
label define nocprng03 78 "Other non-S and E occupations", add
label values nocprng03 nocprng03

*waprsm = Summarized primary work activity
*wascsm = Summarized secondary work activity
*wapri = work activity spent most hours on
label var wapri "Primary Work Activity"
label define wapri 1 "Accounting, finance, contracts", add
label define wapri 2 "Basic Research", add
label define wapri 3 "Applied Research", add
label define wapri 4 "Computer applications, programming, systems development", add
label define wapri 5 "Development", add
label define wapri 6 "Design of equipment, processes, structures, models", add
label define wapri 7 "Employee relations", add
label define wapri 8 "Management and Administration", add
label define wapri 9 "Production, operations, maintenance", add
label define wapri 10 "Prof. services", add
label define wapri 11 "Sales, purchasing, marketing", add
label define wapri 12 "Quality or productivity management", add
label define wapri 13 "Teaching", add
label define wapri 14 "Other work activity", add
label value wapri wapri


*wasec = work activity spent second most hours on
label var wasec "Secondary Work Activity"
label define wasec 0 "No secondary work activity", add
label define wasec 1 "Accounting, finance, contracts", add
label define wasec 2 "Basic Research", add
label define wasec 3 "Applied Research", add
label define wasec 4 "Computer applications, programming, systems development", add
label define wasec 5 "Development", add
label define wasec 6 "Design of equipment, processes, structures, models", add
label define wasec 7 "Employee relations", add
label define wasec 8 "Management and Administration", add
label define wasec 9 "Production, operations, maintenance", add
label define wasec 10 "Prof. services", add
label define wasec 11 "Sales, purchasing, marketing", add
label define wasec 12 "Quality or productivity management", add
label define wasec 13 "Teaching", add
label define wasec 14 "Other work activity", add
label value wasec wasec


// gen var indicating years of working experience = 2003 - t(most recent degree)
gen workexp = 2003 - mrdacyr if mrdacyr <= 2003
replace workexp = 0 if mrdacyr > 2003 // 400 graduates in 2004 (expected graduation in 2004, but academic year 03-04)
label var workexp "Work experience (years)"

//generate dummies for work activities
foreach i in waacc waaprsh wabrsh wacom wadev wadsn waemrl wamgmt waot waprod waqm wasale wasvc watea {
gen `i'_dum = .
replace `i'_dum = 1 if `i' == "Y"
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
gen wan2 = wan^2
label var wan2 "Number of Work Activities squared"

//gen count of commercial activities (cf. Elfenbein)  
gen cmrcn = waacc + waemrl + wamgmt + waprod + waqm + wasale + wasvc 
label var cmrcn "Number of Commercial Activities"

//gen count of research activities (cf. Elfenbein)
gen resn = waaprsh + wabrsh + wacom + wadev + wadsn
label var resn "Number of Research Activities"

//gen variable indicating the weight put on research tasks (cf. beta of Gathmann & Schönberg 2010 / Lazear 2009
gen wres = resn/(resn+cmrcn) // wres lies in the interval [0;1]

gen wres0 = 1 if wres == 0 //beta_research = 0
replace wres0 = 0 if wres > 0

gen wres1 = 1 if wres == 1 //beta_research = 1
replace wres1 = 0 if wres < 1

//gen variable indicating the weight put on commercial tasks
gen wcmrc = cmrcn/(cmrcn+resn)

//create variable employer type: 1= startup, 2 = small established firm, 3 = large established firms
gen emplr = .
replace emplr = 1 if nedtp > 2 & newbus == 1 & emsize < 4
replace emplr = 2 if nedtp > 2 & newbus == 0 & emsize < 4
replace emplr = 3 if nedtp > 2 & newbus == 0 & emsize >= 4

label var emplr "Employer Type"
label define emplr 1 "Startup" 2 "Small Established" 3 "Large Established"
label values emplr emplr

tab emplr, gen(emplr)
rename emplr1 startup
label var startup "Startup"
rename emplr2 small 
label var small "Small Established" 
rename emplr3 large 
label var large "Large Established"

/* SALARY */

// put incorrect wages to missing
foreach i in wage03 wage06 wage08 wage10 {
	replace `i' = . if `i' >= 999998
}

foreach i in 03 06 08 10 {
	label var wage`i' "20`i' wage"
}

//generate lnwage
foreach i in wage03 wage06 wage08 wage10 {
	gen ln`i' = log(`i') 
	*replace ln`i' = 0 if `i' == 0 
}


foreach i in 03 06 08 10 {
	label var lnwage`i' "log 20`i' wage"
}

//generate yearly wage growth [(wage_t - wage03)/(t-3)]
gen dwage = (wage10 - wage03)/6 if wage10 != . & wage03 != .
replace dwage = (wage08 - wage03)/4 if dwage == . & wage08 != . & wage03 != .
replace dwage = (wage06 - wage03)/2 if dwage == . & wage06 != . & wage03 != .
label var dwage "yearly growth wage"

//generate growth log wage = (log(wage_t) - log(wage_3))/(t-3)
gen dlnwage = (lnwage10-lnwage03)/7 if wage10 != . & wage03 != .
gen y10 = 0 
replace y10 = 1 if dlnwage != .
*16 129 values created
gen y8 = 0 
replace y8 = 1 if lnwage08 != . & dlnwage == . & lnwage03 != .
replace dlnwage = (lnwage08-lnwage03)/5 if dlnwage == . & lnwage08 != . & lnwage03 != .
* 19 113 values created
gen y6 = 0 
replace y6 = 1 if lnwage06 != . & dlnwage == . & lnwage03 != .
replace dlnwage = (lnwage06-lnwage03)/3 if dlnwage == . & lnwage06 != . & lnwage03 != .
* 6 327 values created
label var dlnwage "yearly growth log wage"

egen test = rsum(y10 y8 y6)
tab test 
drop test

//gen log yearly wage growth = e^log(wage_t/wage03)/t-3) - 1
* produces 'overestimations' compared to formula with exponential function
gen edlnwage = exp(log(wage10/wage03)/7) - 1 if wage10 != . & wage03 != .
replace edlnwage = exp(log(wage08/wage03)/5) - 1 if edlnwage == . & lnwage08 != .
replace edlnwage = exp(log(wage06/wage03)/3) - 1 if edlnwage == . & lnwage06 != .

/* occupation stayers */
*this coding allows that even those who are not observed in 2008 or 2010 but consecutively between '03-06 or '03-08 also are assigned a value
*those who consecutively don't change occupation are assigned a 1
*as wage is observed when occupation is observed, we can safely regress wage growth on stay 
gen stay = 1 if nocprmg03 == nocprmg06 | nocprmg03 == nocprmg08 | nocprmg03 == nocprmg10 
replace stay = . if nocprmg03 == .
foreach i in 06 08 10 {
replace stay = 0 if nocprmg03 != nocprmg`i' & nocprmg`i' != .
replace stay = . if nocprmg03 == .
}

label var stay "No change of occupation"

/* indicator for top-level managers or executives */
gen toplevel03 = 1 if nocpr03 == 711410
replace toplevel03 = 0 if nocpr03 != 711410 & nocpr03 != .

foreach i in 06 08 10 {
gen toplevel`i' = 1 if nocprpb`i' == 711410
replace toplevel`i' = 0 if nocprpb`i' != 711410 & nocprpb`i' != .
}

gen toplevel = 1 if toplevel06 == 1 | toplevel08 == 1 | toplevel10 == 1
replace toplevel = 0 if toplevel == . & toplevel06 == 0 | toplevel08 == 0 | toplevel10 == 0

foreach i in 03 06 08 10 {
	label var toplevel`i' "Top-level Management Function in 20`i'"
}

label var toplevel "Top-level Management Function"


/* only keep early career, for-profit, full-time (more than 30 weeks per year) employees */
drop if age > 35
drop if dgryr < 1992
drop if emsecdt != 21
*drop if fptind != 1

drop if wkswk < 40
drop if wkswkp06 != 4 & lnwage06 != .
drop if wkswkp08 != 4 & lnwage08 != .
drop if wkswkp10 != 4 & lnwage10 != .

drop if hrswk < 36
drop if hrswkp06 < 3 & lnwage06 != .
drop if hrswkp08 < 3 & lnwage08 != .
drop if hrswkp10 < 3 & lnwage10 != .

*drop if wage03 == 0
*drop if wage10 == 0 & wage08 == . & wage06 == .
*drop if wage08 == 0 & wage06 == .
*drop if wage06 == 0 
drop if emplr == .
drop if bindustry == .	//manual checks show that for some (< 30) observations industry is missing

/* drop observations not in the labor force in 2006, 2008, or 2010 
drop if lfstat10 != 1 & lfstat08 != 1 & lfstat06 != 1
drop if lfstat08 != 1 & lfstat06 != 1
drop if lfstat06 != 1 */


save joinersc.dta, replace






