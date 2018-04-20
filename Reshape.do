 clear all
 global this_dir   "E:\2018\2018-3-12-论文-BITs\控制变量"
 cd "$this_dir"
 * 导入数据
 import excel "GDP.xls", sheet("Data") firstrow clear
 * 1.wide to long
 reshape long y_,i(CountryCode) j(year)
 * 2.long to wide
 * 导出数据
 export excel using "E:\2018\2018-3-12-论文-BITs\控制变量\GDP_reshaped.xlsx", /*
 */firstrow(variables) replace
 
