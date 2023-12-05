{smcl}
{* *! version 0.1.0  04Dec2023}{...}
{vieweralsosee "entropyetc (if installed)" "help entropyetc"}{...}
{viewerjumpto "Syntax"      "decomph##syntax"}{...}
{viewerjumpto "Description" "decomph##description"}{...}
{viewerjumpto "Options"     "decomph##options"}{...}
{viewerjumpto "Remarks"     "decomph##remarks"}{...}
{viewerjumpto "Examples"    "decomph##examples"}{...}
{viewerjumpto "References"  "decomph##references"}{...}
{title:Title}

{phang}
{bf:decomph} {hline 2} Decompose entropy in a within and between component


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:decomph}
{help varname:depvar} {help varname:indepvar}
{ifin}
{weight}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt base(#)}}the base used for the logarithm; the default is 2{p_end}
{synopt:{opth over(varname)}}computes the decomposition for each value of {it:varname}{p_end}
{synopt:{opt name(cname)}}the name used for the {help collect:collection} used to display the results{p_end}
{synopt:{opt maxcat(#)}}{cmd:decomph} is for categorical variables, and will return
an error if either {it:depvar} or {it:indepvar} has more than {it:#} distinct values;
        default is {cmd:maxcat(50)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:fweight}s and {cmd:pweight}s are allowed; see {help weight}.


{marker description}{...}
{title:Description}

{pstd}
The entropy can be thought of as a measure of dispersion for categorical
variables, just like the variance is a measure of dispersion for continuous 
variables. Like the variance, the entropy can also be decomposed as a sum of a 
within and a between component, typically called the conditional entropy and 
mutual information, respectively. {cmd:decomph} computes these elements and the
percentage each element contributes to the total (marginal) entropy.

{pstd}
{cmd:decomph} is intended for categorical variables, so both {it:depvar} and
{it:indepvar} must be categorical. This means that they can be either a string 
or a numeric variable, but if they are numeric the can only contain integers. 
The number of distinct values is limited to a maximum specified in {opt maxcat()}.

{pstd}
Since {cmd:decomph} uses {help collect} to display the results, the user can use
all the tools present in {cmd:collect} to change the display and use 
{help collect export} to export the table directly to Word or LaTeX. 


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt base(#)} The entropy uses a logarithm, and different bases have been used.
Common bases are 2, e, and 10. The base influences the units (shannons for base 
2, nats for base e, and hartleys for base 10), but does not influence the 
decomposition. The default is {opt base(2)}.

{phang}
{opt over(varname)} computes the decomposition for different different groups. 
For example, {it:varname} could be country in a dataset with multiple countries, 
and {cmd:decomph y x, over(country)} will show how much {it:x} contributes to 
the dispersion of {it:y} in each country. 

{pmore}
The variable {it:varname} can be a string or a numeric variable, but if it is 
numeric it can only contain integers.

{phang}
{opt name(cname)} specifies which name the collection. {cmd:decomph} uses 
{help collect} to display the results, so it needs to store the results in a 
collection with a name. The default name is decomph.

{phang}
{opt maxcat(#)} specifies the maximum number of distinct values allowed for 
{it:depvar} and {it:indepvar}. The default is {opt maxcat(50)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
The entropy is often thought of as "the expected surprise" when drawing from a 
distribution. Say we have a categorical variable with three categories, 
imaginatively called {it:A}, {it:B}, and {it:C}. 50% of the observations fall in
category {it:A}, 40% in category {it:B}, and the remaining 10% in category {it:C}.
If we randomly drew an observation from this we would be surprised to see a 
{it:C}, but not so surprised to see an {it:A}, so surprise seems to be inversely
related to the probability. So we could think of surprise as 1/p(y). We can say 
a bit more: if everybody belongs to category {it:A}, then there would be no 
surprise whatsoever when drawing from that distribution. In that case, p(y=A)=1,
and the resulting measure of surprise should be 0. Just taking the inverse of 
p(y) does not do that (1/1=1 not 0), but taking the logarithm does (regardless 
of the chosen base for that logarithm). So surprise can be measured as 
log(1/p(y)). We can than compute the average surprise (H(y)) as:

       H(y) = p(y=A)log(1/p(y=A)) + p(y=B)log(1/p(y=B)) + p(y=C)log(1/p(y=C))
            = sum p(y)log(p(y)^-1)
            = sum - p(y)log(p(y))

{pstd}
The entropy can be used as a measure of dispersion because the expected surprise 
is low when the dispersion is low, and the expected surprise is high when the 
dispersion is high. In general the entropy has the following properties: it is 
largest if all categories of the outcome variable are equally likely, and 
becomes smaller as the observations become more concentrated in a limited number 
of categories. The entropy will take its minimum value of 0 when all 
observations are concentrated in one category. The maximum value is dependent
on the number of categories. If {it:k} is the number of categories, then the 
maximum entropy is log({it:k}), where the base of the logarithm is determined by 
the {opt base()} option. This is included in the output to help interpretation.

{pstd}
The base of the logarithm determines the scale of our measure of surprise. If we 
set the base to 2, then we compare all surprises to the flip of a fair coin. With
a fair coin there are two possible outcomes (heads or tails) and each has a 
probability of 1/2. So the H = 1/2log_2(1/(1/2)) + 1/2log_2(1/(1/2)) = 1/2log_2(2) + 1/2log_2(2) = 1.
Similarly, if we choose base 10, then our reference for a our surprise is a role
of a fair 10-sided die. If we use e as our base, there is no such nice phyical
analogue, but some computations can be easier. If you were an avid DnD player, 
and your frame of reference for a random event would be a throw of a D20 (20 
sided die), then you could (but probably shouldn't) choose 20 as a base. 
Regardless, this choice only changes the unit of the entropy, it does not change 
the decomposition.  

{pstd}
The conditional entropy is the avarage entropy of the dependent variable ({it:y})
within each category of the independent variable ({it:x}). It is the dispersion 
in {it:y} than cannot be explained by {it:x}. In the terminology of variance
decomposition, it is the "within entropy".

{pstd}
The mutual information is the entropy that {it:y} and {it:x} have in common; it
is the dispersion in {it:y} that can be attributed to the dispersion in {it:x}.
In the terminology of variance decomposition, it is the "between entropy".

{pstd}
Lets look at two extreme examples. First, consider the example frequency 
distribution below:

             y
         | 1   2  total
      ---+-------------
    x  1 |10   0   10
       2 | 0  10   10
    total|10  10

{pstd}
The marginal distribution of {it:y} (the bottom row) has high dispersion. However,
within each category of {it:x} the dispersion is low, in fact in both cases the 
entropy conditional of x is 0, so the average conditional entropy is also 0. The
dispersion in the marginal distribution of {it:y} is completely due to {it:x}, 
i.e. the between component explains 100% of the total (marginal) entropy and the
within component 0%. 

{pstd}
Conversely, in the frequency table below, knowing {it:x} gives us no information
on {it:y}, so the mutual information is 0 and the marginal entropy in {it:y} is
compeletely determined by the within entropy (conditional entropy) and the between
component (mutual information) adds nothing.

             y
         | 1   2  total
      ---+-------------
    x  1 | 5   5   10
       2 | 5   5   10
    total|10  10

{pstd}
The formulas for the total/marginal entropy (H(y)), conditional entropy (H(y|x)),
and the mutual information (I(y,x)) are:

        H(y)   = sum p(y) log(1/p(y)) 
               = sum -p(y) log(p(y))
               
        H(y|x) = sum p(y,x) log(1/p(y|x)) 
               = sum p(y,x) log(1/[p(y,x)/p(x)])
               = sum - p(y,x) [log(p(y,x)) - log(p(x))] 
               
        I(y,x) = sum p(y,x) log(p(y,x)/(p(x)*p(y)))
               = sum p(y,x) [log(p(y,x)) - log(p(x)) - log(p(y))]

{pstd}
The decomposition of entropy in conditional entropy and mutual information is 
already part of the original article by Claude Shannon (1948). Its use in 
Sociology to describe variation in a categorical variable and decompose that in 
a within an between component was proposed by McFarland (1969) and expanded upon
by Horan (1975) and Teachman (1980). Recently the use of entropy as a measure of
dispersion has been picked up again, e.g. by Budescu and Budescu (2012).


{marker examples}{...}
{title:Examples}

{cmd}{...}
        sysuse nlsw88, clear
        
        gen byte urban:urban = c_city + smsa
        label define urban 2 "central city" ///
                           1 "suburban"     ///
                           0 "rural"
        label variable urban "urbanicity"
        
        decomph race urban
        
        decomph race urban, over(south)
{txt}{...}


{marker references}{...}
{title:References}

{phang}
D.V. Budescu and M. Budescu (2012) How to measure diversity when you must. 
{it:Psychological Methods}, 17(2):215-227. 

{phang}
P.M. Horan (1975). Information-Theoretic Measures and the Analysis of Social 
Structures. {it:Sociological Methods & Research}, 3(3), 321-340. 

{phang}
D.D. McFarland (1969). Measuring the Permeability of Occupational Structures: 
An Information-Theoretic Approach. {it:American Journal of Sociology}, 75(1), 41–61.

{phang}
C.E. Shannon (1948). A Mathematical Theory of Communication. 
{it:Bell Systems Technical Journal} 27: 379-423, 623-656.

{phang}
J.D. Teachman (1980). Analysis of Population Diversity: Measures of Qualitative 
Variation. {it:Sociological Methods & Research}, 8(3), 341-362.


{title:Author}

{pstd}
Maarten L. Buis,{break}University of Konstanz,{break}maarten.buis@uni.kn
