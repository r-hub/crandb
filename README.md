
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The CRAN database

[![Linux Build
Status](https://travis-ci.org/metacran/crandb.svg?branch=master)](https://travis-ci.org/metacran/crandb)
[![Windows Build
status](https://ci.appveyor.com/api/projects/status/github/metacran/crandb?svg=true)](https://ci.appveyor.com/project/gaborcsardi/crandb)

The CRAN database provides an API for programatically accessing all
meta-data of CRAN R packages. This API can be used for various purposes,
here are three examples I am woking on right now: \* Writing a package
manager for R. The package manager can use the CRAN DB API to query
dependencies, or other meta data. \* Building a search engine for CRAN
packages. The DB itself does not provide a search API, but it can be
(easily) mirrored in a search engine. \* Creating an RSS feed for the
new, updated or archived packages on CRAN.

**Note that `crandb` is *NOT* an official CRAN project, and is not
supported by CRAN.**

## The `crandb` API

### Packages

`package()` returns the latest version of a package:

``` r
library(crandb)
package("dotenv")
```

    ## CRAN package dotenv 1.0.2, 2 years ago
    ## Title: Load Environment Variables from '.env'
    ## Maintainer: Gábor Csárdi <csardi.gabor@gmail.com>
    ## Author: Gábor Csárdi [aut, cre, cph]
    ## BugReports: https://github.com/gaborcsardi/dotenv/issues
    ## Date/Publication: 2017-03-01 19:05:47
    ## Description: Load configuration from a '.env' file, that is in the current
    ##     working directory, into environment variables.
    ## Encoding: UTF-8
    ## LazyData: true
    ## License: MIT + file LICENSE
    ## NeedsCompilation: no
    ## Packaged: 2017-03-01 13:08:36 UTC; gaborcsardi
    ## releases:
    ## Repository: CRAN
    ## RoxygenNote: 5.0.1.9000
    ## URL: https://github.com/gaborcsardi/dotenv

A given version can be queried as well:

``` r
package("httr", version = "0.3")
```

    ## CRAN package httr 0.3, 5 years ago
    ## Title: Tools for working with URLs and HTTP
    ## Maintainer: Hadley Wickham <h.wickham@gmail.com>
    ## Author: Hadley Wickham <h.wickham@gmail.com>
    ## Date/Publication: 2014-03-20 03:03:51
    ## Depends: R (>= 3.0.0)
    ## Description: Provides useful tools for working with HTTP connections.  Is
    ##     a<U+000a>simplified wrapper built on top of RCurl.  It is much much less
    ##     configurable<U+000a>but because it only attempts to encompass the most
    ##     common operations it is<U+000a>also much much simpler.
    ## Imports: RCurl (>= 1.95-0), stringr (>= 0.6.1), digest (*), tools (*), methods
    ##     (*)
    ## License: MIT + file LICENSE
    ## NeedsCompilation: no
    ## Packaged: 2014-03-19 02:04:19 UTC; hadley
    ## releases: 3.1.0, 3.1.1
    ## Repository: CRAN
    ## Roxygen: list(wrap = FALSE)
    ## Suggests: jsonlite (*), XML (*), testthat (>= 0.8.0), png (*), jpeg (*), httpuv
    ##     (*)
    ## Type: Package

Or all versions:

``` r
package("httr", version = "all")
```

    ## CRAN package httr, latest: 1.4.0, 4 months ago
    ## ['1.4.0']:
    ##   Title: Tools for Working with URLs and HTTP
    ##   Maintainer: Hadley Wickham <hadley@rstudio.com>
    ##   Author: Hadley Wickham [aut, cre], RStudio [cph]
    ##   BugReports: https://github.com/r-lib/httr/issues
    ##   Date/Publication: 2018-12-11 08:40:06 UTC
    ##   Depends: R (>= 3.1)
    ##   Description: Useful tools for working with HTTP organised by HTTP verbs
    ##       (GET(), POST(), etc). Configuration functions make it easy to control
    ##       additional request components (authenticate(), add_headers() and so on).
    ##   Encoding: UTF-8
    ##   Imports: curl (>= 0.9.1), jsonlite (*), mime (*), openssl (>= 0.8), R6 (*)
    ##   License: MIT + file LICENSE
    ##   MD5sum: afa863a39dfc61ac6197a73d8274288b
    ##   NeedsCompilation: no
    ##   Packaged: 2018-12-06 20:11:59 UTC; hadley
    ##   releases:
    ##   Repository: CRAN
    ##   RoxygenNote: 6.1.1
    ##   Suggests: covr (*), httpuv (*), jpeg (*), knitr (*), png (*), readr (*),
    ##       rmarkdown (*), testthat (>= 0.8.0), xml2 (*)
    ##   URL: https://github.com/r-lib/httr
    ##   VignetteBuilder: knitr
    ## Other versions: 1.3.1, 1.3.0, 1.2.1, 1.2.0, 1.1.0, 1.0.0, 0.6.1, 0.6.0, 0.5,
    ##   0.4, 0.3, 0.2, 0.1.1, 0.1

### List of all packages

`list_packages()` lists all packages, in various formats, potentially
including archived packages as
    well:

``` r
list_packages(from = "cranlogs", limit = 10, archived = FALSE)
```

    ## CRAN packages (short)--------------------------------------------------------------------
    ##  Package      Version Title                                                              
    ##  cranlogs     2.1.0   Download Logs from the 'RStudio' 'CRAN' Mirror                     
    ##  cranly       0.3     Package Directives and Collaboration Networks in CRAN              
    ##  CRANsearcher 1.0.0   RStudio Addin for Searching Packages in CRAN Database Based on K...
    ##  crantastic   0.1     Various R tools for http://crantastic.org/                         
    ##  crawl        2.2.1   Fit Continuous-Time Correlated Random Walk Models to Animal Move...
    ##  crayon       1.3.4   Colored Terminal Output                                            
    ##  crblocks     1.0-0   Categorical Randomized Block Data Analysis                         
    ##  crch         1.0-1   Censored Regression with Conditional Heteroscedasticity            
    ##  CREAM        1.1.1   Clustering of Genomic Regions Analysis Method                      
    ##  credentials  1.1     Tools for Managing SSH and Git Credentials

### CRAN events

`events()` lists CRAN events, starting from the latest ones. New package
releases and archival can both be included in the list. By default the
last 10 events are
    included:

``` r
events()
```

    ## CRAN events (events)---------------------------------------------------------------------
    ##  . When     Package       Version Title                                                  
    ##  + 12 hours filehash      2.4-2   Simple Key-Value Database                              
    ##  + 12 hours EpiILMCT      1.1.3   Continuous Time Distance-Based and Network-Based Ind...
    ##  + 12 hours eNetXplorer   1.0.2   Quantitative Exploration of Elastic Net Families for...
    ##  + 12 hours gRc           0.4-3.2 Inference in Graphical Gaussian Models with Edge and...
    ##  - 12 hours packagefinder 0.1.1   Comfortable Search for R Packages on CRAN Directly f...
    ##  + 12 hours worldmet      0.8.7   Import Surface Meteorological Data from NOAA Integra...
    ##  + 12 hours swdft         1.0.0   Sliding Window Discrete Fourier Transform (SWDFT)      
    ##  + 1 day    SPUTNIK       1.1.2   SPatially aUTomatic deNoising for Ims toolKit          
    ##  + 1 day    discSurv      1.4.0   Discrete Time Survival Analysis                        
    ##  + 1 day    statVisual    1.0.9   Statistical Visualization Tools

### R and CRAN releases

The `releases()` function lists recent R versions, with their release
dates.

``` r
releases()
```

    ## R releases-------------------------------------------------------------------------------
    ##  Version Date               
    ##  2.0.0   2004-10-04 02:00:00
    ##  2.0.1   2004-11-15 01:00:00
    ##  2.1.0   2005-04-18 02:00:00
    ##  2.1.1   2005-06-20 02:00:00
    ##  2.2.0   2005-10-06 02:00:00
    ##  2.2.1   2005-12-20 01:00:00
    ##  2.3.0   2006-04-24 02:00:00
    ##  2.3.1   2006-06-01 02:00:00
    ##  2.4.0   2006-10-03 02:00:00
    ##  2.4.1   2006-12-18 01:00:00
    ##  2.5.0   2007-04-24 02:00:00
    ##  2.5.1   2007-06-28 02:00:00
    ##  2.6.0   2007-10-03 02:00:00
    ##  2.6.1   2007-11-26 01:00:00
    ##  2.6.2   2008-02-08 01:00:00
    ##  2.7.0   2008-04-22 02:00:00
    ##  2.7.1   2008-06-23 02:00:00
    ##  2.7.2   2008-08-25 02:00:00
    ##  2.8.0   2008-10-20 02:00:00
    ##  2.8.1   2008-12-22 01:00:00
    ##  2.9.0   2009-04-17 02:00:00
    ##  2.9.1   2009-06-26 02:00:00
    ##  2.9.2   2009-08-24 02:00:00
    ##  2.10.0  2009-10-26 01:00:00
    ##  2.10.1  2009-12-14 01:00:00
    ##  2.11.0  2010-04-22 02:00:00
    ##  2.11.1  2010-05-31 02:00:00
    ##  2.12.0  2010-10-15 02:00:00
    ##  2.12.1  2010-12-16 01:00:00
    ##  2.12.2  2011-02-25 01:00:00
    ##  2.13.0  2011-04-13 02:00:00
    ##  2.13.1  2011-07-08 02:00:00
    ##  2.13.2  2011-09-30 02:00:00
    ##  2.14.0  2011-10-31 01:00:00
    ##  2.14.1  2011-12-22 01:00:00
    ##  2.14.2  2012-02-29 01:00:00
    ##  2.15.0  2012-03-30 02:00:00
    ##  2.15.1  2012-06-22 02:00:00
    ##  2.15.2  2012-10-26 02:00:00
    ##  2.15.3  2013-03-01 01:00:00
    ##  3.0.0   2013-04-03 02:00:00
    ##  3.0.1   2013-05-16 02:00:00
    ##  3.0.2   2013-09-25 02:00:00
    ##  3.0.3   2014-03-06 01:00:00
    ##  3.1.0   2014-04-10 02:00:00
    ##  3.1.1   2014-07-10 02:00:00

The CRAN packages that were current at the time of an R releases can be
listed with the `cran_releases()`
    function:

``` r
cran_releases(version = "2.13.1")
```

    ## CRAN release 2.13.1----------------------------------------------------------------------
    ##   [1] "aaMI@1.0-1"               "abd@0.1-18"               "abind@1.3-0"             
    ##   [4] "AcceptanceSampling@1.0-1" "accuracy@1.35"            "acepack@1.3-3.0"         
    ##   [7] "aCGH.Spline@2.1"          "actuar@1.1-2"             "ada@2.0-2"               
    ##  [10] "adabag@1.1"               "ADaCGH@1.5-3"             "adapt@1.0-4"             
    ##  [13] "AdaptFit@0.2-1"           "adaptivetau@0.902"        "adaptTest@1.0"           
    ##  [16] "ade4@1.4-17"              "ade4TkGUI@0.2-4"          "adephylo@1.1-1"          
    ##  [19] "ADGofTest@0.1"            "adimpro@0.7.5"            "adk@1.0-1"               
    ##  [22] "adlift@0.9-6"             "ADM3@1.1"                 "AdMit@1-01.03.1"         
    ##  [25] "ads@1.2-10"               "AER@1.1-8"                "afc@1.0"                 
    ##  [28] "afmtools@0.1.2"           "agce@1.2"                 "agilp@1.0"               
    ##  [31] "agreement@1.0-1"          "agricolae@1.0-9"          "agridat@1.2"             
    ##  [34] "AGSDest@2.0"              "agsemisc@1.2-1"           "ahaz@1.1"                
    ##  [37] "AIGIS@1.0"                "AIM@1.01"                 "AIS@1.0"                 
    ##  [40] "akima@0.5-4"              "alabama@2011.3-1"         "AlgDesign@1.1-2"         
    ##  [43] "allan@1.0"                "allelic@0.1"              "AllPossibleSpellings@1.0"
    ##  [46] "alphahull@0.2-0"          "alr3@2.0.3"               "ALS@0.0.4"               
    ##  [49] "AMA@1.0.8"                "amap@0.8-5"               "amba@0.3.0"              
    ##  [52] "amei@1.0-3"               "Amelia@1.2-18"            "amer@0.6.10"             
    ##  [55] "AMORE@0.2-12"             "anacor@1.0-1"             "analogue@0.7-0"          
    ##  [58] "AnalyzeFMRI@1.1-13"       "AnalyzeIO@0.1.1"          "anapuce@2.1"             
    ##  [61] "anchors@3.0-7"            "anesrake@0.65"            "Animal@1.02"             
    ##  [64] "anm@1.0-9"                "AnnotLists@1.0"           "ant@0.0-10"              
    ##  [67] "aod@1.2"                  "aplpack@1.2.3"            "approximator@1.2-2"      
    ##  [70] "apsrtable@0.8-6"          "apt@1.0"                  "apTreeshape@1.4-3"       
    ##  [73] "aqfig@0.1"                "aqp@0.99-1"               "AquaEnv@1.0-2"           
    ##  [76] "aratio@1.0"               "archetypes@2.0-2"         "ArDec@1.2-3"             
    ##  [79] "ares@0.7.2"               "ARES@1.2-3"               "arf3DS4@2.5-2"           
    ##  [82] "argosfilter@0.6"          "arm@1.4-13"               "aroma.affymetrix@2.1.0"  
    ##  [85] "aroma.apd@0.1.8"          "aroma.core@2.1.0"         "arrayImpute@1.3"         
    ##  [88] "arrayMissPattern@1.3"     "ars@0.4"                  "arules@1.0-6"            
    ##  [91] "arulesNBMiner@0.1-1"      "arulesSequences@0.1-11"   "arulesViz@0.1-3"         
    ##  [94] "ash@1.0-12"               "aspace@3.0"               "aspect@1.0-0"            
    ##  [97] "assist@3.1.1"             "aster@0.7-7"              "aster2@0.1"              
    ## [100] "asuR@0.08-24"             "asympTest@0.1.2"          "asypow@1.2.2"            
    ## [103] "atm@0.1.0"                "atmi@1.0"                 "audio@0.1-4"             
    ## [106] "aws@1.6-2"                "aylmer@1.0-7"             "BaBooN@0.1-6"            
    ## [109] "BACCO@1.1-4"              "backfitRichards@0.5.0"    "backtest@0.3-0"          
    ## [112] "BaM@0.98.1"               "BAMD@3.4"                 "barcode@1.0"             
    ## [115] "BARD@1.24"                "bark@0.1-0"               "Barnard@1.0"             
    ## [118] "BAS@0.92"                 "baseline@1.0-0"           "basicspace@0.02"         
    ## [121] "batch@1.1-3"              "bats@0.1-2"               "bayesCGH@0.6"            
    ## [124] "bayesclust@3.0"           "bayescount@0.9.9-1"       "BayesDA@1.0-1"           
    ## [127] "bayesGARCH@1-00.10"       "bayesLife@0.2-0"          "bayesm@2.2-4"            
    ## [130] "bayesmix@0.7-1"           "bayespack@1.0-2"          "BayesPanel@0.1-2"        
    ## [133] "bayesQR@1.3"              "BayesQTLBIC@1.0-1"        "bayesSurv@0.6-2"         
    ## [136] "BayesTree@0.3-1.1"        "BayesValidate@0.0"        "BayesX@0.2-5"            
    ## [139] "BayHap@1.0"               "BayHaz@0.0-6"             "baymvb@1.0.4"            
    ## [142] "BAYSTAR@0.2-3"            "BBMM@2.2"                 "BCA@0.1-1"               
    ## [145] "BCE@1.3"                  "Bchron@3.1.4"             "bclust@1.2"              
    ## [148] "bcp@2.2.0"                "bcv@1.0"                  "bdoc@1.1"                
    ## [151] "bdsmatrix@1.0"            "beadarrayMSV@1.1.0"       "beanplot@1.1"            
    ## [154] "bear@2.5.2"               "beeswarm@0.0.7"           "belief@1.0.1"            
    ## [157] "benchden@1.0.4"           "benchmark@0.3-2"          "bentcableAR@0.2.2"       
    ## [160] "ber@2.0"                  "Bergm@1.4"                "Bessel@0.5-3"            
    ## [163] "bestglm@0.31"             "betaper@1.0-0"            "betareg@2.3-0"           
    ## [166] "bethel@0.1"               "bfast@1.2-1"              "bfp@0.0-19"              
    ## [169] "bgmm@1.2"                 "Bhat@0.9-09"              "BHH2@1.0.3"              
    ## [172] "BiasedUrn@1.03"           "bibtex@0.2-1"             "biclust@1.0.1"           
    ## [175] "bicreduc@0.4-7"           "bifactorial@1.4.6"        "biganalytics@1.0.14"     
    ## [178] "biglars@1.0.1"            "biglm@0.7"                "bigmemory@4.2.3"         
    ## [181] "biGraph@0.9-3"            "bigtabulate@1.0.13"       "bild@1.0"                
    ## [184] "bim@1.01-5"               "binarySimCLF@1.0"         "bindata@0.9-17"          
    ## [187] "binGroup@1.0-8"           "binMto@0.0-3"             "binom@1.0-5"             
    ## [190] "binomSamSize@0.1-2"       "bio.infer@1.2-9"          "Biodem@0.1"              
    ## [193] "BiodiversityR@1.5"        "Biograph@1.0"             "BioIDMapper@3.0"         
    ## [196] "BiomarkeR@1.2"            "biopara@1.4"              "BioPhysConnectoR@1.6-7"  
    ## [199] "biOps@0.2.1"              "biOpsGUI@0.1.1"          
    ##  [ reached getOption("max.print") -- omitted 2755 entries ]

## The raw API

This is the raw JSON API.

We will use the [`httr`](https://github.com/hadley/httr) package to
query it, and the [`jsonlite`](https://github.com/jeroenooms/jsonlite)
package to nicely format it.
[`magrittr`](https://github.com/smbache/magrittr) is loaded for the
pipes. We use `DB` to query the API and format the result.

``` r
library(magrittr)
skip_lines <- function(text, head = 1e6, tail = 1e6) {
    text <- strsplit(text, "\n")[[1]]
    tail <- min(tail, max(0, length(text) - head))
    skip_text <- if (length(text) > head + tail) {
        paste("\n... not showing", length(text) - head - tail, "lines ...\n")
    } else {
        character()
    }
    c(head(text, head), skip_text, tail(text, tail)) %>%
        paste(collapse = "\n")
}
DB <- function(api, head = 1e6, tail = head) {
  paste0("http://crandb.r-pkg.org", "/", api) %>%
    httr::GET() %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::prettify() %>%
    skip_lines(head = head, tail = tail) %>%
    cat()
}
```

### `/:pkg` Latest version of a package

The result includes all fields verbatim from the DESCRIPTION file, plus
some extra: \* `date`: The date and time when the package was published
on CRAN. This is needed, because especially old packages might not have
some (or any) of the `Date`, `Date/Publication` or `Packaged` fields. \*
`releases`: The R version(s) that were released when this version of the
package was the latest on CRAN. \* The `Suggests`, `Depends`, etc.
fields are formatted as named lists.

``` r
DB("/magrittr")
```

    ## {
    ##     "Package": "magrittr",
    ##     "Type": "Package",
    ##     "Title": "A Forward-Pipe Operator for R",
    ##     "Version": "1.5",
    ##     "Author": "Stefan Milton Bache <stefan@stefanbache.dk> and<U+000a>Hadley Wickham <h.wickham@gmail.com>",
    ##     "Maintainer": "Stefan Milton Bache <stefan@stefanbache.dk>",
    ##     "Description": "Provides a mechanism for chaining commands with a<U+000a>new forward-pipe operator, %>%. This operator will forward a<U+000a>value, or the result of an expression, into the next function<U+000a>call/expression. There is flexible support for the type<U+000a>of right-hand side expressions. For more information, see<U+000a>package vignette.<U+000a>To quote Rene Magritte, \"Ceci n'est pas un pipe.\"",
    ##     "Suggests": {
    ##         "testthat": "*",
    ##         "knitr": "*"
    ##     },
    ##     "VignetteBuilder": "knitr",
    ##     "License": "MIT + file LICENSE",
    ##     "ByteCompile": "Yes",
    ##     "Packaged": "2014-11-22 08:50:53 UTC; shb",
    ##     "NeedsCompilation": "no",
    ##     "Repository": "CRAN",
    ##     "Date/Publication": "2014-11-22 19:15:57",
    ##     "crandb_file_date": "2014-11-22 13:18:28",
    ##     "date": "2014-11-22T19:15:57+00:00",
    ##     "releases": [
    ## 
    ##     ]
    ## }

### `/:pkg/:version` A specific version of a package

The format is the same as for the latest version.

``` r
DB("/magrittr/1.0.0")
```

    ## {
    ##     "Package": "magrittr",
    ##     "Type": "Package",
    ##     "Title": "magrittr - a forward-pipe operator for R",
    ##     "Version": "1.0.0",
    ##     "Date": "2014-01-19",
    ##     "Author": "Stefan Milton Bache <stefan@stefanbache.dk> and<U+000a>Hadley Wickham <h.wickham@gmail.com>",
    ##     "Maintainer": "Stefan <stefan@stefanbache.dk>",
    ##     "Description": "Provides a mechanism for chaining commands with a<U+000a>new forward-pipe operator. Ceci n'est pas un pipe.",
    ##     "Suggests": {
    ##         "testthat": "*",
    ##         "knitr": "*"
    ##     },
    ##     "VignetteBuilder": "knitr",
    ##     "License": "MIT + file LICENSE",
    ##     "Packaged": "2014-02-25 16:05:59 UTC; shb",
    ##     "NeedsCompilation": "no",
    ##     "Repository": "CRAN",
    ##     "Date/Publication": "2014-02-25 18:01:09",
    ##     "crandb_file_date": "2014-02-25 12:01:11",
    ##     "date": "2014-02-25T18:01:09+00:00",
    ##     "releases": [
    ##         "3.0.3",
    ##         "3.1.0"
    ##     ]
    ## }

### `/:pkg/all` All versions of a package

The result is a list of package versions in the `versions` field, in the
format above, plus some extra: \* `name`: The name of the package. \*
`title`: The title field of the package. \* `latest`: The latest version
of the package. \* `archived`: Whether the package was archived. \*
`timeline`: All versions and their release dates of the package.

``` r
DB("/magrittr/all")
```

    ## {
    ##     "_id": "magrittr",
    ##     "_rev": "4-9763cb3f8f280bb5c09724d4d5bc59b8",
    ##     "name": "magrittr",
    ##     "versions": {
    ##         "1.0.0": {
    ##             "Package": "magrittr",
    ##             "Type": "Package",
    ##             "Title": "magrittr - a forward-pipe operator for R",
    ##             "Version": "1.0.0",
    ##             "Date": "2014-01-19",
    ##             "Author": "Stefan Milton Bache <stefan@stefanbache.dk> and<U+000a>Hadley Wickham <h.wickham@gmail.com>",
    ##             "Maintainer": "Stefan <stefan@stefanbache.dk>",
    ##             "Description": "Provides a mechanism for chaining commands with a<U+000a>new forward-pipe operator. Ceci n'est pas un pipe.",
    ##             "Suggests": {
    ##                 "testthat": "*",
    ##                 "knitr": "*"
    ##             },
    ##             "VignetteBuilder": "knitr",
    ##             "License": "MIT + file LICENSE",
    ##             "Packaged": "2014-02-25 16:05:59 UTC; shb",
    ##             "NeedsCompilation": "no",
    ##             "Repository": "CRAN",
    ##             "Date/Publication": "2014-02-25 18:01:09",
    ##             "crandb_file_date": "2014-02-25 12:01:11",
    ##             "date": "2014-02-25T18:01:09+00:00",
    ##             "releases": [
    ##                 "3.0.3",
    ##                 "3.1.0"
    ##             ]
    ##         },
    ##         "1.0.1": {
    ##             "Package": "magrittr",
    ##             "Type": "Package",
    ##             "Title": "magrittr - a forward-pipe operator for R",
    ##             "Version": "1.0.1",
    ##             "Date": "2014-05-14",
    ##             "Author": "Stefan Milton Bache <stefan@stefanbache.dk> and<U+000a>Hadley Wickham <h.wickham@gmail.com>",
    ##             "Maintainer": "Stefan Milton Bache <stefan@stefanbache.dk>",
    ##             "Description": "Provides a mechanism for chaining commands with a<U+000a>new forward-pipe operator. Ceci n'est pas un pipe.",
    ##             "Suggests": {
    ##                 "testthat": "*",
    ##                 "knitr": "*"
    ##             },
    ##             "VignetteBuilder": "knitr",
    ##             "License": "MIT + file LICENSE",
    ##             "Packaged": "2014-05-15 18:49:49 UTC; shb",
    ##             "NeedsCompilation": "no",
    ##             "Repository": "CRAN",
    ##             "Date/Publication": "2014-05-15 21:12:27",
    ##             "crandb_file_date": "2014-05-15 15:12:29",
    ##             "date": "2014-05-15T21:12:27+00:00",
    ##             "releases": "3.1.1"
    ##         },
    ##         "1.5": {
    ##             "Package": "magrittr",
    ##             "Type": "Package",
    ##             "Title": "A Forward-Pipe Operator for R",
    ##             "Version": "1.5",
    ##             "Author": "Stefan Milton Bache <stefan@stefanbache.dk> and<U+000a>Hadley Wickham <h.wickham@gmail.com>",
    ##             "Maintainer": "Stefan Milton Bache <stefan@stefanbache.dk>",
    ##             "Description": "Provides a mechanism for chaining commands with a<U+000a>new forward-pipe operator, %>%. This operator will forward a<U+000a>value, or the result of an expression, into the next function<U+000a>call/expression. There is flexible support for the type<U+000a>of right-hand side expressions. For more information, see<U+000a>package vignette.<U+000a>To quote Rene Magritte, \"Ceci n'est pas un pipe.\"",
    ##             "Suggests": {
    ##                 "testthat": "*",
    ##                 "knitr": "*"
    ##             },
    ##             "VignetteBuilder": "knitr",
    ##             "License": "MIT + file LICENSE",
    ##             "ByteCompile": "Yes",
    ##             "Packaged": "2014-11-22 08:50:53 UTC; shb",
    ##             "NeedsCompilation": "no",
    ##             "Repository": "CRAN",
    ##             "Date/Publication": "2014-11-22 19:15:57",
    ##             "crandb_file_date": "2014-11-22 13:18:28",
    ##             "date": "2014-11-22T19:15:57+00:00",
    ##             "releases": [
    ## 
    ##             ]
    ##         }
    ##     },
    ##     "timeline": {
    ##         "1.0.0": "2014-02-25T18:01:09+00:00",
    ##         "1.0.1": "2014-05-15T21:12:27+00:00",
    ##         "1.5": "2014-11-22T19:15:57+00:00"
    ##     },
    ##     "latest": "1.5",
    ##     "title": "A Forward-Pipe Operator for R",
    ##     "archived": false,
    ##     "revdeps": 25
    ## }

### `/-/all` All packages, in alphabetical order

Note that this API point *really* returns a list of all active CRAN
packages (currently about 6,000), so it is a good idea to query the date
in chunks. `limit` specifies the number of records to return, and
`startkey` can be used to specify the first key to list. Note that the
result will include the full records of the package, all package
versions.

``` r
DB("/-/all?limit=3", head = 20)
```

    ## {
    ##     "A3": {
    ##         "_id": "A3",
    ##         "_rev": "5-b7e2fc1ff5bb5e68d8eafa1d948d9e34",
    ##         "name": "A3",
    ##         "versions": {
    ##             "0.9.1": {
    ##                 "Package": "A3",
    ##                 "Type": "Package",
    ##                 "Title": "A3: Accurate, Adaptable, and Accessible Error Metrics for<U+000a>Predictive Models",
    ##                 "Version": "0.9.1",
    ##                 "Date": "2013-02-06",
    ##                 "Author": "Scott Fortmann-Roe",
    ##                 "Maintainer": "Scott Fortmann-Roe <scottfr@berkeley.edu>",
    ##                 "Description": "This package supplies tools for tabulating and analyzing<U+000a>the results of predictive models. The methods employed are<U+000a>applicable to virtually any predictive model and make<U+000a>comparisons between different methodologies straightforward.",
    ##                 "License": "GPL (>= 2)",
    ##                 "Depends": {
    ##                     "xtable": "*",
    ##                     "pbapply": "*"
    ##                 },
    ## 
    ## ... not showing 814 lines ...
    ## 
    ##         },
    ##         "timeline": {
    ##             "1.0": "2010-10-05T08:45:21+00:00",
    ##             "1.1": "2010-10-11T07:24:31+00:00",
    ##             "1.2": "2011-01-15T16:23:31+00:00",
    ##             "1.3": "2011-05-10T09:42:38+00:00",
    ##             "1.4": "2011-09-04T05:18:45+00:00",
    ##             "1.5": "2012-08-08T09:50:54+00:00",
    ##             "1.6": "2012-08-14T16:27:09+00:00",
    ##             "1.7": "2013-06-06T19:53:42+00:00",
    ##             "1.8": "2013-10-29T14:33:22+00:00",
    ##             "2.0": "2014-07-11T23:50:41+00:00",
    ##             "2.1": "2015-05-05T11:34:14+00:00"
    ##         },
    ##         "latest": "2.1",
    ##         "title": "Tools for Approximate Bayesian Computation (ABC)",
    ##         "archived": false,
    ##         "revdeps": 2
    ##     }
    ## }

### `/-/latest` Latest versions of all packages

This is similar to `/-/all`, but only the latest versions of the
packages are returned, instead of the complete records with all
versions.

``` r
DB("/-/latest?limit=3", head = 20)
```

    ## {
    ##     "A3": {
    ##         "Package": "A3",
    ##         "Type": "Package",
    ##         "Title": "Accurate, Adaptable, and Accessible Error Metrics for Predictive\nModels",
    ##         "Version": "1.0.0",
    ##         "Date": "2015-08-15",
    ##         "Author": "Scott Fortmann-Roe",
    ##         "Maintainer": "Scott Fortmann-Roe <scottfr@berkeley.edu>",
    ##         "Description": "Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.",
    ##         "License": "GPL (>= 2)",
    ##         "Depends": {
    ##             "R": ">= 2.15.0",
    ##             "xtable": "*",
    ##             "pbapply": "*"
    ##         },
    ##         "Suggests": {
    ##             "randomForest": "*",
    ##             "e1071": "*"
    ##         },
    ## 
    ## ... not showing 62 lines ...
    ## 
    ##             "nnet": "*",
    ##             "quantreg": "*",
    ##             "MASS": "*",
    ##             "locfit": "*"
    ##         },
    ##         "Description": "Implements several ABC algorithms for\nperforming parameter estimation, model selection, and goodness-of-fit.\nCross-validation tools are also available for measuring the\naccuracy of ABC estimates, and to calculate the\nmisclassification probabilities of different models.",
    ##         "Repository": "CRAN",
    ##         "License": "GPL (>= 3)",
    ##         "NeedsCompilation": "no",
    ##         "Packaged": "2015-05-05 08:35:25 UTC; mblum",
    ##         "Author": "Csillery Katalin [aut],\nLemaire Louisiane [aut],\nFrancois Olivier [aut],\nBlum Michael [aut, cre]",
    ##         "Maintainer": "Blum Michael <michael.blum@imag.fr>",
    ##         "Date/Publication": "2015-05-05 11:34:14",
    ##         "crandb_file_date": "2015-05-05 05:35:37",
    ##         "date": "2015-05-05T11:34:14+00:00",
    ##         "releases": [
    ## 
    ##         ]
    ##     }
    ## }

### `/-/desc` Short description of latest package versions

Latest versions of all packages, in alphabetical order. It also contains
the `title` fields of the packages. Only active (not archived) packages
are included.

``` r
DB("/-/desc?limit=5")
```

    ## {
    ##     "A3": {
    ##         "version": "1.0.0",
    ##         "title": "Accurate, Adaptable, and Accessible Error Metrics for Predictive\nModels"
    ##     },
    ##     "abbyyR": {
    ##         "version": "0.5.4",
    ##         "title": "Access to Abbyy Optical Character Recognition (OCR) API"
    ##     },
    ##     "abc": {
    ##         "version": "2.1",
    ##         "title": "Tools for Approximate Bayesian Computation (ABC)"
    ##     },
    ##     "abc.data": {
    ##         "version": "1.0",
    ##         "title": "Data Only: Tools for Approximate Bayesian Computation (ABC)"
    ##     },
    ##     "ABC.RAP": {
    ##         "version": "0.9.0",
    ##         "title": "Array Based CpG Region Analysis Pipeline"
    ##     }
    ## }

### `/-/allall` Complete records for all packages, including archived ones

This is similar to `/-/all`, but lists the archived packages as well.

``` r
DB("/-/desc?limit=2", head = 20)
```

    ## {
    ##     "A3": {
    ##         "version": "1.0.0",
    ##         "title": "Accurate, Adaptable, and Accessible Error Metrics for Predictive\nModels"
    ##     },
    ##     "abbyyR": {
    ##         "version": "0.5.4",
    ##         "title": "Access to Abbyy Optical Character Recognition (OCR) API"
    ##     }
    ## }

### `/-/pkgreleases` Package releases

All versions of all packages, in the order of their release. Note that
this includes each version of each package separately, so it is a very
long list, and it is a good idea to use the `limit` parameter.
`descending` can be used to reverse the ordering, and start with the
most recent releases.

``` r
DB("/-/pkgreleases?limit=3&descending=true", head = 20)
```

    ## [
    ##     {
    ##         "date": "2019-04-17T09:10:03+00:00",
    ##         "name": "filehash",
    ##         "event": "released",
    ##         "package": {
    ##             "Package": "filehash",
    ##             "Version": "2.4-2",
    ##             "Depends": {
    ##                 "R": ">= 3.0.0",
    ##                 "methods": "*"
    ##             },
    ##             "Collate": "filehash.R filehash-DB1.R filehash-RDS.R coerce.R dump.R\nhash.R queue.R stack.R zzz.R",
    ##             "Title": "Simple Key-Value Database",
    ##             "Author": "Roger D. Peng <rdpeng@jhu.edu>",
    ##             "Maintainer": "Roger D. Peng <rdpeng@jhu.edu>",
    ##             "Description": "Implements a simple key-value style database where character string keys\nare associated with data values that are stored on the disk. A simple interface is provided for inserting,\nretrieving, and deleting data from the database. Utilities are provided that allow 'filehash' databases to be\ntreated much like environments and lists are already used in R. These utilities are provided to encourage\ninteractive and exploratory analysis on large datasets. Three different file formats for representing the\ndatabase are currently available and new formats can easily be incorporated by third parties for use in the\n'filehash' framework.",
    ##             "License": "GPL (>= 2)",
    ##             "URL": "http://github.com/rdpeng/filehash",
    ##             "NeedsCompilation": "yes",
    ## 
    ## ... not showing 81 lines ...
    ## 
    ##                 "rmarkdown": "*"
    ##             },
    ##             "VignetteBuilder": "knitr",
    ##             "Description": "Provides a quantitative toolkit to explore elastic net families and to uncover correlates contributing to prediction under a cross-validation framework. Fits linear, binomial (logistic) and multinomial models. Candia J and Tsang JS, BMC Bioinformatics (2019) 20:189 <doi:10.1186/s12859-019-2778-5>.",
    ##             "License": "GPL-3",
    ##             "LazyData": "true",
    ##             "LazyLoad": "yes",
    ##             "NeedsCompilation": "no",
    ##             "Packaged": "2019-04-16 21:12:09 UTC; candiajm",
    ##             "Repository": "CRAN",
    ##             "Date/Publication": "2019-04-17 10:00:07 UTC",
    ##             "crandb_file_date": "2019-04-17 11:02:27",
    ##             "MD5sum": "2ef17dbcd7441eea88a06ca959359916",
    ##             "date": "2019-04-17T09:00:07+00:00",
    ##             "releases": [
    ## 
    ##             ]
    ##         }
    ##     }
    ## ]

### `/-/archivals` Package archivals

Package archival events, sorted by date times. The latest version of the
package record is also included. Again, use the `limit` parameter to
query in chunks, and the `descending` parameter to reverse the order,
and see most recent archivals last.

``` r
DB("/-/archivals?limit=3&descending=true", head = 20)
```

    ## [
    ##     {
    ##         "date": "2019-04-17T07:32:26+00:00",
    ##         "name": "packagefinder",
    ##         "event": "archived",
    ##         "package": {
    ##             "Package": "packagefinder",
    ##             "Type": "Package",
    ##             "Title": "Comfortable Search for R Packages on CRAN Directly from the R\nConsole",
    ##             "Version": "0.1.1",
    ##             "Authors@R": "person(\"Joachim\", \"Zuckarelli\", role = c(\"aut\", \"cre\"), email = \"joachim@zuckarelli.de\", comment = c(ORCID = \"0000-0002-9280-3016\"))",
    ##             "Maintainer": "Joachim Zuckarelli <joachim@zuckarelli.de>",
    ##             "Description": "Search for R packages on CRAN directly from the R console, based on the packages' titles, short and long descriptions, or other fields. Combine multiple keywords with logical operators ('and', 'or'), view detailed information on any package and keep track of the latest package contributions to CRAN.",
    ##             "License": "GPL-3",
    ##             "Encoding": "UTF-8",
    ##             "BugReports": "https://github.com/jsugarelli/packagefinder/issues",
    ##             "URL": "https://github.com/jsugarelli/packagefinder/",
    ##             "Repository": "CRAN",
    ##             "LazyData": "true",
    ##             "Imports": {
    ## 
    ## ... not showing 123 lines ...
    ## 
    ##             "NeedsCompilation": "yes",
    ##             "Biarch": "yes",
    ##             "License": "GPL (>= 2)",
    ##             "URL": "https://github.com/vdorie/treatSens",
    ##             "BugReports": "https://github.com/vdorie/treatSens/issues",
    ##             "RoxygenNote": "5.0.1",
    ##             "Packaged": "2018-03-08 19:07:07 UTC; t89v647",
    ##             "Author": "Nicole Bohme Carnegie [aut, cre],\nMasataka Harada [aut],\nVincent Dorie [aut],\nJennifer Hill [ctb]",
    ##             "Maintainer": "Nicole Bohme Carnegie <nicole.carnegie@montana.edu>",
    ##             "Repository": "CRAN",
    ##             "Date/Publication": "2018-03-08 23:32:57 UTC",
    ##             "crandb_file_date": "2018-03-08 23:38:21",
    ##             "MD5sum": "1a937de0b08ff46784618883b9bd8ebf",
    ##             "date": "2018-03-08T22:32:57+00:00",
    ##             "releases": [
    ## 
    ##             ]
    ##         }
    ##     }
    ## ]

### `/-/events` Release and archival events

The union of `/-/pkgreleases` and `/-/archivals`, so it includes all
package releases and archivals.

``` r
DB("/-/events?limit=3&descending=true", head = 20)
```

    ## [
    ##     {
    ##         "date": "2019-04-17T09:10:03+00:00",
    ##         "name": "filehash",
    ##         "event": "released",
    ##         "package": {
    ##             "Package": "filehash",
    ##             "Version": "2.4-2",
    ##             "Depends": {
    ##                 "R": ">= 3.0.0",
    ##                 "methods": "*"
    ##             },
    ##             "Collate": "filehash.R filehash-DB1.R filehash-RDS.R coerce.R dump.R\nhash.R queue.R stack.R zzz.R",
    ##             "Title": "Simple Key-Value Database",
    ##             "Author": "Roger D. Peng <rdpeng@jhu.edu>",
    ##             "Maintainer": "Roger D. Peng <rdpeng@jhu.edu>",
    ##             "Description": "Implements a simple key-value style database where character string keys\nare associated with data values that are stored on the disk. A simple interface is provided for inserting,\nretrieving, and deleting data from the database. Utilities are provided that allow 'filehash' databases to be\ntreated much like environments and lists are already used in R. These utilities are provided to encourage\ninteractive and exploratory analysis on large datasets. Three different file formats for representing the\ndatabase are currently available and new formats can easily be incorporated by third parties for use in the\n'filehash' framework.",
    ##             "License": "GPL (>= 2)",
    ##             "URL": "http://github.com/rdpeng/filehash",
    ##             "NeedsCompilation": "yes",
    ## 
    ## ... not showing 81 lines ...
    ## 
    ##                 "rmarkdown": "*"
    ##             },
    ##             "VignetteBuilder": "knitr",
    ##             "Description": "Provides a quantitative toolkit to explore elastic net families and to uncover correlates contributing to prediction under a cross-validation framework. Fits linear, binomial (logistic) and multinomial models. Candia J and Tsang JS, BMC Bioinformatics (2019) 20:189 <doi:10.1186/s12859-019-2778-5>.",
    ##             "License": "GPL-3",
    ##             "LazyData": "true",
    ##             "LazyLoad": "yes",
    ##             "NeedsCompilation": "no",
    ##             "Packaged": "2019-04-16 21:12:09 UTC; candiajm",
    ##             "Repository": "CRAN",
    ##             "Date/Publication": "2019-04-17 10:00:07 UTC",
    ##             "crandb_file_date": "2019-04-17 11:02:27",
    ##             "MD5sum": "2ef17dbcd7441eea88a06ca959359916",
    ##             "date": "2019-04-17T09:00:07+00:00",
    ##             "releases": [
    ## 
    ##             ]
    ##         }
    ##     }
    ## ]

### `/-/releases` List of R versions

List of all R versions supported by the database. Currently this goes
back to version 2.0.0, older versions will be potentially added later.

``` r
DB("/-/releases", head = 20)
```

    ## [
    ##     {
    ##         "version": "2.0.0",
    ##         "date": "2004-10-04T00:00:00+00:00"
    ##     },
    ##     {
    ##         "version": "2.0.1",
    ##         "date": "2004-11-15T00:00:00+00:00"
    ##     },
    ##     {
    ##         "version": "2.1.0",
    ##         "date": "2005-04-18T00:00:00+00:00"
    ##     },
    ##     {
    ##         "version": "2.1.1",
    ##         "date": "2005-06-20T00:00:00+00:00"
    ##     },
    ##     {
    ##         "version": "2.2.0",
    ##         "date": "2005-10-06T00:00:00+00:00"
    ## 
    ## ... not showing 146 lines ...
    ## 
    ##         "version": "3.0.1",
    ##         "date": "2013-05-16T00:00:00+00:00"
    ##     },
    ##     {
    ##         "version": "3.0.2",
    ##         "date": "2013-09-25T00:00:00+00:00"
    ##     },
    ##     {
    ##         "version": "3.0.3",
    ##         "date": "2014-03-06T00:00:00+00:00"
    ##     },
    ##     {
    ##         "version": "3.1.0",
    ##         "date": "2014-04-10T00:00:00+00:00"
    ##     },
    ##     {
    ##         "version": "3.1.1",
    ##         "date": "2014-07-10T00:00:00+00:00"
    ##     }
    ## ]

### `/-/releasepkgs/:version` Packages that were current at an R release

All package records that were current when a given version of R was
released. This is essentially a snapshot of CRAN, for a given R release.

``` r
DB("/-/releasepkgs/2.15.3", head = 20)
```

    ## {
    ##     "aaMI": {
    ##         "Package": "aaMI",
    ##         "Version": "1.0-1",
    ##         "Date": "2005-07-08",
    ##         "Title": "Mutual information for protein sequence alignments",
    ##         "Author": "Kurt Wollenberg <kurt.wollenberg@gmail.com>",
    ##         "Maintainer": "Kurt Wollenberg <kurt.wollenberg@gmail.com>",
    ##         "Depends": {
    ##             "R": ">= 2.0.0"
    ##         },
    ##         "Description": "This package contains five functions. read.FASTA reads in a\nFASTA-format alignment file and parses it into a data frame. read.CX reads\nin a ClustalX .aln-format file and parses it into a data frame. read.Gdoc\nreads in a GeneDoc .msf-format file and parses it into a data frame. The\nalignment data frame returned by each of these functions has the sequence\nIDs as the row names and each site in the alignment is a column in the data\nframe. The program aaMI calculates the mutual information between each pair\nof sites (columns) in the protein sequence alignment data frame. The\nprogram aaMIn calculates the normalized mutual information between pairs of\nsites in the protein sequence alignment data frame. The normalized mutual\ninformation of sites i and j is the mutual information of these sites\ndivided by their joint entropy.",
    ##         "License": "GPL version 2 or newer",
    ##         "Packaged": "Mon Oct 17 11:06:36 2005; kwollenberg",
    ##         "crandb_file_date": "2005-10-17 15:24:18",
    ##         "date": "2005-10-17T15:06:36+00:00",
    ##         "releases": [
    ##             "2.2.1",
    ##             "2.3.0",
    ##             "2.3.1",
    ## 
    ## ... not showing 160255 lines ...
    ## 
    ##             "Kendall": "*"
    ##         },
    ##         "Suggests": {
    ## 
    ##         },
    ##         "Description": "The zyp package contains an efficient implementation of<U+000a>Sen's slope method plus implementation of Xuebin Zhang's<U+000a>(Zhang, 1999) and Yue-Pilon's (Yue, 2002) prewhitening<U+000a>approaches to determining trends in climate data.",
    ##         "License": "LGPL-2.1",
    ##         "URL": "http://www.r-project.org",
    ##         "Packaged": "2012-10-29 09:00:03 UTC; ripley",
    ##         "Repository": "CRAN",
    ##         "Date/Publication": "2012-10-29 09:00:03",
    ##         "crandb_file_date": "2012-10-29 04:00:03",
    ##         "date": "2012-10-29T09:00:03+00:00",
    ##         "releases": [
    ##             "2.15.3",
    ##             "3.0.0",
    ##             "3.0.1"
    ##         ]
    ##     }
    ## }

### `/-/release/:version` Package versions that were current at an R release

Similar to the previous list, but it only includes the version numbers,
and not the records of the packages.

``` r
DB("/-/release/2.15.3", head = 20)
```

    ## {
    ##     "aaMI": "1.0-1",
    ##     "abc": "1.6",
    ##     "abcdeFBA": "0.4",
    ##     "abctools": "0.1-2",
    ##     "abd": "0.2-4",
    ##     "abind": "1.4-0",
    ##     "aBioMarVsuit": "1.0",
    ##     "AcceptanceSampling": "1.0-2",
    ##     "ACCLMA": "1.0",
    ##     "accuracy": "1.35",
    ##     "Ace": "0.0.8",
    ##     "acepack": "1.3-3.2",
    ##     "acer": "0.1.2",
    ##     "aCGH.Spline": "2.2",
    ##     "ACNE": "0.5.0",
    ##     "acs": "0.8",
    ##     "Actigraphy": "1.2",
    ##     "actuar": "1.1-6",
    ##     "ActuDistns": "3.0",
    ## 
    ## ... not showing 4678 lines ...
    ## 
    ##     "YjdnJlp": "0.9.8",
    ##     "YourCast": "1.5-1",
    ##     "YuGene": "1.0",
    ##     "ZeBook": "0.3",
    ##     "Zelig": "4.1-3",
    ##     "ZeligChoice": "0.7-0",
    ##     "ZeligGAM": "0.7-0",
    ##     "ZeligMultilevel": "0.7-0",
    ##     "zendeskR": "0.3",
    ##     "zic": "0.7.5",
    ##     "zicounts": "1.1.5",
    ##     "ZIGP": "3.8",
    ##     "zipcode": "1.0",
    ##     "zipfR": "0.6-6",
    ##     "zmatrix": "1.1",
    ##     "zoeppritz": "1.0-3",
    ##     "zoo": "1.7-9",
    ##     "zooimage": "3.0-3",
    ##     "zyp": "0.9-1"
    ## }

### `/-/releasedesc/:version` Short description of CRAN snapshots

Similar to `/-/release`, but it also include the the `title` fields of
the packages.

``` r
DB("/-/releasedesc/2.15.3", head = 20)
```

    ## {
    ##     "aaMI": {
    ##         "version": "1.0-1",
    ##         "title": "Mutual information for protein sequence alignments"
    ##     },
    ##     "abc": {
    ##         "version": "1.6",
    ##         "title": "Tools for Approximate Bayesian Computation (ABC)"
    ##     },
    ##     "abcdeFBA": {
    ##         "version": "0.4",
    ##         "title": "ABCDE_FBA: A-Biologist-Can-Do-Everything of Flux Balance<U+000a>Analysis with this package."
    ##     },
    ##     "abctools": {
    ##         "version": "0.1-2",
    ##         "title": "Algorithms for ABC summary statistics selection"
    ##     },
    ##     "abd": {
    ##         "version": "0.2-4",
    ##         "title": "The Analysis of Biological Data"
    ## 
    ## ... not showing 18802 lines ...
    ## 
    ##         "version": "1.1",
    ##         "title": "Zero-offset matrices"
    ##     },
    ##     "zoeppritz": {
    ##         "version": "1.0-3",
    ##         "title": "Zoeppritz Equations"
    ##     },
    ##     "zoo": {
    ##         "version": "1.7-9",
    ##         "title": "S3 Infrastructure for Regular and Irregular Time Series (Z's<U+000a>ordered observations)"
    ##     },
    ##     "zooimage": {
    ##         "version": "3.0-3",
    ##         "title": "Analysis of numerical zooplankton images"
    ##     },
    ##     "zyp": {
    ##         "version": "0.9-1",
    ##         "title": "Zhang + Yue-Pilon trends package"
    ##     }
    ## }

### `/-/topdeps/:version` Packages most depended upon

Top twenty packages. It includes all forms of dependencies, and it can
be restricted to dependencies that were in place at a given R release.

``` r
DB("/-/topdeps/3.1.1")
```

    ## [
    ##     {
    ##         "MASS": 623
    ##     },
    ##     {
    ##         "lattice": 311
    ##     },
    ##     {
    ##         "mvtnorm": 219
    ##     },
    ##     {
    ##         "Matrix": 214
    ##     },
    ##     {
    ##         "survival": 198
    ##     },
    ##     {
    ##         "ggplot2": 196
    ##     },
    ##     {
    ##         "testthat": 164
    ##     },
    ##     {
    ##         "plyr": 142
    ##     },
    ##     {
    ##         "Rcpp": 139
    ##     },
    ##     {
    ##         "rgl": 112
    ##     },
    ##     {
    ##         "XML": 109
    ##     },
    ##     {
    ##         "igraph": 104
    ##     },
    ##     {
    ##         "nlme": 103
    ##     },
    ##     {
    ##         "coda": 101
    ##     },
    ##     {
    ##         "sp": 97
    ##     },
    ##     {
    ##         "RUnit": 94
    ##     },
    ##     {
    ##         "boot": 94
    ##     },
    ##     {
    ##         "knitr": 89
    ##     },
    ##     {
    ##         "RColorBrewer": 85
    ##     },
    ##     {
    ##         "xtable": 84
    ##     }
    ## ]

For the latest versions of the packages and their dependencies, you can
set `:version` to `dev`:

``` r
DB("/-/topdeps/devel")
```

    ## [
    ##     {
    ##         "knitr": 3898
    ##     },
    ##     {
    ##         "testthat": 3806
    ##     },
    ##     {
    ##         "rmarkdown": 2957
    ##     },
    ##     {
    ##         "ggplot2": 2177
    ##     },
    ##     {
    ##         "MASS": 1807
    ##     },
    ##     {
    ##         "Rcpp": 1648
    ##     },
    ##     {
    ##         "dplyr": 1442
    ##     },
    ##     {
    ##         "Matrix": 885
    ##     },
    ##     {
    ##         "magrittr": 868
    ##     },
    ##     {
    ##         "covr": 827
    ##     },
    ##     {
    ##         "stringr": 757
    ##     },
    ##     {
    ##         "plyr": 708
    ##     },
    ##     {
    ##         "mvtnorm": 684
    ##     },
    ##     {
    ##         "jsonlite": 681
    ##     },
    ##     {
    ##         "data.table": 644
    ##     },
    ##     {
    ##         "survival": 640
    ##     },
    ##     {
    ##         "lattice": 611
    ##     },
    ##     {
    ##         "shiny": 600
    ##     },
    ##     {
    ##         "tidyr": 595
    ##     },
    ##     {
    ##         "httr": 592
    ##     }
    ## ]

### `/-/deps/:version` Number of reverse dependencies

For all packages, not just the top twenty.

``` r
DB("/-/deps/2.15.1", head = 20)
```

    ## {
    ##     "abind": 34,
    ##     "accuracy": 3,
    ##     "acepack": 2,
    ##     "aCGH": 2,
    ##     "actuar": 8,
    ##     "ada": 3,
    ##     "adabag": 1,
    ##     "adapt": 3,
    ##     "ade4": 23,
    ##     "adegenet": 2,
    ##     "adehabitat": 4,
    ##     "adehabitatHR": 1,
    ##     "adehabitatLT": 1,
    ##     "adehabitatMA": 3,
    ##     "adephylo": 1,
    ##     "ADGofTest": 2,
    ##     "adimpro": 3,
    ##     "adlift": 1,
    ##     "AER": 7,
    ## 
    ## ... not showing 1357 lines ...
    ## 
    ##     "XLConnectJars.1": 1,
    ##     "xlsxjars": 1,
    ##     "XML": 84,
    ##     "XMLRPC": 1,
    ##     "XMLSchema": 3,
    ##     "xpose4": 1,
    ##     "xpose4data": 3,
    ##     "xpose4generic": 2,
    ##     "xpose4specific": 1,
    ##     "xtable": 60,
    ##     "xtermStyle": 1,
    ##     "xts": 18,
    ##     "yacca": 1,
    ##     "yaImpute": 1,
    ##     "YaleToolkit": 2,
    ##     "yaml": 1,
    ##     "Zelig": 5,
    ##     "zipfR": 2,
    ##     "zoo": 57
    ## }
