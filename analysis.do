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
logout, save(summary_full) word fix replace: sum ibn.emplr wage03 wage06 wage08 wage10 lnwage03 lnwage06 lnwage08 lnwage10 dlnwage age age2 male mar ibn.race ibn.degree ibn.major ibn.hdclas tenure newbus ibn.emsize	ibn.emrg ibn.emsecdt ibn.facadv ibn.facben ibn.facchal ibn.facind ibn.facloc ibn.facres ibn.facsal ibn.facsoc ibn.fptind ibn.bindustry	ibn.lfstat ibn.nocprng workexp ibn.wapri waacc waemrl wamgmt waprod	waqm wasale wasvc waaprsh wabrsh wacom	wadev wadsn waot watea wan cmrcn resn if emplr != ., fvwrap(4) 

//summary statistics for startup employees
logout, save(summary_startup) word fix replace: sum ibn.emplr wage03 wage06 wage08 wage10 lnwage03 lnwage06 lnwage08 lnwage10 dlnwage age age2 male mar ibn.race ibn.degree ibn.major ibn.hdclas tenure newbus ibn.emsize	ibn.emrg ibn.emsecdt ibn.facadv ibn.facben ibn.facchal ibn.facind ibn.facloc ibn.facres ibn.facsal ibn.facsoc ibn.fptind ibn.bindustry	ibn.lfstat ibn.nocprng workexp ibn.wapri waacc waemrl wamgmt waprod	waqm wasale wasvc waaprsh wabrsh wacom	wadev wadsn waot watea wan cmrcn resn if emplr == 1, fvwrap(4) 

//summary statistics for small established firm employees
logout, save(summary_smallest) word fix replace: sum ibn.emplr wage03 wage06 wage08 wage10 lnwage03 lnwage06 lnwage08 lnwage10 dlnwage age age2 male mar ibn.race ibn.degree ibn.major ibn.hdclas tenure newbus ibn.emsize	ibn.emrg ibn.emsecdt ibn.facadv ibn.facben ibn.facchal ibn.facind ibn.facloc ibn.facres ibn.facsal ibn.facsoc ibn.fptind ibn.bindustry	ibn.lfstat ibn.nocprng workexp ibn.wapri waacc waemrl wamgmt waprod	waqm wasale wasvc waaprsh wabrsh wacom	wadev wadsn waot watea wan cmrcn resn if emplr == 2, fvwrap(4) 

//summary statistics for large established firm employees
logout, save(summary_largeest) word fix replace: sum ibn.emplr wage03 wage06 wage08 wage10 lnwage03 lnwage06 lnwage08 lnwage10 dlnwage age age2 male mar ibn.race ibn.degree ibn.major ibn.hdclas tenure newbus ibn.emsize	ibn.emrg ibn.emsecdt ibn.facadv ibn.facben ibn.facchal ibn.facind ibn.facloc ibn.facres ibn.facsal ibn.facsoc ibn.fptind ibn.bindustry	ibn.lfstat ibn.nocprng workexp ibn.wapri waacc waemrl wamgmt waprod	waqm wasale wasvc waaprsh wabrsh wacom	wadev wadsn waot watea wan cmrcn resn if emplr == 3, fvwrap(4) 

