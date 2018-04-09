set more off
cd /Users/oji/Desktop/study/environment/期末论文
use EKC.dta,clear

rename 以08年为基期调整后的人均地区生产总值 ngdp
rename 地区 region
rename 年份 year
rename 工业废气排放总量亿标立方米 fq
rename 工业废水排放总量万吨 fs
rename 工业固体废物产生量万吨 gf
rename 实际利用外商直接投资万美元 FDI


generate ngdp1=ln(ngdp)
generate ngdp2=(ln(ngdp))^2
generate lfq=ln(fq)
generate lfs=ln(fs)
generate lgf=ln(gf)

tsset regionid year

reg lgf ngdp1 ngdp2 FDI
est store 固体废弃物

reg lfs ngdp1 ngdp2 FDI
est store 废水

reg lfq ngdp1 ngdp2 FDI
est store 废气

est tab 废水 废气 固体废弃物,star( .1 .05 .01)
