clear
cd C:\Stata14\ado\personal\regressors
	
	use Log_of_Gravity,clear
	gen num=_n
forvalues i = 50 100 to 18350{
	* keep if num <= `i'
	ppml trade lypex lypim lyex lyim ldist border comlang colony landl_ex landl_im lremot_ex lremot_im comfrt_wto open_wto if num<= `i'
	est store m_`i'
	}
outreg2 [m_*] using table0.xls,excel replace
