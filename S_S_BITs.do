 clear
 set matsize 5000
 import excel "E:\2018\2018-4-15-报告\workplace\实证2.xlsx", sheet("Sheet1") firstrow clear
 
 *year1_year2 固定效应
 tostring year1 year2,replace
 g year1_year2=year1+year2
 egen feyear1_year2=group(year1_year2)
 
 destring year1 year2,replace force
 xtset feyear1_year2
 xtreg sim ss_1 ss_2 ss_both,fe
 est store m1
 
  *treaty1_sig1_sig2 固定效应
 g treaty1_sig1_sig2=treaty1+sig1+sig2
 egen fetreaty1_sig1_sig2=group(treaty1_sig1_sig2)
 xtset fetreaty1_sig1_sig2
 xtreg sim ss_1 ss_2 ss_both,fe
 est store m2
 
 *treaty2_sig3_sig4 固定效应
 g treaty2_sig3_sig4=treaty2+sig3+sig3
 egen fetreaty2_sig3_sig4=group(treaty2_sig3_sig4)
 xtset fetreaty2_sig3_sig4
 xtreg sim ss_1 ss_2 ss_both,fe
 est store m3
 
 *year1_year2  treaty1_sig1_sig2 固定效应
 g treaty1_sig1_sig2=treaty1+sig1+sig2
 egen fetreaty1_sig1_sig2=group(treaty1_sig1_sig2)
 xtset fetreaty1_sig1_sig2
 destring year1_year2,replace force
 xtreg sim ss_1 ss_2 ss_both i.year1_year2,fe
 est store m4
 
 *year1_year2  treaty2_sig3_sig4 固定效应
 g treaty2_sig3_sig4=treaty2+sig3+sig3
 egen fetreaty2_sig3_sig4=group(treaty2_sig3_sig4)
 xtset fetreaty2_sig3_sig4
 xtreg sim ss_1 ss_2 ss_both i.year1_year2,fe
 est store m5
 
 outreg2 [m1 m2 m3 m4 m5] using table2,word replace
 
   export excel using "E:\2018\2018-4-15-报告\workplace\实证2.xlsx", /*
 */firstrow(variables) replace
