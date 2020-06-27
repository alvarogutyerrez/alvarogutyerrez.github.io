
clear all
sysuse auto, clear

tab foreign 

sum foreign if foreign =="Domestic":`: value label foreign' , meanonly
ret list 

sum foreign if foreign =="Borges":`: value label foreign' , meanonly
ret list 


local mean_altern = r(mean)



capture confirm number `mean_altern'
di _rc 


if _rc ==7{ // Unable to calculate r(mean) bc basealternative is not in `alternatives' 
	di as red "Variable `alternatives' does not contain basealternative() provided "
	*exit 7
}


capture drop program check_labels

program define check_labels ,rclass
	version 12.0
	syntax varlist(max=1) [if] , label(string) 			 	

	qui sum `varlist' if  `varlist' == "`label'": `: value label `varlist'' ,nomean
	
	local mean_altern = r(mean)
	capture confirm number `mean_altern'
	if _rc ==7 {
	    di in red " `label' isn't present on labels of var `varlist' "
		return scalar present = 0
	}
	else if _rc ==0 {
	    di in red " `label' is present on labels of var `varlist' "
		return scalar present = 1
		} 
end


check_labels foreign , label(Domestic)
ret list

check_labels foreign , label(Borges)
ret list
