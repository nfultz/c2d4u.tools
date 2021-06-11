
# c2d4u.tools

<!-- badges: start -->
<!-- badges: end -->

The goal of `c2d4u.tools` is to install Ubuntu packages into a user's library w/o
requiring system permissions. You might need to do that if your sysadmin is a 
meanie or bofh :).

## Installation

You can install the development version of c2d4u.tools with:

``` r
remotes::install_github("nfultz/c2d4u.tools")
```

## Example

This is a basic example of installing `randomizr` - no compiler is required.

``` r
  c2d4u.tools::update()
  c2d4u.tools::find("randomizr")
  c2d4u.tools::show("r-cran-randomizr")
  c2d4u.tools::install("r-cran-randomizr")
```

## Troubleshooting

If you find a package that does not install correctly, please let me know via email.

## See also

* [An introduction to c2d4u](https://sites.psu.edu/theubunturblog/cran2deb4ubuntu/)
