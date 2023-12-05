cscript 
use bench/auto, clear
gen byte expensive:exp_lb = price > 5000 if price < .
label define exp_lb 0 "cheap" 1 "expensive"

decomph rep78 foreign if expensive == 0
matrix T_H = r(H)
matrix T_percent = r(percent)
matrix T_N = r(N)
scalar T_maxH = r(maxH)
local k = r(k)
decomph rep78 foreign if expensive == 1
matrix T_H = T_H \ r(H)
matrix T_percent = T_percent \ r(percent)
matrix T_N = T_N \ r(N)
scalar T_maxH = max(T_maxH, r(maxH))
local k = max(`k',r(k))

decomph rep78 foreign , over(expensive)
assert mreldif(T_H, r(H)) < 1e-8
assert mreldif(T_percent, r(percent)) < 1e-8
assert mreldif(T_N, r(N)) < 1e-8
assert reldif(T_maxH, r(maxH)) < 1e-8
assert r(k)==`k'
