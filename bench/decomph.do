cscript
use bench\auto
decomph rep78 foreign

assert         r(k)    == 5
assert reldif( r(maxH)  , 2.321928094887362 ) <  1E-8
assert         r(N)    == 69

qui {
mat T_percent = J(1,3,0)
mat T_percent[1,1] =                100
mat T_percent[1,2] =  84.03700586625725
mat T_percent[1,3] =  15.96299413374276
}
matrix C_percent = r(percent)
assert mreldif( C_percent , T_percent ) < 1E-8
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
_assert_streq `"`: rowfullnames C_H'"' `"H"'
_assert_streq `"`: colfullnames C_H'"' `"total within between"'
mat drop C_H T_H

gen byte wcat:wcat_lab = 1 if weight < 2200
replace wcat           = 2 if inrange(weight,2200, 3200)
replace wcat           = 3 if inrange(weight,3200,3600)
replace wcat           = 4 if weight>3600 & weight < .

label define wcat_lab 1 "light" 2 "medium light" 3 "medium heavy" 4 "heavy"

decomph rep78 foreign, over(wcat)

assert         r(k)    == 5
assert reldif( r(maxH)  , 2.321928094887362 ) <  1E-8

qui {
mat T_percent = J(4,3,0)
mat T_percent[1,1] =                100
mat T_percent[1,2] =  97.65963016321277
mat T_percent[1,3] =  2.340369836787239
mat T_percent[2,1] =                100
mat T_percent[2,2] =  61.60136396085026
mat T_percent[2,3] =  38.39863603914972
mat T_percent[3,1] =                100
mat T_percent[3,2] =                100
mat T_percent[4,1] =                100
mat T_percent[4,2] =                100
}
matrix C_percent = r(percent)
assert mreldif( C_percent , T_percent ) < 1E-8
_assert_streq `"`: rowfullnames C_percent'"' `"light medium_light medium_heavy heavy"'
_assert_streq `"`: colfullnames C_percent'"' `"total within between"'
mat drop C_percent T_percent

qui {
mat T_H = J(4,3,0)
mat T_H[1,1] =  1.565596230357602
mat T_H[1,2] =  1.528955488416435
mat T_H[1,3] =  .0366407419411674
mat T_H[2,1] =  2.104292989590925
mat T_H[2,2] =  1.296273183320563
mat T_H[2,3] =  .8080198062703621
mat T_H[3,1] =  1.086312840741288
mat T_H[3,2] =  1.086312840741288
mat T_H[4,1] =   1.38210225325431
mat T_H[4,2] =   1.38210225325431
}
matrix C_H = r(H)
assert mreldif( C_H , T_H ) < 1E-8
_assert_streq `"`: rowfullnames C_H'"' `"light medium_light medium_heavy heavy"'
_assert_streq `"`: colfullnames C_H'"' `"total within between"'
mat drop C_H T_H

qui {
mat T_N = J(4,1,0)
mat T_N[1,1] =                 15
mat T_N[2,1] =                 19
mat T_N[3,1] =                 17
mat T_N[4,1] =                 18
}
matrix C_N = r(N)
assert mreldif( C_N , T_N ) < 1E-8
_assert_streq `"`: rowfullnames C_N'"' `"light medium_light medium_heavy heavy"'
_assert_streq `"`: colfullnames C_N'"' `"c1"'
mat drop C_N T_N

