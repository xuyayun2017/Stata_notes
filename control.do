clear all
global this_dir   "C:\Stata14\ado\personal\test"
cd "$this_dir"
use control3, clear

set memory 50m 
set matsize 5000
set maxvar 32000

gen ltrade=ln(trade)
gen lgdp1=ln(gdp1)
gen lgdp2=ln(gdp2)
gen lgdppc1=ln(gdppc1)
gen lgdppc2=ln(gdppc2)
gen ldist=ln(dist)

*OLS-存在异方差性
reg ltrade pta lgdp1 lgdp2 ldist comcol comlang_ethno 
*BP检验
estat hettest
*怀特检验
estat imtest,white
*RESET test
estat ovtest
*检验共线性 vif是方差膨胀因子，结果要和10比较，越小越好，大于10的话共线性问题就很严重
estat vif 

est store m1
reg ltrade depth lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m2
reg ltrade similarity lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m4
reg ltrade scope lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m3
reg ltrade simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m5
outreg2 [m1 m2 m3 m4 m5] using table77,word

*Tobit-零观测值
tobit ltrade pta lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1)
est store m1
tobit ltrade depth lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1)
est store m2
tobit ltrade similarity lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1) 
est store m4
tobit ltrade scope lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1) 
est store m3
tobit ltrade simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1) 
est store m5
outreg2 [m1 m2 m3 m4 m5] using table80,word


*PPML-包括0贸易流量
ppml trade pta lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m1
ppml trade depth lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m2
ppml trade similarity lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m4
ppml trade scope lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m3
ppml trade simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m5
outreg2 [m1 m2 m3 m4 m5] using table81,word

*PPML-删除0贸易流量
drop if trade==0
ppml trade pta lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m1
ppml trade depth lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m2
ppml trade similarity lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m4
ppml trade scope lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m3
ppml trade simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m5
outreg2 [m1 m2 m3 m4 m5] using table82,word

*PPML加固定效应
egen exp_time=group(exp year)
     tabulate exp_time,generate(EXPORTER_TIME_FE)
egen imp_time=group(imp year)
     tabulate imp_time,generate(IMPORTER_TIME_FE)
egen pair_id=group(exp imp)
     tabulate pair_id,generate(PAIR_FE)
	 
*1.加国家-年份固定效应
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* pta lgdp1 lgdp2 ldist comcol comlang_ethno
est store m1
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* depth lgdp1 lgdp2 ldist comcol comlang_ethno
est store m2
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* similarity lgdp1 lgdp2 ldist comcol comlang_ethno
est store m4
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* scope lgdp1 lgdp2 ldist comcol comlang_ethno
est store m3
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno
est store m5
outreg2 [m1 m2 m3 m4 m5] using table83,word

*检验固定效应是否显著
test EXPORTER_TIME_FE1 IMPORTER_TIME_FE1


*2.加国家-国家固定效应
ppml trade PAIR_F* pta lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m1
ppml trade PAIR_F* depth lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m2
ppml trade PAIR_F* similarity lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m4
ppml trade PAIR_F* scope lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m3
ppml trade PAIR_F* simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m5
outreg2 [m1 m2 m3 m4 m5] using table84,word

*检验固定效应是否显著
test PAIR_FE1 PAIR_FE2 PAIR_FE3

*3.加国家-年份、国家-国家固定效应
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* pta lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m1
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* depth lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m2
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* similarity lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m4
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* scope lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m3
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m5
outreg2 [m1 m2 m3 m4 m5] using table85,word

*wanglu
tostring year,replace
g exp_imp_year=exp+imp+year
egen feexp_imp_year=group(exp_imp_year)

xtset feexp_imp_year
destring year,replace force
xtreg trade pta lgdp1 lgdp2 ldist comcol comlang_ethno ,fe

*zhangqianhong



*wanglu修改
tostring year,replace
g exp_imp_year=exp+imp+year
egen feexp_imp_year=group(exp_imp_year)
     tabulate feexp_imp_year,generate(TOTAL_FE)
ppml trade TOTAL_F* pta lgdp1 lgdp2 ldist comcol comlang_ethno


*PTA
reg ltrade pta lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m1
tobit ltrade pta lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1)
est store m2
ppml trade pta lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m3
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* pta lgdp1 lgdp2 ldist comcol comlang_ethno
est store m4
ppml trade PAIR_F* pta lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m5
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* pta lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using table86,word

*Depth
reg ltrade depth lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m1
tobit ltrade depth lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1)
est store m2
ppml trade depth lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m3
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* depth lgdp1 lgdp2 ldist comcol comlang_ethno
est store m4
ppml trade PAIR_F* depth lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m5
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* depth lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using table87,word

*Scope
reg ltrade scope lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m1
tobit ltrade scope lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1)
est store m2
ppml trade scope lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m3
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* scope lgdp1 lgdp2 ldist comcol comlang_ethno
est store m4
ppml trade PAIR_F* scope lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m5
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* scope lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using table88,word

*Similarity
reg ltrade similarity lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m1
tobit ltrade similarity lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1)
est store m2
ppml trade similarity lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m3
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* similarity lgdp1 lgdp2 ldist comcol comlang_ethno
est store m4
ppml trade PAIR_F* similarity lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m5
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* similarity lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using table89,word

*quintiles
reg ltrade simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m1
tobit ltrade simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno,ll(1)
est store m2
ppml trade simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno 
est store m3
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno
est store m4
ppml trade PAIR_F* simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m5
ppml trade EXPORTER_TIME_FE* IMPORTER_TIME_FE* PAIR_F* simq1 simq2 simq3 simq4 simq5 lgdp1 lgdp2 ldist comcol comlang_ethno ,cluster(pair_id)
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using table90,word


