*append
clear all
use beauty.dta, clear
gen id=_n
keep if mod(_n,3)==0 // keep those can be devided by 3
keep id educ looks
list in 1/4, clean
quietly save merge1.dta, replace

use beauty.dta, clear
gen id=_n
keep if mod(_n,2)==0 // keep those can be devided by 2
keep id educ looks
list in 1/4, clean
quietly save merge2.dta, replace

use merge1.dta
sort id
append using merge2.dta
sort id
list in 1/9, clean

