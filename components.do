*主成分估计
**根据主成分贡献率
*一般来说，主成分的累积方差贡献率达到80%以上的前几个主成分，都可以选作最后的几个主成分
**根据特征根的大小
*一般情况下，当特征根小于1时，不再选作主成分，因为该主成分的解释力度还不如直接用原始变量的解释力度大
sysuse auto,clear
pca trunk weight length headroom
pca trunk weight length headroom,comp(2) covariance

webuse bg2,clear
pca bg2cost*,vce(normal)


*EStat
*estat给出了几个非常有用的工具，包括KMO、SMC等指标
webuse bg2,clear
pca bg2cost*,vce(normal)
estat anti
estat kmo //Kaiser-Meyer-Olkin抽样充分性测度也是用于测量变量之间相关关系的强弱的重要指标，是通过比较两个变量的相关系数与偏相关系数得到的。
          //KMO介于0于1之间。KMO越高，表明变量的共性越强。如果偏相关系数相对于相关系数比较高，则KMO比较低，主成分分析不能起到很好的数据约化效果。
          //0.60-0.69，勉强接受（mediocre）；0.70-0.79,可以接受（middling）；0.80-0.89，比较好（meritorious）；0.90-1.00,非常好（marvelous）。
estat loadings
estat residuals
estat smc //SMC即一个变量与其他所有变量的复相关系数的平方，也就是复回归方程的可决系数。
          //SMC比较高表明变量的线性关系越强，共性越强，主成分分析就越合适。
estat summarize

*预测
*Stata可以通过predict预测变量得分、拟合值和残差等
webuse bg2,clear
pca bg2cost*,vce(normal)
predict score fit residual q //q代表残差平方和


*碎石图
webuse bg2,clear
pca bg2cost*,vce(normal)
screeplot

*得分图、载荷图
*得分图即不同主成分的散点图，命令为scoreplot
webuse bg2,clear
pca bg2cost*,vce(normal)
scoreplot
*载荷图即不同主成分载荷的散点图，命令为loadingplot
webuse bg2,clear
pca bg2cost*,vce(normal)
loadingplot


****PCA-Depth
 clear

 set more off 
 cap log close
 cd "E:\2018\2018-3-20-GVC\数据\PTA depth数据\pta-bilateral-observations_0\workplace"
 log using "E:\2018\2018-3-20-GVC\数据\PTA depth数据\pta-bilateral-observations_0\主成分分析.log",replace

 set matsize 5000
 /*载入数据*/
 import excel "E:\2018\2018-3-20-GVC\数据\PTA depth数据\pta-bilateral-observations_0\workplace\pca_depth_total.xlsx", sheet("Sheet1") firstrow clear
 pca wto_*,vce(normal) //Eigenvalue-特征根；Proportion-方差贡献率；Cumulative-累积方差贡献率；
 
 pca wto_*,comp(10)         //得因子载荷矩阵，系数越大，说明主成分对该变量的代表性越大
 estat loading,cnorm(eigen) //得成分矩阵
                            //成分矩阵/sqrt（对应的特征值）=因子载荷矩阵=sqrt（对应的特征值）*成分得分系数矩阵
 
 estat anti
 estat kmo
 estat loadings
 estat residuals
 estat smc
 estat summarize

 screeplot
 loadingplot
 
 predict f1 f2 f3 f4 f5 f6 f7 f8 f9 f10,score
 *2015
 gen score1=0.2996*f1+0.1670*f2+0.0735*f3 //50%
 gen score2=0.2996*f1+0.1670*f2+0.0735*f3+0.0644*f4+0.0437*f5+0.0409*f6 //60%
 gen score3=0.2996*f1+0.1670*f2+0.0735*f3+0.0644*f4+0.0437*f5+0.0409*f6+0.0349*f7+0.0299*f8+0.0272*f9 //70% 
 gen score4=0.2996*f1+0.1670*f2+0.0735*f3+0.0644*f4+0.0437*f5+0.0409*f6+0.0349*f7+0.0299*f8+0.0272*f9+0.0214*f10 //80%
 *total
 gen score1=0.3088*f1+0.1469*f2+0.0721*f3+0.0644*f4 //50%
 gen score2=0.2996*f1+0.1670*f2+0.0735*f3+0.0644*f4+0.0437*f5+0.0409*f6 //60%
 gen score3=0.3088*f1+0.1469*f2+0.0721*f3+0.0575*f4+0.0523*f5+0.0429*f6+0.0395*f7+0.0333*f8+0.0291*f9 //70% 
 gen score4=0.3088*f1+0.1469*f2+0.0721*f3+0.0575*f4+0.0523*f5+0.0429*f6+0.0395*f7+0.0333*f8+0.0291*f9+0.0261*f10 //80%
 
 export excel using "E:\2018\2018-3-20-GVC\数据\PTA depth数据\pta-bilateral-observations_0\workplace\主成分分析_综合得分_总.xlsx", /*
 */firstrow(variables) replace
 
 
 /*贸易强国共性指标——主成分分析*/
 clear
 set more off 
 cap log close
 cd "E:\2018\2018-3-27-主成分分析\workplace"
 log using "E:\2018\2018-3-27-主成分分析\workplace\主成分分析.log",replace
 set matsize 5000
 /*载入数据*/
 import excel "E:\2018\2018-3-27-主成分分析\workplace\贸易强国共性指标汇总.xls", sheet("Sheet3") firstrow clear
 destring X_*,replace
 pca X_*,vce(normal) //Eigenvalue-特征根；Proportion-方差贡献率；Cumulative-累积方差贡献率；
 
 pca X_*,comp(2)         //得因子载荷矩阵，系数越大，说明主成分对该变量的代表性越大
 estat loading,cnorm(eigen) //得成分矩阵
                            //成分矩阵/sqrt（对应的特征值）=因子载荷矩阵=sqrt（对应的特征值）*成分得分系数矩阵
 
 estat anti
 estat kmo
 estat loadings
 estat residuals
 estat smc
 estat summarize

 screeplot
 loadingplot
 
 *查看变量间的相关性
 *变量之间的存在较强的相关关系，适合作主成分分析  
corr X_*

*因子分析
factor X_*,pcf //类似于 pca X_*,vce(normal)
rotate        //rotate矩阵旋转

predict f1 f2  //两个因子得分
gen f=0.6889*f1/(0.6889+0.1679)+0.1679*f2/(0.6889+0.1679)  //综合得分
 
 export excel using "E:\2018\2018-3-27-主成分分析\贸易强国共性指标_因子分析.xlsx", /*
 */firstrow(variables) replace

 *主成分散点图
 import excel "E:\2018\2018-3-27-主成分分析\贸易强国共性指标_主成分分析.xlsx", sheet("Sheet2") firstrow clear
scatter 主成分1得分 主成分2得分,mlabel(country)
 *因子散点图
  import excel "E:\2018\2018-3-27-主成分分析\贸易强国共性指标_因子分析.xlsx", sheet("Sheet2") firstrow clear
scatter f1 f2,mlabel(country)
 
 
 
 
