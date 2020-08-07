sysuse auto, clear 

reg price rep78 length foreign , robust 
local what_I_typed = e(cmdline)
di "`what_I_typed'"
gettoken command rhs : what_I_typed ,parse(" ,") // first token and the rest
di "`command'"
di "`rhs'"
gettoken y x_plus_options : rhs ,parse(" ,") // first token and the rest
di "`x_plus_options'"
gettoken x options : x_plus_options ,parse(",") // split using "," (look carefully!)
di "`x'"
di "`options'"




loc first_x `=word("`x'",1)'
di   "`first_x'"

loc last_x `=word("`x'",-1)'
di   "`last_x'"


