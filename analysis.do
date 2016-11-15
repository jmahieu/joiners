						*SESTAT 2003-2010*
							*ANALYSIS*
							
cd "C:\Users\Jeroen\Desktop\joiners\"
			  
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
outreg2 using summary, replace sum(log) eqkeep(ibn.emplr wage03 wage06 wage08 wage10 lnwage03 lnwage06 lnwage08 lnwage10 dlnwage age age2 male mar ibn.race ibn.degree ibn.major ibn.hdclas tenure newbus ibn.emsize ibn.emrg ibn.emsecdt ibn.facadv ibn.facben ibn.facchal ibn.facind ibn.facloc ibn.facres ibn.facsal ibn.facsoc ibn.fptind ibn.bindustry ibn.lfstat ibn.nocprng workexp ibn.wapri waacc waemrl wamgmt waprod waqm wasale wasvc waaprsh wabrsh wacom wadev wadsn waot watea wan cmrcn resn) excel see
sum ibn.emplr wage03 wage06 wage08 wage10 lnwage03 lnwage06 lnwage08 lnwage10 dlnwage age age2 male mar ibn.race degree major ibn.hdclas tenure newbus ibn.emsize	ibn.emrg ibn.emsecdt ibn.facadv ibn.facben ibn.facchal ibn.facind ibn.facloc ibn.facres ibn.facsal ibn.facsoc ibn.fptind ibn.bindustry	ibn.lfstat ibn.nocprng workexp ibn.wapri waacc waemrl wamgmt waprod	waqm wasale wasvc waaprsh wabrsh wacom	wadev wadsn waot watea wan cmrcn resn 
