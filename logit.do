*Logit模型
clear all
sysuse auto 
logit foreign weight mpg
*获得个体取值为1的概率。 对比一下结果，判断有正有误
predict p1,pr
list p1 foreign
*对预测准确率的判断
estat class
*受试者操控曲线（ROC曲线），是指敏感性与（1-特异性）的散点图，即预测值等于1的准确率与错误率的散点图
lroc
*goodness-of-fit拟合优度检验
estat gof
*变量的边际影响。回归结果中，估计量并非“边际效应”，因此要用命令：
mfx


*Probit模型
clear all
sysuse auto
probit foreign weight mpg
//probit foreign weight mpg,vce(robust)


*综合例子


