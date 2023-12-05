_v. 0.1.0_  

`decomph` : Decompose entropy in a within and between component
===============================================================

### License
Creative Commons Attribution 4.0

## Description

The entropy can be thought of as a measure of dispersion for categorical
variables, just like the variance is a measure of dispersion for continuous 
variables. Like the variance, the entropy can also be decomposed as a sum of a 
within and a between component, typically called the conditional entropy and 
mutual information, respectively. `decomph` computes these elements and the
percentage each element contributes to the total (marginal) entropy.

## Requirements and use

This package requires [Stata](https://www.stata.com) version 18 or higher. The easiest way to install this is using E. F. Haghish's [github](https://haghish.github.io/github/) command. After you have installed that, you can install `mkproject` by typing in Stata: `github install maartenteaches/decomph`. Alternatively, `decomph` can be installed without the `github` command by typing in Stata `net install decomph, from("https://raw.githubusercontent.com/maartenteaches/decomph/main")`.


Author
------

**Maarten L. Buis**  
University of Konstanz  
maarten.buis@uni.kn  
