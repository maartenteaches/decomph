cscript
run decomph.ado

//Parse_over
use bench/auto.dta
decode foreign, gen(forstr)

Parse_over, byvar(totest1) over(forstr)
count if totest1 == 1 
assert r(N) == 52
assert "`:label (totest1) 1'" == "Domestic"

count if totest1 == 2
assert r(N) == 22
assert "`:label (totest1) 2'" == "Foreign"

Parse_over, byvar(totest2) over(foreign)
count if totest2 == 0 
assert r(N) == 52
assert "`:label (totest2) 0'" == "Domestic"

count if totest2 == 1
assert r(N) == 22
assert "`:label (totest2) 1'" == "Foreign"

Parse_over, byvar(totest3)
assert totest3==1

rcof "noisily Parse_over, byvar(totest4) over(headroom)" == 198

//Chk_varlist
use bench/auto, clear
Chk_varlist rep78 foreign
split make, gen(make)
Chk_varlist make1

rcof "noisily Chk_varlist weight" == 198
rcof "noisily Chk_varlist headroom" == 198

// Estimate
use bench/auto, clear
Estimate rep78 foreign, base(2)

assert         r(N)    == 69
assert         r(k)    == 5
assert reldif( r(maxH)  , 2.321928094887362 ) <  1E-8

qui {
mat T_percent = J(1,3,0)
mat T_percent[1,1] =                100
mat T_percent[1,2] =  84.03700586625725
mat T_percent[1,3] =  15.96299413374276
}
matrix C_percent = r(percent)
assert mreldif( C_percent , T_percent ) < 1E-8
assert reldif(C_percent[1,1], C_percent[1,2] + C_percent[1,3]) < 1E-8
_assert_streq `"`: rowfullnames C_percent'"' `"%"'
_assert_streq `"`: colfullnames C_percent'"' `"total within between"'
mat drop C_percent T_percent

qui {
mat T_H = J(1,3,0)
mat T_H[1,1] =   1.95897205534009
mat T_H[1,2] =  1.646261461064492
mat T_H[1,3] =  .3127105942755986
}
matrix C_H = r(H)
assert mreldif( C_H , T_H ) < 1E-8
assert reldif(C_H[1,1] , C_H[1,2] + C_H[1,3]) < 1E-8
_assert_streq `"`: rowfullnames C_H'"' `"H"'
_assert_streq `"`: colfullnames C_H'"' `"total within between"'
mat drop C_H T_H
