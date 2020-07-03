mata:


	void randregret_LL(transmorphic scalar M, real scalar todo,
	real rowvector b, real scalar lnf,
	real rowvector g, real matrix H)
 {
 	

	
	
	// variables declaration	
	real matrix panvar  
	real matrix paninfo 
	real scalar npanels 

	real scalar n 
	real scalar i 
	
	
	real scalar mu_raw
	real scalar mu
	
	real matrix Y 
	real matrix X 
	
	real matrix r_i 
	real matrix x_n 
	real matrix y_n 
	
	
	
		// variables creation
	Y = moptimize_util_depvar(M, 1) 	
	X= moptimize_init_eq_indepvars(M,1)	
	
	st_view(panvar = ., ., st_global("MY_panel"))
	paninfo = panelsetup(panvar, 1) 	
	npanels = panelstats(paninfo)[1] 
	lnfj = J(npanels, 1, 0) 

	for(n=1; n <= npanels; ++n) {

		x_n = panelsubmatrix(X, n, paninfo) 
		y_n = panelsubmatrix(Y, n, paninfo) 
		
		
	 // Linear utility
		util_n =betas :* x_n
		util_sum =rowsum(util_n) 
		U_exp = exp(util_sum)
		// Probability of each alternative
		p_i =     colsum(U_exp:* y_n) :/ colsum(U_exp)
		lnfj[n] = ln(p_i)
		}

end
	
