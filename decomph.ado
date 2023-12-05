*! version 0.1.0 04Dec2023 MLB
program define decomph
	version 18
	syntax varlist(min=2 max=2) [if] [in] [pweight fweight], ///
	      [base(real 2) over(passthru) name(name) maxcat(passthru)] 
	
	if `base' <= 0 {
		display as err "the base must be larger than 0"
		exit 198
	}
	if "`name'" == "" {
		local name = "decomph"
	}
	qui collect create `name', replace
	
	marksample touse
	
	if "`weight'" != "" local wgt = "[`weight' `exp']"
	Chk_varlist `varlist' if `touse', `maxcat'
	
	tempvar byvar
	Parse_over, `over' byvar(`byvar')
	Est_over `varlist' if `touse' `wgt', base(`base') `over' byvar(`byvar') name(`name')
	Display , name(`name') `over'
end

program define Chk_varlist
	syntax varlist [if], [maxcat(integer 50)]
	marksample touse
	
	foreach var of local varlist {
		capture confirm numeric variable `var'
		if _rc == 0 {
			capture assert `var' == floor(`var')
			if _rc == 9 {
				di as err "the variable `var' should be an integer or a string"
				exit 198
			}
			else if _rc != 0 {
				di as err "this error should not occur"
				exit _rc
			}
		}
		else if _rc != 7{
			di as err "this error should not occur"
			exit _rc
		}
		qui levelsof `var'
		if `:word count `r(levels)'' > `maxcat' {
			di as err "the variable `var' must be a categorical variable"
			di as err "the variable `var' has more than `maxcat' values"
			di as err "{p}if you are sure that `var' is still categorical, you can increase the maximum with the option maxcat(){p_end}"
			exit 198
		}
	}
end

program define Parse_over
	syntax [if], byvar(string) [over(varname)]
	
	marksample touse
	
	if "`over'" == "" {
		gen byte `byvar' = 1
		exit
	}
	capture confirm numeric variable `over'
	if _rc == 0 {
		capture assert `over' == floor(`over') if `touse'
		if _rc == 9 {
			di as err "`over' must a string or integer variable"
			exit 198
		}
		else if _rc != 0 {
			di as err "this error should not occur"
			exit _rc
		}
		qui clonevar `byvar' = `over' 
	}
	else if _rc == 7 {
		qui encode `over' if `touse' , gen(`byvar')
	}
	else {
		di as err "this error should not occur"
		exit _rc
	}
end

program define Est_over, rclass
	syntax varlist [if] [pweight fweight], base(real) name(string) byvar(varname) [over(varname)]
	marksample touse
	
	if "`weight'" != "" local wgt = "[`weight' `exp']"
	
	tempname H percent maxH N
	
	qui levelsof `byvar'
	local levs = r(levels)
	local k = 0
	local i = 1
	
	foreach lev of local levs {
		qui count if `touse' & `byvar' == `lev'
		if r(N) == 0 continue
		Estimate `varlist' if `touse' & `byvar' == `lev' `wgt' , base(`base')
		matrix `H'       = nullmat(`H')\r(H)
		matrix `percent' = nullmat(`percent')\r(percent)
		matrix `N'       = nullmat(`N')\r(N)
		local k = max(`k', r(k))
		
		collect get r(H) r(percent), name(`name')
		
		local lab : label (`byvar') `lev'
		local rname : subinstr local lab " " "_", all
		local rnames = `"`rnames' `rname'"'
		collect label values cmdset `i++' `"`lab'"'
	}
	
	if `i' == 2 {
		return scalar N = el(`N',1,1)
	}
	else {
		matrix rownames `H'       = `rnames'
		matrix rownames `percent' = `rnames'
		matrix rownames `N'       = `rnames'
		return matrix N = `N'
	}
	return matrix H = `H'
	return matrix percent = `percent'
	return scalar maxH = ln(`k')/ln(`base')
	return scalar k = `k'

end

program define Estimate, rclass
	syntax varlist [if] [pweight fweight/], base(real)
	
	gettoken y x : varlist
	if "`weight'" != "" local wgt = "[`weight' = `exp']"
	
	marksample touse
	
	tempname tab htot hygx i H percent maxH freq
	tempvar htoti py px pxy hygxi Ii mark one

	quietly {
		frame put `varlist' `exp' if `touse', into(`tab')
		frame change `tab'
		gen byte `one' = 1
		
		collapse (count) `freq'=`one' `wgt', by( `varlist')
		
		levelsof `y'
		local k : word count `r(levels)'
		scalar `maxH' = ln(`k')/ln(`base')
		
		sum `freq', meanonly
		local N = r(sum)
		gen double `pxy' = `freq' / `N'


		bysort `y' (`x') : gen double `py' = sum(`freq')
		by     `y'       : replace `py' = `py'[_N]/`N'
		by     `y'       : gen byte `mark' = _n == _N
		bysort `x' (`y') : gen double `px' = sum(`freq')
		by     `x'       : replace `px' = `px'[_N]/`N'

		gen double `htoti' = -`py'*ln(`py')/ln(`base') if `mark'
		sum `htoti', meanonly
		matrix `H' = J(1,3,.)
		matrix `H'[1,1] = r(sum)

		gen double `hygxi' = -`pxy'*(ln(`pxy')-ln(`px'))/ln(`base')
		sum `hygxi' , meanonly
		matrix `H'[1,2] = r(sum)

		gen double `Ii' = `pxy'*(ln(`pxy') - ln(`px')-ln(`py'))/ln(`base')
		sum `Ii', meanonly
		matrix `H'[1,3] = r(sum)

		matrix `percent' = J(1,3,.)
		matrix `percent'[1,1] = 100
		matrix `percent'[1,2] = el(`H',1,2)/el(`H',1,1)*100
		matrix `percent'[1,3] = el(`H',1,3)/el(`H',1,1)*100

		matrix colnames `H' = total within between
		matrix colnames `percent' = total within between
		matrix rownames `H' = H
		matrix rownames `percent' = %
	}
	
	return matrix H = `H'
	return matrix percent = `percent'
	return scalar maxH = `maxH'
	return scalar k = `k'
	return scalar N = `N'
end

program define Display
	syntax, name(name) [over(varname)]
	if `"`over'"' == "" {
		qui collect layout (result) (colname), name(`name')
	}
	else {
		qui collect layout (cmdset#result) (colname), name(`name')
	}
	collect style cell result[H] , nformat(%9.3f) name(`name')
	collect style cell result[percent] , nformat(%9.1f) sformat("%s%%") name(`name')
	collect notes "Maximum H possible: `: display %-9.3f r(maxH)'" , name(`name')  
	collect preview
end

