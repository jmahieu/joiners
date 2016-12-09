						*SESTAT 2003-2010*
							*ANALYSIS*
							
cd "C:\Users\u0091183\Desktop\Phd\Papers\startup joiners\joiners\"
			  
clear all 
log close _all
set more off 
log using "joiners_analysis.log", replace text name(Analysis)

use joinersc.dta
set matsize 10000
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								IMPORTANT VARIABLES

age		age2		male		mar		race		degree		major	  hdclas
tenure	newbus		emsize		emtp	emrg		emsecdt		facadv	  facben
facchal	facind		facloc		facresp	facsal		facsoc		fptind	  industry	  
bindustry	lfstat	nocpr		nocprmg	nocprng		waprsm		wascsm	  wapri
wasec	workexp		waacc		waemrl	wamgmt		waprod		waqm	  wasale
wasvc	waaprsh		wabrsh		wacom	wadev		wadsn		waot	  watea
wan		cmrcn		resn		emplr	wage03		wage06		wage08	  wage10
lnwage03	lnwage06	lnwage08	lnwage10		dlnwage		stay

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/* SUMMARY STATISTICS */

//generate dummies 
qui tab race, gen(dum_race)
qui tab degree, gen(dum_degree)
qui tab major, gen(dum_major)
qui tab hdclas, gen(dum_hdclas)
qui tab emsize, gen(dum_emsize)
qui tab emsecdt, gen(dum_emsecdt)
qui tab bindustry, gen(dum_bindustry)
qui tab nocprmg03, gen(dum_nocprmg03)

eststo clear
//full sample
eststo: qui estpost sum wage* lnwage* dlnwage age age2 male dum_race* mar children03 /// 
dum_degree* wkswk tenure dum_emsize*  dum_bindustry* ///
dum_nocprmg03* toplevel stay wan cmrcn resn 
//startup
eststo: qui estpost sum wage* lnwage* dlnwage age age2 male dum_race* mar children03 /// 
dum_degree* wkswk tenure dum_emsize* dum_bindustry* ///
dum_nocprmg03* toplevel stay wan cmrcn resn if emplr == 1
//small established
eststo: qui estpost sum wage* lnwage* dlnwage age age2 male dum_race* mar children03 /// 
dum_degree*  wkswk tenure dum_emsize*  dum_bindustry* ///
dum_nocprmg03* toplevel stay wan cmrcn resn if emplr == 2
//large established
eststo: qui estpost sum wage* lnwage* dlnwage age age2 male dum_race* mar children03 /// 
dum_degree* wkswk tenure dum_emsize*  dum_bindustry* ///
dum_nocprmg03* toplevel stay wan cmrcn resn if emplr == 3

esttab using summary, replace rtf main(mean %6.2f) aux(sd) label ///
ti("summary statistics") mtitles("Full Sample" "Startup" "Small Established Firms" "Large Established Firms") ///
refcat(dum_race1 "Race" dum_degree1 "Highest Degree" dum_emsize1 "Employer Size"  dum_bindustry1 "Employer Industry" dum_nocprmg031 "Occupation") ///
nonotes addn(Standard deviations in parentheses.)


/* only for employees in for-profit companies */
eststo clear
//full sample
eststo: qui estpost sum wage* lnwage* dlnwage age age2 male dum_race* mar children03 /// 
dum_degree* dum_hdclas* fptind wkswk tenure dum_emsize* dum_emsecdt* dum_bindustry* ///
dum_nocprmg03* stay wan cmrcn resn if emsecdt == 21
//startup
eststo: qui estpost sum wage* lnwage* dlnwage age age2 male dum_race* mar children03 /// 
dum_degree* dum_hdclas* fptind wkswk tenure dum_emsize* dum_emsecdt* dum_bindustry* ///
dum_nocprmg03* stay wan cmrcn resn if emplr == 1 & emsecdt == 21
//small established
eststo: qui estpost sum wage* lnwage* dlnwage age age2 male dum_race* mar children03 /// 
dum_degree* dum_hdclas* fptind wkswk tenure dum_emsize* dum_emsecdt* dum_bindustry* ///
dum_nocprmg03* stay wan cmrcn resn if emplr == 2 & emsecdt == 21
//large established
eststo: qui estpost sum wage* lnwage* dlnwage age age2 male dum_race* mar children03 /// 
dum_degree* dum_hdclas* fptind wkswk tenure dum_emsize* dum_emsecdt* dum_bindustry* ///
dum_nocprmg03* stay wan cmrcn resn if emplr == 3  &emsecdt == 21

esttab using summary_forprofit, replace rtf main(mean %6.2f) aux(sd) label ///
ti("summary statistics") mtitles("Full Sample" "Startup" "Small Established Firms" "Large Established Firms") ///
refcat(dum_race1 "Race" dum_degree1 "Highest Degree" dum_hdclas1 "Carnegie Classification" dum_emsize1 "Employer Size" dum_emsecdt1 "Employer Sector" dum_bindustry1 "Employer Industry" dum_nocprmg031 "Occupation") ///
nonotes addn(Standard deviations in parentheses.)


/*------------------------------------------------------------------------------

					JOB TASKS
			
-------------------------------------------------------------------------------*/
foreach i in 1 2 3 {
sum wan resn cmrcn if emplr == `i', d
}

foreach i in 1 2 3 {
tabstat wan if emplr == `i' & nedtp == 3, by(nocprng) stat(n mean sem) labelwidth(32) longstub
}


//negative binomial regression for number of work activities (wan), number of commercial activities (cmrcn), number of research activities (resn)
nbreg wan startup small i.degree i.major i.bindustry i.nocprmg03 toplevel03 wkswk age tenure i.race male mar, cluster(bindustry) 
outreg2 using experimentation, replace label ti(Work Activities) e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05)

nbreg wan emsize newbus i.degree i.major i.bindustry i.nocprmg03 toplevel03 wkswk age tenure i.race male mar, cluster(bindustry) 
outreg2 using experimentation, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05) append

nbreg cmrcn startup small i.degree  i.major age i.bindustry i.nocprmg03  wkswk age tenure i.race male  mar, cluster(bindustry)  
outreg2 using experimentation, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05) append

nbreg resn startup small i.degree i.major i.bindustry i.nocprmg03 toplevel03 wkswk age tenure i.race male mar, cluster(bindustry) 
outreg2 using experimentation, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05) append

//test whether startup employees are more likely to engage both in at least 1 research and 1 commercial activity
gen multi = 1 if resn >= 1 & cmrcn >= 1
replace multi = 0 if resn == 0 & cmrcn >= 1 | resn >= 1 & cmrcn == 0
*base model w/o controlling for # activities
probit multi startup small i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.fptind i.emsecdt age age2 tenure male i.race mar, nolog
** model including #activities (corr multi and wan = .6)
probit multi startup small wan wan2 i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.fptind i.emsecdt age age2 tenure male i.race mar, nolog


/*
!! matsize too large !!
/* dissimarity measure for job tasks per occupation between employer type */
set matsize 11000
* gen dissimilarity matrix
foreach i in 1 2 3 4 5 6 7 {
	mat dis D`i' = waacc waaprsh wabrsh wacom wadev wadsn waemrl wamgmt waprod waqm wasale wasvc if nocprmg03 == `i' & emplr != ., matching allbinary
}
*/

//relationship between # activities and Pr(staying in the same occupation)
probit stay startup small wan wan2 i.degree i.major i.bindustry i.nocprmg03 age age2 tenure male i.race mar y6 y8 y10, nolog
outreg2 using stayersswitchers, replace label ti(Occupational Switching) e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05)
* model w/o # activities
probit stay startup small i.degree i.major i.bindustry i.nocprmg03 age age2 tenure male i.race mar y6 y8 y10, nolog
outreg2 using stayersswitchers, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05) append

tab toplevel emplr

probit toplevel startup small lnwage03 i.degree i.major i.bindustry i.nocprmg03  age age2 tenure male i.race mar y6 y8 y10 if toplevel03 == 0 & emsize06 > 3 | emsize08 > 3 | emsize10 > 3, nolog
probit toplevel startup small wan wan2 lnwage03 i.degree i.major i.bindustry i.nocprmg03  age age2 tenure male i.race mar y6 y8 y10 if toplevel03 == 0 & emsize06 > 3 | emsize08 > 3 | emsize10 > 3, nolog

/*
/*-----------------------------------------------------------------------------

			ORDERED OUTCOME REGRESSION FOR FAC* VARIABLES
			
______________________________________________________________________________*/

//correlations
foreach i in facadv facben facchal facind facloc facresp facsal facsec facsoc {
	pwcorr `i' emplr degree major hdclas bindustry nocprng fptind emsecdt age age2 tenure male race mar, star(0.05)
}

*standard errors clustered by industry - assumed independent error terms over clusters
*omitted categories: startup, bachelor's degree, Research I university, Agriculture industry, Computer and Information scientists, 4-yr coll/univ, Asian

//Importance of advancement opportunities
ologit facadv i.emplr i.degree i.major i.hdclas i.nocprng i.bindustry i.fptind i.emsecdt age age2 tenure male i.race mar, vce(cluster bindustry) nolog
ereturn list //df = 16 ?too low?
*margins, dydx(*) predict(outcome(4)) atmean 

*marginal effects 

//Importance of job's benefits
ologit facben i.emplr i.degree i.major i.hdclas i.bindustry i.nocprng i.fptind i.emsecdt age age2 tenure male i.race mar, vce(cluster bindustry) nolog

//Importance of job's intellectual challenge
ologit facchal i.emplr i.degree i.major i.hdclas i.bindustry i.nocprng i.fptind i.emsecdt age age2 tenure male i.race mar, vce(cluster bindustry) nolog

//Importance of job's degree of independence
ologit facind i.emplr i.degree i.major i.hdclas i.bindustry i.nocprng i.fptind i.emsecdt age age2 tenure male i.race mar, vce(cluster bindustry) nolog

//Importance of job's location
ologit facloc i.emplr i.degree i.major i.hdclas i.bindustry i.nocprng i.fptind i.emsecdt age age2 tenure male i.race mar, vce(cluster bindustry) nolog

//Importance of job's level of responsibility
ologit facresp i.emplr i.degree i.major i.hdclas i.bindustry i.nocprng i.fptind i.emsecdt age age2 tenure male i.race mar, vce(cluster bindustry) nolog

//Importance of job's salary
ologit facsal i.emplr i.degree i.major i.hdclas i.bindustry i.nocprng i.fptind i.emsecdt age age2 tenure male i.race mar, vce(cluster bindustry) nolog

//Importance of job's contribution to society
ologit facsoc i.emplr i.degree i.major i.hdclas i.bindustry i.nocprng i.fptind i.emsecdt age age2 tenure male i.race mar, vce(cluster bindustry) nolog
*/

/*------------------------------------------------------------------------------

					REGRESSIONS ON SALARY
					
------------------------------------------------------------------------------*/

foreach i in 1 2 3  {
sum lnwage03 if emplr == `i', d 
}	// sd of startup wages =  1.685816, small est = 1.321806, large est = .9853304

// t test for equal wage means - allow for unequal variance
ttesttable lnwage03 emplr, unequal	//startups earn on average significantly less than large firm employees, but more than small established firm employees

// t test for equal variances of wage
foreach i in 2 3 {
sdtest lnwage03 = 1.685816 if emplr == `i'
}	//both rejected at p > 0.00001 - startup wages have significantly higher variance

twoway kdensity lnwage03 if emplr == 1 || kdensity lnwage03 if emplr == 2 || kdensity lnwage03 if emplr == 3, legend(order( 1 "startup" 2 "small established firm" 3 "large established firm"))



// t test of equal means of log wage in 2003 between startups - small est firms - large est firms
ttesttable lnwage03 emplr, unequal


//correlations for lnwage03 and independent vars
pwcorr lnwage03 age age2 male mar race startup small large degree major hdclas tenure emsecdt bindustry nocprng wan, star(0.05)

//OLS and 2SLS IV regression on log wage
reg lnwage03 startup small i.degree i.major i.bindustry i.nocprmg03 age age2 tenure male i.race mar, cluster(bindustry)
** models including #activities, #res activities, #commercial activities + interaction effects
reg lnwage03 startup small wan wan2  i.degree i.major i.hdclas i.bindustry i.nocprmg03 age age2 tenure male i.race mar, cluster(bindustry)
reg lnwage03 startup small resn cmrcn i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust)


ivreg2 lnwage03 i.degree i.major i.hdclas i.bindustry i.nocprmg wan i.fptind i.emsecdt age age2 tenure male i.race mar (startup = i.facsec), robust first endogtest(startup)
*endogeneity test for startup: reject H0 that the specified endogenous regressors can actually be treated as exogenous
*startup is instrumented by importance of job security (1 = not important, 4 = very important)
*1st stage: "rule of thumb" F test of excluded instruments has value 18.10 (> 10) - Kleibergen-Paap rk Wald statistics (Cragg Donald F statistic = 38.78)
*Kleibergen Paap rk Wald stat rejects 5% relative IV bias critical value of Stock and Yogo
*1st stage:  Kleibergen Paap underidentification rejects H0 = full rank and identification
*Hansen J: strong rejection of H0 that all instruments are uncorrelated with the error term - doubt validity of the estimates

/*------------------------------------------------------------------------------

					REGRESSIONS ON SALARY GROWTH
					
------------------------------------------------------------------------------*/

sum dlnwage, d

foreach i in 1 2 3{
	sum dlnwage if emplr == `i', d
}


// t test of equal means of growth log wage 
ttesttable dlnwage emplr, unequal

*base model
reg dlnwage startup small i.degree i.major  i.bindustry i.nocprmg03 wkswk age age2 tenure male i.race mar children03 y8 y10, cluster(bindustry)
outreg2 using wagegrowth, replace label ti(Wage Growth) e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.01, 0.05, 0.10)
**model including number of activities (wan) and interaction effect - wan treated as continuous variable
reg dlnwage startup small wan wan2 i.degree i.major i.bindustry i.nocprmg03 wkswk age age2 tenure male i.race mar children03 y8 y10, cluster(bindustry)
outreg2 using wagegrowth, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.01, 0.05, 0.10) append
***base model - stayers
reg dlnwage startup small i.degree i.major  i.bindustry i.nocprmg03 wkswk age age2 tenure male i.race mar children03 y8 y10 if stay == 1, cluster(bindustry)
outreg2 using wagegrowth, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.01, 0.05, 0.10) append
****model including number of activities (wan) - stayers
reg dlnwage startup small wan wan2 i.degree i.major i.bindustry i.nocprmg03 wkswk age age2 tenure male i.race mar children03 y8 y10 if stay == 1, cluster(bindustry)
outreg2 using wagegrowth, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.01, 0.05, 0.10) append
***base model - switchers
reg dlnwage startup small i.degree i.major i.bindustry i.nocprmg03 wkswk age age2 tenure male i.race mar children03 y8 y10 if stay == 0, cluster(bindustry)
outreg2 using wagegrowth, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.01, 0.05, 0.10) append
****model including number of activities (wan) - switchers
reg dlnwage startup small wan wan2 i.degree i.major i.bindustry i.nocprmg03 wkswk age age2 tenure male i.race mar children03 y8 y10 if stay == 0, cluster(bindustry)
outreg2 using wagegrowth, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.01, 0.05, 0.10) append


**model including number of activities (wan) and interaction effect - wan treated as categorical variable
reg dlnwage startup small i.wan 1.startup#i.wan i.degree i.major i.hdclas i.bindustry i.nocprmg03 fptind wkswk i.emsecdt age age2 tenure male i.race mar children03 y8 y10, vce(robust)
***model including whether the employee stays in the same occupation over time - and interaction effects
reg dlnwage startup small stay i.degree i.major i.hdclas i.bindustry i.nocprmg03 fptind wkswk i.emsecdt age age2 tenure male i.race mar children03 y8 y10, cluster(bindustry)
****model including number of activities (in 2003) interacted with changing employer 
reg dlnwage startup small wan wan2 0.stay 0.stay#c.wan i.degree i.major i.hdclas i.bindustry i.nocprmg03 fptind wkswk i.emsecdt age age2 tenure male i.race mar children03 y8 y10, vce(robust)

/* sample selection model - selection equation on working in 2006 yes/no) */
gen working06 = 1 if lfstat06 == 1
replace working06 = 0 if lfstat06 == 2 | lfstat06 == 3

heckman dlnwage startup small i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.emsecdt fptind wkswk age age2 tenure male i.race mar children03 y8 y10, /// 
select(working06 = lnwage03 startup small i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.emsecdt fptind wkswk age age2 tenure male i.race mar i.children06 y6) twostep 
*compared to workers in large firms, startup employees in 2003 are significantly less likely to be working in 2006
*lambda has a z statistic of -4.44

*model with wan and interaction effects - wan is treated as a continuous variable
heckman dlnwage startup small wan wan2 startup#c.wan i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.emsecdt fptind wkswk age age2 tenure male i.race mar children03 y8 y10, /// 
select(working06 = lnwage03 startup small i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.emsecdt fptind wkswk age age2 tenure male i.race mar i.children06) twostep

*model with wan and interaction effects - wan is treated as a categorical variable
heckman dlnwage startup small i.wan startup#1.wan i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.emsecdt fptind wkswk age age2 tenure male i.race mar children03 y8 y10, /// 
select(working06 = lnwage03 startup small i.wan i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.emsecdt fptind wkswk age age2 tenure male i.race mar i.children06) twostep  

***model including whether the employee stays in the same occupation over time - and interaction effects
heckman dlnwage startup small stay 0.stay#b3.emplr  i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.emsecdt fptind wkswk age age2 tenure male i.race mar children03 y8 y10, /// 
select(working06 = lnwage03 startup small i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.emsecdt fptind wkswk age age2 tenure male i.race mar i.children06) twostep  


/* IV regressions */

*base model: startup vs non-startup
ivreg2 dlnwage i.degree i.major i.hdclas i.bindustry i.nocprmg03 wan age age2 tenure male i.race mar y8 y10 (startup = i.facsec) if stay == 0, robust first 

probit stay startup small lnwage03 i.degree i.major i.hdclas i.bindustry i.nocprmg03 i.fptind i.emsecdt age age2 tenure male i.race mar

