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


//correlations for lnwage03 and independent vars
pwcorr lnwage03 age age2 male mar race emplr degree major hdclas tenure emsecdt bindustry nocprng cmrcn resn, star(0.01)

