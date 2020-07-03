
clear all
set more off

cd "C:\Users\u0133260\Dropbox\blog_with_smol\content\post\Do_Files\mata_ml_in_ado_form"

version 12
drop _all
set obs 1000
gen id = _n
local n_choices =3
expand `n_choices'
bys id : gen alternative = _n

// Regressors
gen x1 =  runiform(-2,2)
gen x2 =  runiform(-2,2)
matrix betas_st = (0.5,2)

mata: 
void data_gen() 
{
		betas =st_matrix("betas_st")

		st_view(X = ., ., "x*")
		st_view(panvar = ., ., "id")
		paninfo = panelsetup(panvar, 1) 	
		npanels = panelstats(paninfo)[1] 
		


		for(n=1; n <= npanels; ++n) { 

			x_n = panelsubmatrix(X, n, paninfo) 
			// Linear utility
			util_n =betas :* x_n
			util_sum =rowsum(util_n) 
			U_exp = exp(util_sum)
			// Probability of each alternative
			p_i =     U_exp :/ colsum(U_exp)
				
			cum_p_i =runningsum(p_i)	
			rand_draws = J(rows(x_n),1,uniform(1,1)) 
			pbb_balance = rand_draws:<cum_p_i
			cum_pbb_balance = runningsum(pbb_balance)
			choice_n = (cum_pbb_balance:== J(rows(x_n),1,1))

			
			if (n==1)     Y =choice_n	
			else Y=Y \ choice_n	
			
		 }
	
		resindex = st_addvar("byte","choice")
		st_store((1,rows(Y)),resindex,Y) 	
}
end


// Calling generating data
mata: data_gen()

// Fitting the model
MyClogit choice  x* , group(id) 



