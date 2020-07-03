mata:
	void MyLikelihood_LL(transmorphic scalar M, real scalar todo,
	real rowvector b, real scalar lnf,
	real rowvector g, real matrix H)
 {

	// variables declaration	
	real matrix panvar  
	real matrix paninfo 
	real scalar npanels 

	real scalar n 
	real matrix Y 
	real matrix X 
	
	real matrix x_n 
	real matrix y_n 
	
	
	
	// regressors and explained variable
	Y = moptimize_util_depvar(M, 1) 	
	X= moptimize_init_eq_indepvars(M,1)	
	
	// betas
	id_beta_eq=moptimize_util_eq_indices(M,1)
	betas= b[|id_beta_eq|]
	
 
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
		p_i =     (colsum(U_exp:* y_n)) / (colsum(U_exp))
		// Add contribution to the likelihood
		lnfj[n] = ln(p_i)
	
	}
	
	lnf = moptimize_util_sum(M, lnfj)
 }
	
end
	
	
// Creating a matalibrary that is available EVERYWHERE FOR EVER
mata:

mata mlib create lMyClogit, replace
mata mlib add    lMyClogit MyLikelihood_LL()
mata mlib index

end

	
	
