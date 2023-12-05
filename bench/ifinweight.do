cscript 

// if
use bench/auto
keep if weight < 3600
decomph rep78 foreign
storedresults save mustbetrue r()

use bench/auto, clear
decomph rep78 foreign if weight < 3600
storedresults compare mustbetrue r()

storedresults drop mustbetrue

use bench/auto
gen byte expensive:exp_lb = price > 5000 if price < .
label define exp_lb 0 "cheap" 1 "expensive"
keep if weight < 3600
decomph rep78 foreign, over(expensive)
storedresults save mustbetrue r()

use bench/auto, clear
gen byte expensive:exp_lb = price > 5000 if price < .
label define exp_lb 0 "cheap" 1 "expensive"
decomph rep78 foreign if weight < 3600, over(expensive)
storedresults compare mustbetrue r()

storedresults drop mustbetrue

// in
use bench/auto, clear
keep in 1/55
decomph rep78 foreign
storedresults save mustbetrue r()

use bench/auto, clear
decomph rep78 foreign in 1/55
storedresults compare mustbetrue r()

storedresults drop mustbetrue

use bench/auto, clear
gen byte expensive:exp_lb = price > 5000 if price < .
label define exp_lb 0 "cheap" 1 "expensive"
keep in 1/55
decomph rep78 foreign, over(expensive)
storedresults save mustbetrue r()

use bench/auto, clear
gen byte expensive:exp_lb = price > 5000 if price < .
label define exp_lb 0 "cheap" 1 "expensive"
decomph rep78 foreign in 1/55, over(expensive)
storedresults compare mustbetrue r()

storedresults drop mustbetrue

// weight
use bench/auto, clear
gen w = mod(_n,5) + 1
expand w
decomph rep78 foreign
storedresults save mustbetrue r()

use bench/auto, clear
gen w = mod(_n,5) + 1
decomph rep78 foreign [fw=w]
storedresults compare mustbetrue r()

storedresults drop mustbetrue

use bench/auto, clear
gen w = mod(_n,5) + 1
gen byte expensive:exp_lb = price > 5000 if price < .
label define exp_lb 0 "cheap" 1 "expensive"
expand w
decomph rep78 foreign, over(expensive)
storedresults save mustbetrue r()

use bench/auto, clear
gen w = mod(_n,5) + 1
gen byte expensive:exp_lb = price > 5000 if price < .
label define exp_lb 0 "cheap" 1 "expensive"
decomph rep78 foreign [fw=w], over(expensive)
storedresults compare mustbetrue r()

storedresults drop mustbetrue