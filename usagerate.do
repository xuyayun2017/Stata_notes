 clear

 set more off 
 cap log close
 cd "C:\U盘备份-2\2018-2-14-利用率\瑞士利用率_xyy"
 log using "C:\U盘备份-2\2018-2-14-利用率\瑞士利用率_xyy\瑞士利用率_xyy.log",replace

 /*载入数据*/
 import excel "C:\U盘备份-2\2018-2-14-利用率\瑞士利用率_xyy\2017.xlsx", sheet("Sheet1") firstrow clear
 gen total_Value=Value+usage_Value,before(usage_Value)
 drop Value
 save 2017,replace
 
 
 /*与关税减让表合并*/
 /*2017年*/
 use 关税减让表,clear
 sort Hscode
 keep Hscode cover duty          //duty--mfn>0    cover--mfn>fta
 save 关税减让表,replace
 use 2017,clear 
 sort Month Hscode
 merge m:1 Hscode using 关税减让表
 sort Month Hscode
 drop if Month==""
 
 replace cover=1 if usage_Value>0              //使用优惠税率时，令cover=1
 replace cover=0 if usage_Value==0 & cover==.  //没有使用优惠税率
 replace duty=1 if cover==1                     
 replace duty=0 if duty==.
 
 drop _merge
 gen cover_value=total_Value*cover,before(cover) //C+D:mfn>fta
 gen duty_value=total_Value*duty,before(cover)  //B+C+D:mfn>0
 gen sum_value=total_Value,before(cover)        //A+B+C+D
 drop total_Value cover duty
 rename usage_Value usage_value
 save 2017,replace
 
 
 /*分行业年度计算*/
 
 /*合成行业大类*/
 gen Hscode2=substr(Hscode,1,2),before(Hscode)  //取编码前两位
 destring Hscode2,gen(kk)               
 gen hangye="01" if kk>=1 & kk<=5,before(Hscode2)
 replace hangye="02" if kk>=6 & kk<=14
 replace hangye="03" if kk>=15 & kk<=15
 replace hangye="04" if kk>=16 & kk<=24
 replace hangye="05" if kk>=25 & kk<=27
 replace hangye="06" if kk>=28 & kk<=38
 replace hangye="07" if kk>=39 & kk<=40
 replace hangye="08" if kk>=41 & kk<=43
 replace hangye="09" if kk>=44 & kk<=46
 replace hangye="10" if kk>=47 & kk<=49
 replace hangye="11" if kk>=50 & kk<=63
 replace hangye="12" if kk>=64 & kk<=67
 replace hangye="13" if kk>=68 & kk<=70
 replace hangye="14" if kk>=71 & kk<=71
 replace hangye="15" if kk>=72 & kk<=83
 replace hangye="16" if kk>=84 & kk<=85
 replace hangye="17" if kk>=86 & kk<=89
 replace hangye="18" if kk>=90 & kk<=92
 replace hangye="19" if kk>=93 & kk<=93
 replace hangye="20" if kk>=94 & kk<=96
 replace hangye="21" if kk>=97 & kk<=97
 replace hangye="22" if kk>=98 
 drop kk
 sort hangye Hscode2 
 /*加总数据*/
 by hangye: egen usagevalue=total(usage_value)
 by hangye: egen covervalue=total(cover_value)
 by hangye: egen dutyvalue=total(duty_value)
 by hangye: egen sumvalue=total(sum_value)
 
 by hangye: gen num=_n   
 keep if num==1
 keep Year hangye usagevalue covervalue dutyvalue sumvalue
 
 gen usagerate=(usagevalue/covervalue)
 gen coverrate=(covervalue/dutyvalue)
 
 save 2015_00,replace
  
 
 use 2015_00,clear
 export excel using "E:\2017\2018-2-14-利用率\瑞士利用率_xyy\2015年行业分类利用率.xlsx", /*
 */firstrow(variables) replace
 
 
 /*计算分月份总体利用率*/

 sort Month Hscode 
 by Month: egen usagevalue=total(usage_value)
 by Month: egen covervalue=total(cover_value)
 by Month: egen dutyvalue=total(duty_value)
 by Month: egen sumvalue=total(sum_value)
 
 by Month: gen num=_n
 keep if num==1
 keep Year Month usagevalue covervalue dutyvalue sumvalue
 gen usagerate=(usagevalue/covervalue)
 gen coverrate=(covervalue/dutyvalue)
 
 save 2017_01,replace

 use 2017_01,clear
 export excel using "E:\2017\2018-2-14-利用率\瑞士利用率_xyy\2017年月度利用率.xlsx", /*
 */firstrow(variables) replace

/*计算八位产品利用率*/
 sort Hscode 
 by Hscode: egen usagevalue=total(usage_value)
 by Hscode: egen covervalue=total(cover_value)
 by Hscode: egen dutyvalue=total(duty_value)
 by Hscode: egen sumvalue=total(sum_value)
 
 by Hscode: gen num=_n
 keep if num==1
 keep Year Hscode usagevalue covervalue dutyvalue sumvalue
 gen AUR=(usagevalue/covervalue)
 gen 未调整=(usagevalue/dutyvalue)
 gen GUR=(usagevalue/sumvalue)
 
   export excel using "C:\U盘备份-2\2018-2-14-利用率\瑞士利用率_xyy\利用率_产品.xlsx", /*
 */firstrow(variables) replace
 
 /*计算两位利用率*/
  sort HS2 
 by HS2: egen usagevalue=total(usage_value)
 by HS2: egen covervalue=total(cover_value)
 by HS2: egen dutyvalue=total(duty_value)
 by HS2: egen sumvalue=total(sum_value)
 
 by HS2: gen num=_n
 keep if num==1
 keep Year HS2 usagevalue covervalue dutyvalue sumvalue
 
 gen GUR=(usagevalue/sumvalue)
 gen AUR=(usagevalue/covervalue)
 gen 未调整=(usagevalue/dutyvalue)
 
 
   export excel using "C:\U盘备份-2\2018-2-14-利用率\瑞士利用率_xyy\2017出口利用率_HS2.xlsx", /*
 */firstrow(variables) replace
 
 
 
 
 
 
 
