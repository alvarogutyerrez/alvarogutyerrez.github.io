
program MyClogit 
	version 12

	if replay() {
	if ("`e(cmd)'" != "MyClogit") error 301
	Replay `0'
	}
	else Estimate `0'
end



program Estimate, eclass sortpreserve 
	syntax varlist(fv) [if] [in] ,		///
			GRoup(varname) 				///
			[vce(passthru)				///
			noLOg 						/// 
			Level(cilevel)				///
		TRace						///
		GRADient					///
		HESSian						///
		SHOWSTEP					///
		ITERate(passthru)			///
		TOLerance(passthru)			///
		LTOLerance(passthru)		///
		GTOLerance(passthru)		///
		NRTOLerance(passthru)		///
		CONSTraints(passthru)		///
		TECHnique(passthru)			///
		DIFficult					///
		FRom(string)				/// 
	]

	
	
	di "`constraints'"
	
	local mlopts `trace' `gradient' `hessian' `showstep' `iterate' `tolerance' ///
	`ltolerance' `gtolerance' `nrtolerance' `constraints' `technique' `difficult' `from'
	
	if ("`technique'" == "technique(bhhh)") {
	di in red "technique(bhhh) is not allowed."
	exit 498
	}

	capture confirm numeric var `group'
	if _rc != 0 {
		di in r "The group variable must be numeric"
		exit 498
	}

	
	// check syntax
	gettoken lhs rhs : varlist
	
	// mark the estimation sample
	marksample touse
	markout `touse' `group' 
	
	
	// id of individuals
	global MY_panel = "`group'"
	
	
	// qui create mlibrary with all LL
	qui capture do MyLikelihood_LL.mata	

	
	// Title
	loc title "MyClogit"

	
	loc LL  "(MyClogit: `lhs' = `rhs', nocons) " 
	
	di "hola"
	ml model d0 MyLikelihood_LL()				///
			`LL'								///	
			if `touse', 						///
			`vce' 								///
			missing								///
			first 								///
			`log'								///
			`mlopts' 							///		
			`init'								/// 
			title(`title') 						///
			maximize				
			
		// Show models
		ereturn local cmd MyClogit
		Replay , level(`level')	
		
		
		ereturn local  cmdline `"`0'"'	
	
end


 program Replay
	syntax [, Level(cilevel) ]
	ml display , level(`level')  
 end

