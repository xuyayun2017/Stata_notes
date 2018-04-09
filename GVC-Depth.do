 clear
 set more off 
 cap log close
 cd "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace"
 log using "E:\2018\2018-3-20-GVC\数据\贸易数据\Depth-Gvc.log",replace

 set matsize 5000
*总出口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaexp_daochu.xlsx", /*
 */sheet("chinaexp_daochu") firstrow clear
 
//gen ltrade=ln(value)
destring gdpit gdpct dist contig FTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=value/1000
gen lvalue=ln(value)
*只加控制变量
ppml lvalue FTA lgdpit lgdpct ldist contig
est store m1
ppml lvalue IV_total lgdpit lgdpct ldist contig
est store m2
/*egen pair=group(exp imp)
egen yer=group(year)
xtset pair yer
xtivreg lvalue (FTA=IV_score1) lgdpit lgdpct ldist contig*/
ppml lvalue IV_core lgdpit lgdpct ldist contig
est store m3
ppml lvalue IV_score1 lgdpit lgdpct ldist contig
est store m4
ppml lvalue IV_score2 lgdpit lgdpct ldist contig //进口convergence not achieved
est store m5
ppml lvalue IV_score3 lgdpit lgdpct ldist contig //进口convergence not achieved
est store m6
ppml lvalue IV_score4 lgdpit lgdpct ldist contig //进口convergence not achieved
est store m7
outreg2 [m1 m2 m3 m4 m5 m6 m7] using 总贸易额_进口,word replace

*使用ivregress
reg lvalue FTA lgdpit lgdpct ldist contig,r         //0.71
est store m1
ivregress 2sls lvalue (FTA=IV_total) lgdpit lgdpct ldist contig,r //4.93
est store m2
ivregress 2sls lvalue (FTA=IV_core) lgdpit lgdpct ldist contig,r  //7.4
est store m3
ivregress 2sls lvalue (FTA=IV_score1) lgdpit lgdpct ldist contig,r //4.97
est store m4
ivregress 2sls lvalue (FTA=IV_score2) lgdpit lgdpct ldist contig,r //5.18
est store m5
ivregress 2sls lvalue (FTA=IV_score3) lgdpit lgdpct ldist contig,r //5.17
est store m6
ivregress 2sls lvalue (FTA=IV_score4) lgdpit lgdpct ldist contig,r //5.15
est store m7
outreg2 [m1 m2 m3 m4 m5 m6 m7] using IVREGRESS_总出口,word replace
*过渡识别检验
estat overid //工具变量的数目少于或等于内生变量是不用做sargan检验，因为不存在过度识别问题
*
estat firststage,all forcenonrobust




*加固定效应和控制变量
egen exp_time=group(exp year)
     tabulate exp_time,generate(EXPORTER_TIME_FE)
egen imp_time=group(imp year)
     tabulate imp_time,generate(IMPORTER_TIME_FE)
egen pair_id=group(exp imp)
     tabulate pair_id,generate(PAIR_FE)
	 
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* FTA lgdpit lgdpct ldist contig
est store m1
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_total lgdpit lgdpct ldist contig
est store m2
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_core lgdpit lgdpct ldist contig
est store m3
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_score1 lgdpit lgdpct ldist contig
est store m4
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_score2 lgdpit lgdpct ldist contig
est store m5
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_score3 lgdpit lgdpct ldist contig
est store m6
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_score4 lgdpit lgdpct ldist contig 
est store m7
	 
outreg2 [m1 m2 m3 m4 m5 m6 m7] using table0,word replace

*加固定效应-全部omitted
egen exp_time=group(exp year)
     tabulate exp_time,generate(EXPORTER_TIME_FE)
egen imp_time=group(imp year)
     tabulate imp_time,generate(IMPORTER_TIME_FE)
egen pair_id=group(exp imp)
     tabulate pair_id,generate(PAIR_FE)
	 
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* FTA
est store m1
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_total 
est store m2
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_core 
est store m3
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_score1 
est store m4
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_score2 
est store m5
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_score3 
est store m6
ppml value EXPORTER_TIME_FE* IMPORTER_TIME_FE* IV_score4 
est store m7
	 
outreg2 [m1 m2 m3 m4 m5 m6 m7] using table0,word replace


*总进口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaimp_daochu.xlsx", /*
 */sheet("chinaimp_daochu") firstrow clear
 
//gen ltrade=ln(value)
destring gdpit gdpct dist contig FTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)

*只加控制变量
ppml value FTA lgdpit lgdpct ldist contig
est store m1
ppml value IV_total lgdpit lgdpct ldist contig
est store m2
ppml value IV_core lgdpit lgdpct ldist contig
est store m3
ppml value IV_score1 lgdpit lgdpct ldist contig
est store m4
ppml value IV_score2 lgdpit lgdpct ldist contig  //convergence not achieved
est store m5
ppml value IV_score3 lgdpit lgdpct ldist contig
est store m6
ppml value IV_score4 lgdpit lgdpct ldist contig  //convergence not achieved
est store m7

outreg2 [m1 m2 m3 m4 m5 m6 m7] using table0,word replace




*增加值TiVA-intermediates
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates.xlsx", /*
 */sheet("Sheet1") firstrow clear

destring gdpit gdpct dist contig,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
*只加控制变量_出口
ppml exp_value FTA lgdpit lgdpct ldist contig
est store m1
ppml exp_value IV_total lgdpit lgdpct ldist contig
est store m2
ppml exp_value IV_core lgdpit lgdpct ldist contig
est store m3
ppml exp_value IV_score1 lgdpit lgdpct ldist contig
est store m4
ppml exp_value IV_score2 lgdpit lgdpct ldist contig
est store m5
ppml exp_value IV_score3 lgdpit lgdpct ldist contig
est store m6
ppml exp_value IV_score4 lgdpit lgdpct ldist contig 
est store m7

outreg2 [m1 m2 m3 m4 m5 m6 m7] using 增加值_出口,word replace


*只加控制变量_进口
ppml imp_value FTA lgdpit lgdpct ldist contig 
est store m1
ppml imp_value IV_total lgdpit lgdpct ldist contig 
est store m2
ppml imp_value IV_core lgdpit lgdpct ldist contig
est store m3
ppml imp_value IV_score1 lgdpit lgdpct ldist contig
est store m4
ppml imp_value IV_score2 lgdpit lgdpct ldist contig
est store m5
ppml imp_value IV_score3 lgdpit lgdpct ldist contig
est store m6
ppml imp_value IV_score4 lgdpit lgdpct ldist contig 
est store m7

outreg2 [m1 m2 m3 m4 m5 m6 m7] using 增加值_进口,word replace


*merge
 clear
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_exp_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear
 save interexp,replace
 destring FTA,replace
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_imp_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet2") firstrow clear
 save interimp,replace
 use interexp
 merge 1:m imp year using interimp,assert(match) force
 
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaimp_daochu.xlsx", /*
 */sheet("chinaimp_daochu") firstrow clear
 save chinaimp,replace
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\intermediates_daochu.xlsx", /*
 */sheet("import") firstrow clear
 save inter_imp,replace
 use chinaimp
 merge 1:m exp year using inter_imp,assert(match)
 
 export excel using "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_进出口加总.xlsx", /*
 */firstrow(variables) replace

 
 *垂直专业化指数_出口
 clear
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_exp.xlsx", /*
 */sheet("Sheet1") firstrow clear
 
 destring gdpit gdpct dist contig FTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)

ppml index_exp FTA lgdpit lgdpct ldist contig       //不显著
est store m1
ppml index_exp IV_total lgdpit lgdpct ldist contig  //以下均显著为负
est store m2
ppml index_exp IV_core lgdpit lgdpct ldist contig
est store m3
ppml index_exp IV_score1 lgdpit lgdpct ldist contig
est store m4
ppml index_exp IV_score2 lgdpit lgdpct ldist contig
est store m5
ppml index_exp IV_score3 lgdpit lgdpct ldist contig
est store m6
ppml index_exp IV_score4 lgdpit lgdpct ldist contig 
est store m7

outreg2 [m1 m2 m3 m4 m5 m6 m7] using 垂直专业化指数_出口,word dec(3) replace

*垂直专业化指数_进口
 clear
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_imp.xlsx", /*
 */sheet("Sheet1") firstrow clear
 
 destring gdpit gdpct dist contig FTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)

ppml index_imp FTA lgdpit lgdpct ldist contig       //不显著
est store m1
ppml index_imp IV_total lgdpit lgdpct ldist contig  //以下均显著为负
est store m2
ppml index_imp IV_core lgdpit lgdpct ldist contig
est store m3
ppml index_imp IV_score1 lgdpit lgdpct ldist contig
est store m4
ppml index_imp IV_score2 lgdpit lgdpct ldist contig
est store m5
ppml index_imp IV_score3 lgdpit lgdpct ldist contig
est store m6
ppml index_imp IV_score4 lgdpit lgdpct ldist contig 
est store m7

outreg2 [m1 m2 m3 m4 m5 m6 m7] using 垂直专业化指数_进口,word replace




******检验
*相关性检验
destring FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
corr FTA IV_total IV_core IV_score1 IV_score2 IV_score3 IV_score4 
corr FTA_score4 IV_total IV_core IV_score1 IV_score2 IV_score3 IV_score4 //FTA FTA_total FTA_core与工具变量负相关，
                                                                         //FTA_score*与工具变量正相关









