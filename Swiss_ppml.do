 clear all
 global this_dir   "E:\2018\2018-4-22-中瑞利用率"
 cd "$this_dir"
 
 * 第一步：基本处理
 use 2014.dta,clear
 rename 进口年份 year
 rename hscode8 hs8
 gen hs2 = substr(hs8,1,2),before(hs8)
 gen hs4 = substr(hs8,1,4),before(hs8)
 gen hs6 = substr(hs8,1,6),before(hs8)
 
 gen month=substr(进口日期,1,2),before(进口日期)
 replace month="1" if month=="01"
 replace month="2" if month=="02"
 replace month="3" if month=="03"
 replace month="4" if month=="04"
 replace month="5" if month=="05"
 replace month="6" if month=="06"
 replace month="7" if month=="07"
 replace month="8" if month=="08"
 replace month="9" if month=="09"
 destring month,replace force
 sort month
 
 tostring year month,replace force
 gen period=year+"-"+month
 destring year month,replace force
 keep year month period hs2 hs4 hs6 hs8 申报金额 关税税值
 order year month period hs2 hs4 hs6 hs8 申报金额 关税税值
 save 2016_modified,replace
 
 * 第二步：根据year,month,hs8加总
 use 2017_modified,clear
 sort year month hs8
 by year month hs8: egen import_value=total(申报金额)
 by year month hs8: egen tariff_revenue=total(关税税值)
 * 删除重复值
 duplicates drop year month hs8 import_value tariff_revenue,force
 save 2017_modified,replace
 
 * 第三步：2014-2017关税减让表
 destring fta tariff_mfn_fta,replace force
 sort hs8
 duplicates drop hs8,force
 save 中方关税减让表_2017,replace
 
 * 第四步：Merge
 use 2017_modified,clear
 sort month hs8
 merge m:1 hs8 using 中方关税减让表_2017
 sort month hs8
 drop if month==""
 save merged_2017,replace
 
 * 第五步：Append
 use merged_2014,clear
 sort year month hs8
 append using merged_2015 merged_2016 merged_2017
 sort year month hs8
 save appended_2014_2017,replace
 
 * 第六步：回归
 use appended_2014_2017,clear
 egen pp = group(period)                       // year-month FE
	qui: tab pp, gen(p_fe)
 egen c2 = group(hs2)         // hs2 FE
	qui: tab c2, gen(c2_fe)
 egen period_c2 = group(period hs2)
	qui: tab period_c2, gen(pc2_fe)

 ppml 	import_value tariff_mfn_fta ///
			p_fe* c2_fe* ///
			, cluster(period_c2)
			
 outreg2 ///
		tariff_mfn_fta ///
		using ../GravityCH.xls, ///
		keep(tariff_mfn_fta) ///
		excel  ctitle(margins)  label cttop(1) dec(3) nocons append
 
 * 取对数
 gen ltariff_mfn_fta=ln(tariff_mfn_fta)
 ppml 	import_value ltariff_mfn_fta ///
			p_fe* c2_fe* ///
			, cluster(period_c2)
		
 
 
 
 
 
 