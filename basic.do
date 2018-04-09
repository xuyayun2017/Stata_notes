clear

*append文件夹下所有csv文件
*ssc install csvconvert 安装
*读取所有csv格式的文件
dir E:\2018\2018-3-20-GVC\数据\贸易数据\中间产品贸易额\*.csv 
*将上述csv文件转换为dta
csvconvert E:\2018\2018-3-20-GVC\数据\贸易数据\中间产品贸易额,replace
*显示已经转换的文件
note
*新建文件wb_data.dta,保存在E:\2018\2018-3-20-GVC\数据\贸易数据\中间产品贸易额中
csvconvert E:\2018\2018-3-20-GVC\数据\贸易数据\中间产品贸易额,replace output_file(wb_data.dta) output_dir(E:\2018\2018-3-20-GVC\数据\贸易数据\中间产品贸易额)

 export excel using "E:\2018\2018-3-20-GVC\数据\贸易数据\中间产品贸易额\中间产品贸易额2.xlsx", /*
 */firstrow(variables) replace

 
 
 *merge
 * One-to-one merge on specified key variables--merge 1:1 varlist using filename [, options]
 * Many-to-one merge on specified key variables--merge m:1 varlist using filename [, options]
 * One-to-many merge on specified key variables--merge 1:m varlist using filename [, options]
 * Many-to-many merge on specified key variables--merge m:m varlist using filename [, options]
 * One-to-one merge by observation--merge 1:1 _n using filename [, options]
 *1:1 表示keywords在master和using文件中都是唯一没有重复的
 *1:m 表示keywords在主表（master文件）中必须是唯一没有重复的
 *m:1 表示keyword在辅表（using文件）中必须是唯一没有重复的的
 help merge
 ***example1
 clear
 webuse autosize
 list 
 webuse autoexpense
 list
 *1:1 match merge
 webuse autosize
 merge 1:1 make using http://www.stata-press.com/data/r14/autoexpense, ///
           assert(match)
 tab_merge 
 list
 *1:1 match merge,keeping only matches and squelching the _merge variable
  webuse autosize, clear
  merge 1:1 make using http://www.stata-press.com/data/r14/autoexpense, keep(match) nogen
  list
  
 ***example2
  webuse overlap1, clear
  list, sepby(id)        //按id分类列出
  webuse overlap2
  list
 *m:1 match merge, illustrating update option
  webuse overlap1
  merge m:1 id using http://www.stata-press.com/data/r14/overlap2, update
  list
 *m:1 match merge, illustrating update replace option
  webuse overlap1, clear
  merge m:1 id using http://www.stata-press.com/data/r14/overlap2, update replace
  list
 *1:m match merge, illustrating update replace option
  webuse overlap2, clear
  merge 1:m id using http://www.stata-press.com/data/r14/overlap1, update replace
  list
 *Perform sequential merge
  webuse sforce, clear
  merge 1:1 _n using http://www.stata-press.com/data/r14/dollars
  list
 
 *循环
 *Forvalue
 *Generate 100 uniform random variables named x1, x2, ..., x100
 clear
 set obs 100       //设置样本量为 100 
 set seed 10101    //设置种子数为 10101
 forvalues i = 1(1)100 {         //or i=1/100
     generate x`i' = runiform()
     }
 *For variables x5, x6, ..., x13 output the number of observations greater than 0.5
  forval num = 5/13 {
      count if x`num' > 0.5
      }
 *Produce individual summarize commands for variables x5, x10, ..., x56.
   forvalues k = 5 10 to 56 {
      summarize x`k'
      }
 *A loop over noninteger values that includes more than one command.
   forval x = 0.3 0.6 : 0.8 {
      count if x1 < `x' & x2 < `x'
      //summarize myvar if x1 < `x'
      }

 *Foreach
 
 
 
 
 
 
 
 
 
 
 
 
 
 