reg fq gdppc gdppc2 fdi
est store m1
reg fs gdppc gdppc2 fdi
est store m2
reg gf gdppc gdppc2 fdi
est store m3
outreg2 [m1 m2 m3] using table92,word


reg so2total year_fe* gdppc gdppc2 fdi
est store m1
reg so2industry gdppc gdppc2 fdi
est store m2
reg so2living gdppc gdppc2 fdi
est store m3
outreg2 [m1 m2 m3] using table93,word

egen yearfe=group(year)
     tabulate yearfe,generate(year_fe)
egen regionfe=group(region)
     tabulate regionfe,generate(region_fe)
