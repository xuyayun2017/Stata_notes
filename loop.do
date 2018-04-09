clear
set obs 100
set seed 10101
generate x1var=runiform()        //生成四个变量
generate x2var=runiform()
generate x3var=runiform()
generate x4var=runiform()
generate sum=x1var+x2var+x3var+x4var
summarize sum

*the foreach loop
quietly replace sum=0
foreach var of varlist x1var x2var x3var x4var {  //varlist 
quietly replace sum=sum+`var'    //`var'局部宏
}
summarize sum

*the forvalues loop
quietly replace sum=0
forvalues i=1(3)4{          //i=1/4   1-4;or i=1(3)4 从1跳到4，即取第一列和第四列
quietly replace sum=sum+x`i'var
}
summarize sum

*while loop 
quietly replace sum=0
local i 1
while `i'<=4{
quietly replace sum=sum+x`i'var
local i=`i'+1
}
summarize sum
