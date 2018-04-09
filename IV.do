*增加值TiVA-intermediates
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates.xlsx", /*
 */sheet("Sheet1") firstrow clear

destring gdpit gdpct dist contig,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(imp_value)

*工具变量与内生解释变量的关系
reg FTA IV_total lgdpit lgdpct ldist contig,r
est store m1
reg FTA IV_core lgdpit lgdpct ldist contig,r
est store m2
reg FTA IV_score1 lgdpit lgdpct ldist contig,r
est store m3
reg FTA IV_score2 lgdpit lgdpct ldist contig,r
est store m4
reg FTA IV_score3 lgdpit lgdpct ldist contig,r
est store m4
reg FTA IV_score4 lgdpit lgdpct ldist contig,r
est store m5
outreg2 [m1 m2 m3 m4 m5] using table1,word replace
outreg2 [m5] using table2,word replace

reg FTA num2 IV_total IV_core IV_score4 lgdpit lgdpct ldist contig,r
*IV与被解释变量的关系
reg lvalue FTA IV_total lgdpit lgdpct ldist contig,r

*使用ivregress s2ls 
*以伙伴国与第三国协定数量作为IV
ivregress 2sls lvalue (FTA=num2 IV_total IV_core IV_score4) lgdpit lgdpct ldist contig,r 
ivregress 2sls lvalue (FTA=num_sum) lgdpit lgdpct ldist contig,r 
*以双方与第三国协定的平均深度作为工具变量
reg lvalue FTA lgdpit lgdpct ldist contig,r        
est store m1
ivregress 2sls lvalue (FTA=IV_total) lgdpit lgdpct ldist contig,r 
est store m2
ivregress 2sls lvalue (FTA=IV_core) lgdpit lgdpct ldist contig,r  
est store m3
ivregress 2sls lvalue (FTA=IV_score1) lgdpit lgdpct ldist contig,r 
est store m4
ivregress 2sls lvalue (FTA=IV_score2) lgdpit lgdpct ldist contig,r
est store m5
ivregress 2sls lvalue (FTA=IV_score3) lgdpit lgdpct ldist contig,r 
est store m6
ivregress 2sls lvalue (FTA=IV_score4) lgdpit lgdpct ldist contig,r 
est store m7
outreg2 [m1 m2 m3 m4 m5 m6 m7] using IVREGRESS_中间产品进口_s2ls_,word replace

*过渡识别检验
*工具变量的数目少于或等于内生变量是不用做sargan检验，因为不存在过度识别问题
estat overid    
            
*工具变量与内生变量的相关性
*虽然2sls是一致的，但却是有偏的，故使用2sls会带来“显著性水平扭曲”（size distortion）,而且这种扭曲随着若工具变量而增大
*这一检验可表明不存在弱工具变量
estat firststage,all forcenonrobust  

*为稳健起见，下面使用对弱工具变量更不敏感的有限信息最大似然法（LIML）
*结果发现，LIML的系数估计值与2SLS非常接近，这也从侧面印证了“不存在弱工具变量”
ivregress liml lvalue (FTA=IV_total) lgdpit lgdpct ldist contig,r 
est store m2
ivregress liml lvalue (FTA=IV_core) lgdpit lgdpct ldist contig,r  
est store m3
ivregress liml lvalue (FTA=IV_score1) lgdpit lgdpct ldist contig,r 
est store m4
ivregress liml lvalue (FTA=IV_score2) lgdpit lgdpct ldist contig,r 
est store m5
ivregress liml lvalue (FTA=IV_score3) lgdpit lgdpct ldist contig,r 
est store m6
ivregress liml lvalue (FTA=IV_score4) lgdpit lgdpct ldist contig,r 
est store m7
outreg2 [m2 m3 m4 m5 m6 m7] using IVREGRESS_出口增加值_LIML,word replace

*使用工具变量法的前提是存在内生解释变量，须进行豪斯曼（Hausman）检验，原假设是“所有的解释变量均为外生”
qui reg lvalue FTA lgdpit lgdpct ldist contig
estimates store ols
qui ivregress 2sls lvalue (FTA=IV_total) lgdpit lgdpct ldist contig
estimates store iv
hausman iv ols,constant sigmamore
*检验结果表明，可以在0.00%的显著性水平下拒绝“所有变量均外生”的原假设，即认为存在内生解释变量FTA。
*由于传统豪斯曼检验建立在同方差的前提下，故在上述回归中均没有使用稳健标准差

*由于传统Hausman检验在异方差的情形下不成立，下面使用异方差稳健的DWH检验
estat endogenous
*检验结果p=0.0000,据此可认为FTA为内生解释变量


*如果存在异方差，则GMM比2SLS更有效。为此进行如下的最优GMM估计
ivregress gmm lvalue (FTA=IV_total) lgdpit lgdpct ldist contig
est store m2
ivregress gmm lvalue (FTA=IV_core) lgdpit lgdpct ldist contig,r  
est store m3
ivregress gmm lvalue (FTA=IV_score1) lgdpit lgdpct ldist contig,r 
est store m4
ivregress gmm lvalue (FTA=IV_score2) lgdpit lgdpct ldist contig,r 
est store m5
ivregress gmm lvalue (FTA=IV_score3) lgdpit lgdpct ldist contig,r 
est store m6
ivregress gmm lvalue (FTA=IV_score4) lgdpit lgdpct ldist contig,r 
est store m7
outreg2 [m2 m3 m4 m5 m6 m7] using IVREGRESS_出口增加值_GMM,word replace

*进行过渡识别检验
estat overid

*考虑迭代GMM
ivregress gmm lvalue (FTA=IV_total) lgdpit lgdpct ldist contig,igmm
est store Total
ivregress gmm lvalue (FTA=IV_core) lgdpit lgdpct ldist contig,igmm
est store Core
ivregress gmm lvalue (FTA=IV_score1) lgdpit lgdpct ldist contig,igmm
est store Score1
ivregress gmm lvalue (FTA=IV_score2) lgdpit lgdpct ldist contig,igmm 
est store Score2
ivregress gmm lvalue (FTA=IV_score3) lgdpit lgdpct ldist contig,igmm
est store Score3
ivregress gmm lvalue (FTA=IV_score4) lgdpit lgdpct ldist contig,igmm 
est store Score4
outreg2 [Total Core Score1 Score2 Score3 Score4] using IVREGRESS_出口增加值_iGMM,word replace
*如果希望将以上各种估计法的系数估计值及其标准差列在同一张表中：
qui reg lvalue FTA lgdpit lgdpct ldist contig,r
estimates store OLS
qui ivregress 2sls lvalue (FTA=IV_total) lgdpit lgdpct ldist contig,r
estimates store TSLS
qui ivregress liml lvalue (FTA=IV_total) lgdpit lgdpct ldist contig,r
estimates store LIML
qui ivregress gmm lvalue (FTA=IV_total) lgdpit lgdpct ldist contig
estimates store GMM
qui ivregress gmm lvalue (FTA=IV_total) lgdpit lgdpct ldist contig,igmm
estimates store IGMM
estimate table OLS TSLS LIML GMM IGMM


*垂直专业化指数_出口
 clear
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_exp.xlsx", /*
 */sheet("Sheet1") firstrow clear
 destring gdpit gdpct dist contig FTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(index_exp)
*垂直专业化指数_进口
 clear
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_imp.xlsx", /*
 */sheet("Sheet1") firstrow clear
 destring gdpit gdpct dist contig FTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(index_imp)

*总贸易额_出口
import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaexp_daochu.xlsx", /*
 */sheet("chinaexp_daochu") firstrow clear
destring gdpit gdpct dist contig FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(value)
*总贸易额_进口
import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaimp_daochu.xlsx", /*
 */sheet("chinaimp_daochu") firstrow clear
destring gdpit gdpct dist contig FTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(value)



***********************************************************
***********************************************************
*****PPML直接回归
*总贸易额_出口
import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaexp_daochu.xlsx", /*
 */sheet("chinaexp_daochu") firstrow clear
 
destring gdpit gdpct dist contig FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=value/1000

ppml lvalue PTA lgdpit lgdpct ldist contig
est store PTA
ppml lvalue PTA_total lgdpit lgdpct ldist contig
est store Total
ppml lvalue PTA_core lgdpit lgdpct ldist contig
est store Core
ppml lvalue PTA_score1 lgdpit lgdpct ldist contig
est store Score1
ppml lvalue PTA_score2 lgdpit lgdpct ldist contig //进口convergence not achieved
est store Score2
ppml lvalue PTA_score3 lgdpit lgdpct ldist contig //进口convergence not achieved
est store Score3
ppml lvalue PTA_score4 lgdpit lgdpct ldist contig //进口convergence not achieved
est store Score4
outreg2 [PTA Total Core Score1 Score2 Score3 Score4] using PPML_中间产品增加值_总额,word replace

*总贸易额_进口
import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaimp_daochu_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear

 
*中间产品贸易额_出口
 clear
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_exp_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear
destring gdpit gdpct dist contig FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=inter_exp/1000
*中间产品贸易额_进口
 clear
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_imp_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear
destring gdpit gdpct dist contig FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=inter_imp/1000


*中间产品增加值
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear
*出口
destring gdpit gdpct dist contig PTA PTA_total PTA_core PTA_score1 PTA_score2 PTA_score3 PTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=exp_value
*进口
destring gdpit gdpct dist contig PTA PTA_total PTA_core PTA_score1 PTA_score2 PTA_score3 PTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=imp_value
*总额
destring gdpit gdpct dist contig PTA PTA_total PTA_core PTA_score1 PTA_score2 PTA_score3 PTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(total_value)

*********************************************************
*******************将num2作为IV**************************
*********************************************************
***增加值_出口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates.xlsx", /*
 */sheet("Sheet1") firstrow clear
destring gdpit gdpct dist contig,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(exp_value)
ivregress 2sls lvalue (FTA=num2) lgdpit lgdpct ldist contig,r 
est store VA_exp
***增加值_进口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates.xlsx", /*
 */sheet("Sheet1") firstrow clear
destring gdpit gdpct dist contig,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(imp_value)
ivregress 2sls lvalue (FTA=num2) lgdpit lgdpct ldist contig,r 
est store VA_imp
***中间产品贸易额_出口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear
 destring gdpit gdpct dist contig FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(exp_value)
ivregress 2sls lvalue (FTA=num2) lgdpit lgdpct ldist contig,r 
est store Inter_exp
***中间产品贸易额_进口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear
 destring gdpit gdpct dist contig FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(imp_value)
ivregress 2sls lvalue (FTA=num2) lgdpit lgdpct ldist contig,r 
est store Inter_imp
***总贸易额_出口
import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaexp_daochu.xlsx", /*
 */sheet("chinaexp_daochu") firstrow clear
destring gdpit gdpct dist contig FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(value)
ivregress 2sls lvalue (FTA=num2) lgdpit lgdpct ldist contig,r 
est store Total_exp
***总贸易额_进口
import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaimp_daochu_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear
destring gdpit gdpct dist contig FTA FTA_total FTA_core FTA_score1 FTA_score2 FTA_score3 FTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(value)
ivregress 2sls lvalue (FTA=num2) lgdpit lgdpct ldist contig,r 
est store Total_imp
outreg2 [VA_exp VA_imp Inter_exp Inter_imp Total_exp Total_imp] using 与第三国协定数量作为IV,word replace


*********将所有工具变量合并
***增加值_出口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates.xlsx", /*
 */sheet("Sheet1") firstrow clear
destring gdpit gdpct dist contig,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(exp_value)
ivregress gmm lvalue (PTA=num2 IV_total IV_core IV_score4) lgdpit lgdpct ldist contig,r
***增加值_进口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates.xlsx", /*
 */sheet("Sheet1") firstrow clear
destring gdpit gdpct dist contig,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(imp_value)
ivregress gmm lvalue (PTA=num2 IV_total IV_core IV_score4) lgdpit lgdpct ldist contig,r 
est store VA_imp
***中间产品贸易额_出口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_exp.xlsx", /*
 */sheet("Sheet1") firstrow clear
 destring gdpit gdpct dist contig PTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(value)
ivregress gmm lvalue (PTA=num2 IV_total IV_core IV_score4) lgdpit lgdpct ldist contig,r 
est store Inter_exp
***中间产品贸易额_进口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_imp.xlsx", /*
 */sheet("Sheet1") firstrow clear
 destring gdpit gdpct dist contig PTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(value)
ivregress gmm lvalue (PTA=num2 IV_total IV_core IV_score4) lgdpit lgdpct ldist contig,r 
est store Inter_imp
***总贸易额_出口
import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaexp_daochu.xlsx", /*
 */sheet("chinaexp_daochu") firstrow clear
 destring gdpit gdpct dist contig PTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(value)
ivregress gmm lvalue (PTA=num2 IV_total IV_core IV_score4) lgdpit lgdpct ldist contig,r 
est store Total_exp
***总贸易额_进口
import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\chinaimp_daochu.xlsx", /*
 */sheet("chinaimp_daochu") firstrow clear
 destring gdpit gdpct dist contig PTA,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
gen lvalue=ln(value)
ivregress gmm lvalue (PTA=num2 IV_total IV_core IV_score4) lgdpit lgdpct ldist contig,r 
est store Total_imp


******进出口加总
*增加值
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\TiVA_intermediates_加上FTA的三种深度.xlsx", /*
 */sheet("Sheet1") firstrow clear
 destring gdpit gdpct dist contig PTA PTA_total PTA_core PTA_score1 PTA_score2 PTA_score3 PTA_score4,replace
gen lgdpit=ln(gdpit)
gen lgdpct=ln(gdpct)
gen ldist=ln(dist)
//gen lvalue=total_value/1000

gen lvalue=ln(total_value)

ppml lvalue PTA lgdpit lgdpct ldist contig
est store PTA
ppml lvalue PTA_total lgdpit lgdpct ldist contig
est store Total
ppml lvalue PTA_core lgdpit lgdpct ldist contig
est store Core
ppml lvalue PTA_score1 lgdpit lgdpct ldist contig
est store Score1
ppml lvalue PTA_score2 lgdpit lgdpct ldist contig //进口convergence not achieved
est store Score2
ppml lvalue PTA_score3 lgdpit lgdpct ldist contig //进口convergence not achieved
est store Score3
ppml lvalue PTA_score4 lgdpit lgdpct ldist contig //进口convergence not achieved
est store Score4
outreg2 [PTA Total Core Score1 Score2 Score3 Score4] using PPML_总贸易_总额,word replace

ivregress gmm lvalue (PTA=num2 IV_total IV_core IV_score4) lgdpit lgdpct ldist contig,r 
est store 总贸易
outreg2 总贸易 using IV合并_总贸易,word replace

*中间产品 
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\inter_进出口加总.xlsx", /*
 */sheet("Sheet1") firstrow clear
 destring gdpit gdpct dist contig PTA PTA_total PTA_core PTA_score1 PTA_score2 PTA_score3 PTA_score4,replace
*总进出口
 import excel "E:\2018\2018-3-20-GVC\数据\贸易数据\workplace\总贸易_进出口加总.xlsx", /*
 */sheet("Sheet1") firstrow clear

*统计性描述
sum PTA PTA_total PTA_core PTA_score4


