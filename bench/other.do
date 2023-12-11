cscript
use bench\auto

//dseg
net install st0682, from(http://www.stata-journal.com/software/sj22-3) replace
//entropyetc
ssc install entropyetc, replace

entropyetc rep78 if !missing(foreign)
scalar O_H = el(r(entropyetc),1,1)

dseg mutual rep78, given(foreign)
scalar O_I = el(r(S),1,1)

decomph rep78 foreign, base(`=exp(1)')
assert reldif(O_H, el(r(H),1,1)) < 1E-8
assert reldif(O_I, el(r(H),1,3)) < 1E-8