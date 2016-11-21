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
lnwage03	lnwage06	lnwage08	lnwage10		dlnwage

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/


// summary statistics for full dataset
logout, save (summary_full) fix excel replace: fsum emplr wage* lnwage* dlnwage age age2 workexp male race mar degree major hdclas fptind tenure emsize emrg emsecdt bindustry nocprng wapri waacc waemrl wamgmt waprod waqm wasale wasvc waaprsh wabrsh wacom wadev wadsn waot watea wan cmrcn resn facadv facben facchal facind facloc facres facsal facsec facsoc, catvar(emplr male race mar degree major hdclas fptind emsize emrg emsecdt bindustry nocprng wapri facadv facben facchal facind facloc facres facsal facsec facsoc) uselabel  

//summary statistics for startup employees
logout, save (summary_startup) fix excel replace: fsum emplr wage* lnwage* dlnwage age age2 workexp male race mar degree major hdclas fptind tenure emsize emrg emsecdt bindustry nocprng wapri waacc waemrl wamgmt waprod waqm wasale wasvc waaprsh wabrsh wacom wadev wadsn waot watea wan cmrcn resn facadv facben facchal facind facloc facres facsal facsec  facsoc if emplr == 1, catvar(emplr male race mar degree major hdclas fptind emsize emrg emsecdt bindustry nocprng wapri facadv facben facchal facind facloc facres facsal facsec facsoc) uselabel  

//summary statistics for small established firm employees
logout, save (summary_smallest) fix excel replace: fsum emplr wage* lnwage* dlnwage age age2 workexp male race mar degree major hdclas fptind tenure emsize emrg emsecdt bindustry nocprng wapri waacc waemrl wamgmt waprod waqm wasale wasvc waaprsh wabrsh wacom wadev wadsn waot watea wan cmrcn resn facadv facben facchal facind facloc facres facsal facsec  facsoc if emplr == 2, catvar(emplr male race mar degree major hdclas fptind emsize emrg emsecdt bindustry nocprng wapri facadv facben facchal facind facloc facres facsal facsec facsoc) uselabel  

//summary statistics for large established firm employees
logout, save (summary_largeest) fix excel replace: fsum emplr wage* lnwage* dlnwage age age2 workexp male race mar degree major hdclas fptind tenure emsize emrg emsecdt bindustry nocprng wapri waacc waemrl wamgmt waprod waqm wasale wasvc waaprsh wabrsh wacom wadev wadsn waot watea wan cmrcn resn facadv facben facchal facind facloc facres facsal facsec  facsoc if emplr == 3, catvar(emplr male race mar degree major hdclas fptind emsize emrg emsecdt bindustry nocprng wapri facadv facben facchal facind facloc facres facsal facsoc) uselabel  


/*------------------------------------------------------------------------------

			MEASURING JOB TASK EXPERIMENTATION 
			
-------------------------------------------------------------------------------*/
foreach i in 1 2 3 {
tabstat wan if emplr == `i' & nedtp == 3, by(nocprng) stat(n mean sem) labelwidth(32) longstub
}

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

//negative binomial regression for number of work activities (wan), number of commercial activities (cmrcn), number of research activities (resn)
nbreg wan b3.emplr i.degree i.major i.hdclas i.bindustry i.nocprmg i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust) nolog
outreg2 using experimentation, replace label ti(Work Activities) e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05)

nbreg cmrcn b3.emplr i.degree i.major i.hdclas i.bindustry i.nocprmg i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust) nolog
outreg2 using experimentation, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05) append

nbreg resn b3.emplr i.degree i.major i.hdclas i.bindustry i.nocprmg i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust) nolog
outreg2 using experimentation, label e(all) adec(3) bdec(3) rdec(3) word excel symbol(***, **, *) alpha(0.001, 0.01, 0.05) append

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

					REGRESSIONS ON SALARY (GROWTH)
					
------------------------------------------------------------------------------*/

//correlations for lnwage03 and independent vars
pwcorr lnwage03 age age2 male mar race startup small large degree major hdclas tenure emsecdt bindustry nocprng wan, star(0.05)

reg lnwage03 startup small i.degree i.major i.hdclas i.bindustry i.nocprmg i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust)
reg lnwage03 startup small i.degree i.major i.hdclas i.bindustry i.nocprmg wan i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust)

*ivregress 2sls lnwage03 i.degree i.major i.hdclas i.bindustry i.nocprmg wan i.fptind i.emsecdt age age2 tenure male i.race mar (startup = i.facsec), vce(robust) first 
*estat firststage, forcenonrobust all

ivreg2 lnwage03 i.degree i.major i.hdclas i.bindustry i.nocprmg wan i.fptind i.emsecdt age age2 tenure male i.race mar (startup = i.facsec), robust first 

reg dlnwage b3.emplr i.degree i.major i.hdclas i.bindustry i.nocprmg i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust)
reg dlnwage b3.emplr i.wan i.degree i.major i.hdclas i.bindustry i.nocprmg i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust)
reg dlnwage b3.emplr wan wan2 i.degree i.major i.hdclas i.bindustry i.nocprmg i.fptind i.emsecdt age age2 tenure male i.race mar, vce(robust)

ivreg2 dlnwage i.degree i.major i.hdclas i.bindustry i.nocprmg wan i.fptind i.emsecdt age age2 tenure male i.race mar (startup = i.facsec), robust first 

ivreg2 dlnwage lnwage03 i.degree i.major i.hdclas i.bindustry i.nocprmg wan i.fptind i.emsecdt age age2 tenure male i.race mar (startup = i.facsec), robust first 
* !! inconsistent estimator of lnwage03 - endogenous
