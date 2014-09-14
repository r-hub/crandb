


# The CRAN database

[![Linux Build Status](https://travis-ci.org/metacran/crandb.png?branch=master)](https://travis-ci.org/metacran/crandb)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/ppju92n10cdaw5ti)](https://ci.appveyor.com/project/gaborcsardi/crandb)

The CRAN database provides an API for programatically accessing all
meta-data of CRAN R packages. This API can be used for various purposes,
here are three examples I am woking on right now:
* Writing a package manager for R. The package manager can use the
  CRAN DB API to query dependencies, or other meta data.
* Building a search engine for CRAN packages. The DB itself does not
  provide a search API, but it can be (easily) mirrored in a search
  engine.
* Creating an RSS feed for the new, updated or archived packages on CRAN.

**Note that `crandb` is _NOT_ an official CRAN project, and is not supported
by CRAN.**

## The `crandb` API

### Packages

`package()` returns the latest version of a package:


```r
library(crandb)
package("dotenv")
```

```
## CRAN package dotenv 1.0, 17 days ago
## Title: Load environment variables from .env
## Maintainer: "Gabor Csardi" <csardi.gabor@gmail.com>
## Author: "Gabor Csardi" [aut, cre]
## BugReports: https://github.com/gaborcsardi/dotenv/issues
## Date/Publication: 2014-08-27 23:42:52
## Description: Load configuration from a .env file, that is in the current working
##     directory, into environment variables.
## Imports: magrittr (*), falsy (*)
## LazyData: true
## License: MIT + file LICENSE
## NeedsCompilation: no
## Packaged: 2014-08-27 19:55:50 UTC; gaborcsardi
## releases:
## Repository: CRAN
## URL: https://github.com/gaborcsardi/dotenv
```

A given version can be queried as well:


```r
package("httr", version = "0.3")
```

```
## CRAN package httr 0.3, 5 months ago
## Title: Tools for working with URLs and HTTP
## Maintainer: Hadley Wickham <h.wickham@gmail.com>
## Author: Hadley Wickham <h.wickham@gmail.com>
## Date/Publication: 2014-03-20 03:03:51
## Depends: R (>= 3.0.0)
## Description: Provides useful tools for working with HTTP connections.  Is a
##     simplified wrapper built on top of RCurl.  It is much much less configurable
##     but because it only attempts to encompass the most common operations it is
##     also much much simpler.
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
```

Or all versions:


```r
package("httr", version = "all")
```

```
## CRAN package httr, latest: 0.5, 11 days ago
## ['0.5']:
##   Title: Tools for working with URLs and HTTP
##   Maintainer: Hadley Wickham <hadley@rstudio.com>
##   Author: Hadley Wickham [cre, aut, cph], RStudio [cph]
##   Date/Publication: 2014-09-02 18:15:25
##   Depends: R (>= 3.0.0)
##   Description: Provides useful tools for working with HTTP. The API is based
##       around http verbs (GET(), POST(), etc) with pluggable components to
##       control the request (authenticate(), add_headers() and so on).
##   Imports: RCurl (>= 1.95-0), stringr (>= 0.6.1), digest (*), tools (*), methods
##       (*), jsonlite (*)
##   License: MIT + file LICENSE
##   NeedsCompilation: yes
##   Packaged: 2014-09-02 15:28:39 UTC; hadley
##   releases:
##   Repository: CRAN
##   Suggests: XML (*), testthat (>= 0.8.0), png (*), jpeg (*), httpuv (*), knitr
##       (*)
##   Type: Package
##   VignetteBuilder: knitr
## Other versions: 0.4, 0.3, 0.2, 0.1.1, 0.1
```

### List of all packages

`list_packages()` lists all packages, in various formats, potentially including
archived packages as well:


```r
list_packages(from = "falsy", limit = 10, archived = FALSE)
```

```
## CRAN packages (short)--------------------------------------------------------------------
##  Package     Version Title                                                               
##  falsy       1.0     Define truthy and falsy values                                      
##  fame        2.18    Interface for FAME time series database                             
##  Familias    2.1     Probabilities for Pedigrees given DNA data                          
##  FAMT        2.5     Factor Analysis for Multiple Testing (FAMT) : simultaneous tests ...
##  fanc        1.13    Penalized likelihood factor analysis via nonconvex penalty          
##  fANCOVA     0.5-1   Nonparametric Analysis of Covariance                                
##  fanovaGraph 1.4.7   Building Kriging models from FANOVA graphs                          
##  fanplot     3.3     Visualisation of sequential probability distributions using fan c...
##  FAOSTAT     1.6     A complementary package to the FAOSTAT database and the Statistic...
##  faoutlier   0.4     Influential case detection methods for factor analysis and SEM
```

### CRAN events

`events()` lists CRAN events, starting from the latest ones. New package
releases and archival can both be included in the list. By default the last
10 events are included:


```r
events()
```

```
## CRAN events (events)---------------------------------------------------------------------
##  . When    Package            Version Title                                              
##  + 10 hour iBATCGH            1.1     Integrative Bayesian Analysis of Transcriptomic ...
##  + 17 hour Lahman             3.0-1   Sean Lahman's Baseball Database                    
##  + 1 day   HH                 3.1-5   Statistical Analysis and Data Display: Heiberger...
##  + 1 day   geepack            1.2-0   Generalized Estimating Equation Package            
##  + 1 day   recosystem         0.2.4   Recommender System using Matrix Factorization      
##  + 1 day   seedy              0.2     Simulation of Evolutionary and Epidemiological D...
##  + 1 day   referenceIntervals 1.1.1   Reference Intervals                                
##  + 1 day   phyloland          1.3     Modelling Competitive Exclusion and Limited Disp...
##  + 1 day   ONETr              1.0     Efficient authenticated interaction with the O*N...
##  - 1 day   MASSI              1.1     MicroArray Sample Sex Identifier
```

### R and CRAN releases

The `releases()` function lists recent R versions, with their release dates.


```r
releases()
```

```
## R releases-------------------------------------------------------------------------------
##  Version Date      
##  2.0.0   2004-10-04
##  2.0.1   2004-11-15
##  2.1.0   2005-04-18
##  2.1.1   2005-06-20
##  2.2.0   2005-10-06
##  2.2.1   2005-12-20
##  2.3.0   2006-04-24
##  2.3.1   2006-06-01
##  2.4.0   2006-10-03
##  2.4.1   2006-12-18
##  2.5.0   2007-04-24
##  2.5.1   2007-06-28
##  2.6.0   2007-10-03
##  2.6.1   2007-11-26
##  2.6.2   2008-02-08
##  2.7.0   2008-04-22
##  2.7.1   2008-06-23
##  2.7.2   2008-08-25
##  2.8.0   2008-10-20
##  2.8.1   2008-12-22
##  2.9.0   2009-04-17
##  2.9.1   2009-06-26
##  2.9.2   2009-08-24
##  2.10.0  2009-10-26
##  2.10.1  2009-12-14
##  2.11.0  2010-04-22
##  2.11.1  2010-05-31
##  2.12.0  2010-10-15
##  2.12.1  2010-12-16
##  2.12.2  2011-02-25
##  2.13.0  2011-04-13
##  2.13.1  2011-07-08
##  2.13.2  2011-09-30
##  2.14.0  2011-10-31
##  2.14.1  2011-12-22
##  2.14.2  2012-02-29
##  2.15.0  2012-03-30
##  2.15.1  2012-06-22
##  2.15.2  2012-10-26
##  2.15.3  2013-03-01
##  3.0.0   2013-04-03
##  3.0.1   2013-05-16
##  3.0.2   2013-09-25
##  3.0.3   2014-03-06
##  3.1.0   2014-04-10
##  3.1.1   2014-07-10
```

The CRAN packages that were current at the time of an R releases can be listed
with the `cran_releases()` function:


```r
cran_releases(version = "2.13.1")
```

```
## CRAN release 2.13.1----------------------------------------------------------------------
##   [1] "aaMI@1.0-1"               "abc@1.3"                  "abd@0.1-18"              
##   [4] "abind@1.3-0"              "AcceptanceSampling@1.0-1" "accuracy@1.35"           
##   [7] "acepack@1.3-3.0"          "aCGH.Spline@2.1"          "actuar@1.1-2"            
##  [10] "ada@2.0-2"                "adabag@1.1"               "ADaCGH@1.5-3"            
##  [13] "adapt@1.0-4"              "AdaptFit@0.2-1"           "adaptivetau@0.902"       
##  [16] "adaptTest@1.0"            "ade4@1.4-17"              "ade4TkGUI@0.2-4"         
##  [19] "adegenet@1.3-0"           "adehabitat@1.8.6"         "adehabitatHR@0.3.2"      
##  [22] "adehabitatHS@0.3.1"       "adehabitatLT@0.3.2"       "adehabitatMA@0.3"        
##  [25] "adephylo@1.1-1"           "ADGofTest@0.1"            "adimpro@0.7.5"           
##  [28] "adk@1.0-1"                "adlift@0.9-6"             "ADM3@1.1"                
##  [31] "AdMit@1-01.03.1"          "ads@1.2-10"               "AER@1.1-8"               
##  [34] "afc@1.0"                  "afmtools@0.1.2"           "agce@1.2"                
##  [37] "agilp@1.0"                "agreement@1.0-1"          "agricolae@1.0-9"         
##  [40] "agridat@1.2"              "AGSDest@2.0"              "agsemisc@1.2-1"          
##  [43] "ahaz@1.1"                 "AICcmodavg@1.17"          "AIGIS@1.0"               
##  [46] "AIM@1.01"                 "AIS@1.0"                  "akima@0.5-4"             
##  [49] "alabama@2011.3-1"         "AlgDesign@1.1-2"          "allan@1.0"               
##  [52] "allelic@0.1"              "AllPossibleSpellings@1.0" "alphahull@0.2-0"         
##  [55] "alr3@2.0.3"               "ALS@0.0.4"                "AMA@1.0.8"               
##  [58] "amap@0.8-5"               "amba@0.3.0"               "amei@1.0-3"              
##  [61] "Amelia@1.2-18"            "amer@0.6.10"              "AMORE@0.2-12"            
##  [64] "anacor@1.0-1"             "analogue@0.7-0"           "AnalyzeFMRI@1.1-13"      
##  [67] "AnalyzeIO@0.1.1"          "anapuce@2.1"              "anchors@3.0-7"           
##  [70] "anesrake@0.65"            "Animal@1.02"              "animation@2.0-4"         
##  [73] "anm@1.0-9"                "AnnotLists@1.0"           "ant@0.0-10"              
##  [76] "aod@1.2"                  "apcluster@1.1.0"          "ape@2.7-2"               
##  [79] "aplpack@1.2.3"            "approximator@1.2-2"       "apsrtable@0.8-6"         
##  [82] "apt@1.0"                  "apTreeshape@1.4-3"        "aqfig@0.1"               
##  [85] "aqp@0.99-1"               "AquaEnv@1.0-2"            "aratio@1.0"              
##  [88] "archetypes@2.0-2"         "ArDec@1.2-3"              "ares@0.7.2"              
##  [91] "ARES@1.2-3"               "arf3DS4@2.5-2"            "argosfilter@0.6"         
##  [94] "arm@1.4-13"               "aroma.affymetrix@2.1.0"   "aroma.apd@0.1.8"         
##  [97] "aroma.cn@0.7.3"           "aroma.core@2.1.0"         "arrayImpute@1.3"         
## [100] "arrayMissPattern@1.3"     "ars@0.4"                  "arules@1.0-6"            
## [103] "arulesNBMiner@0.1-1"      "arulesSequences@0.1-11"   "arulesViz@0.1-3"         
## [106] "ascii@1.4"                "ash@1.0-12"               "aspace@3.0"              
## [109] "aspect@1.0-0"             "assist@3.1.1"             "aster@0.7-7"             
## [112] "aster2@0.1"               "asuR@0.08-24"             "asympTest@0.1.2"         
## [115] "asypow@1.2.2"             "atm@0.1.0"                "atmi@1.0"                
## [118] "audio@0.1-4"              "automap@1.0-10"           "aws@1.6-2"               
## [121] "aylmer@1.0-7"             "B2Z@1.3"                  "BaBooN@0.1-6"            
## [124] "BACCO@2.0-2"              "backfitRichards@0.5.0"    "backtest@0.3-0"          
## [127] "BaM@0.98.1"               "BAMD@3.4"                 "barcode@1.0"             
## [130] "BARD@1.24"                "bark@0.1-0"               "Barnard@1.0"             
## [133] "BAS@0.92"                 "baseline@1.0-0"           "basicspace@0.02"         
## [136] "batch@1.1-3"              "bats@0.1-2"               "bayesCGH@0.6"            
## [139] "bayesclust@3.0"           "bayescount@0.9.9-1"       "BayesDA@1.0-1"           
## [142] "bayesDem@1.3-0"           "bayesGARCH@1-00.10"       "bayesLife@0.2-0"         
## [145] "bayesm@2.2-4"             "bayesmix@0.7-1"           "bayespack@1.0-2"         
## [148] "BayesPanel@0.1-2"         "bayesQR@1.3"              "BayesQTLBIC@1.0-1"       
## [151] "bayesSurv@0.6-2"          "bayesTFR@1.4-0"           "BayesTree@0.3-1.1"       
## [154] "BayesValidate@0.0"        "BayesX@0.2-5"             "BayHap@1.0"              
## [157] "BayHaz@0.0-6"             "baymvb@1.0.4"             "BAYSTAR@0.2-3"           
## [160] "BB@2011.2-2"              "bbemkr@1.3"               "bbmle@1.0.0"             
## [163] "BBMM@2.2"                 "BCA@0.1-1"                "BCE@1.3"                 
## [166] "Bchron@3.1.4"             "bclust@1.2"               "bcp@2.2.0"               
## [169] "bcv@1.0"                  "bdoc@1.1"                 "bdsmatrix@1.0"           
## [172] "beadarrayMSV@1.1.0"       "beanplot@1.1"             "bear@2.5.2"              
## [175] "beeswarm@0.0.7"           "belief@1.0.1"             "benchden@1.0.4"          
## [178] "benchmark@0.3-2"          "Benchmarking@0.19"        "bentcableAR@0.2.2"       
## [181] "ber@2.0"                  "Bergm@1.4"                "Bessel@0.5-3"            
## [184] "bestglm@0.31"             "betaper@1.0-0"            "betareg@2.3-0"           
## [187] "bethel@0.1"               "bfast@1.2-1"              "bfp@0.0-19"              
## [190] "bgmm@1.2"                 "Bhat@0.9-09"              "BHH2@1.0.3"              
## [193] "BiasedUrn@1.03"           "bibtex@0.2-1"             "biclust@1.0.1"           
## [196] "bicreduc@0.4-7"           "bifactorial@1.4.6"        "biganalytics@1.0.14"     
## [199] "biglars@1.0.1"            "biglm@0.7"               
##  [ reached getOption("max.print") -- omitted 2961 entries ]
```

## The raw API

This is the raw JSON API.

We will use the
[`httr`](https://github.com/hadley/httr) package to query it, and the
[`jsonlite`](https://github.com/jeroenooms/jsonlite) package to nicely
format it. [`magrittr`](https://github.com/smbache/magrittr) is loaded
for the pipes. We use `DB` to query the API and format the result.


```r
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
  paste0("http://db.r-pkg.org", "/", api) %>%
    httr::GET() %>%
	httr::content(as = "text", encoding = "UTF-8") %>%
	jsonlite::prettify() %>%
	skip_lines(head = head, tail = tail) %>%
	cat()
}
```

### `/:pkg` Latest version of a package

The result includes all fields verbatim from the DESCRIPTION file,
plus some extra:
* `date`: The date and time when the package was published on CRAN.
  This is needed, because especially old packages might not have some
  (or any) of the `Date`, `Date/Publication` or `Packaged` fields.
* `releases`: The R version(s) that were released when this version
  of the package was the latest on CRAN.
* The `Suggests`, `Depends`, etc. fields are formatted as named lists.


```r
DB("/magrittr")
```

```
## {
## 	"Package" : "magrittr",
## 	"Type" : "Package",
## 	"Title" : "magrittr - a forward-pipe operator for R",
## 	"Version" : "1.0.1",
## 	"Date" : "2014-05-14",
## 	"Author" : "Stefan Milton Bache <stefan@stefanbache.dk> and\u000aHadley Wickham <h.wickham@gmail.com>",
## 	"Maintainer" : "Stefan Milton Bache <stefan@stefanbache.dk>",
## 	"Description" : "Provides a mechanism for chaining commands with a\u000anew forward-pipe operator. Ceci n'est pas un pipe.",
## 	"Suggests" : {
## 		"testthat" : "*",
## 		"knitr" : "*"
## 	},
## 	"VignetteBuilder" : "knitr",
## 	"License" : "MIT + file LICENSE",
## 	"Packaged" : "2014-05-15 18:49:49 UTC; shb",
## 	"NeedsCompilation" : "no",
## 	"Repository" : "CRAN",
## 	"Date/Publication" : "2014-05-15 21:12:27",
## 	"crandb_file_date" : "2014-05-15 15:12:29",
## 	"date" : "2014-05-15T21:12:27+00:00",
## 	"releases" : [
## 		"3.1.1"
## 	]
## }
```

### `/:pkg/:version` A specific version of a package

The format is the same as for the latest version.


```r
DB("/magrittr/1.0.0")
```

```
## {
## 	"Package" : "magrittr",
## 	"Type" : "Package",
## 	"Title" : "magrittr - a forward-pipe operator for R",
## 	"Version" : "1.0.0",
## 	"Date" : "2014-01-19",
## 	"Author" : "Stefan Milton Bache <stefan@stefanbache.dk> and\u000aHadley Wickham <h.wickham@gmail.com>",
## 	"Maintainer" : "Stefan <stefan@stefanbache.dk>",
## 	"Description" : "Provides a mechanism for chaining commands with a\u000anew forward-pipe operator. Ceci n'est pas un pipe.",
## 	"Suggests" : {
## 		"testthat" : "*",
## 		"knitr" : "*"
## 	},
## 	"VignetteBuilder" : "knitr",
## 	"License" : "MIT + file LICENSE",
## 	"Packaged" : "2014-02-25 16:05:59 UTC; shb",
## 	"NeedsCompilation" : "no",
## 	"Repository" : "CRAN",
## 	"Date/Publication" : "2014-02-25 18:01:09",
## 	"crandb_file_date" : "2014-02-25 12:01:11",
## 	"date" : "2014-02-25T18:01:09+00:00",
## 	"releases" : [
## 		"3.0.3",
## 		"3.1.0"
## 	]
## }
```

### `/:pkg/all` All versions of a package

The result is a list of package versions in the `versions` field, in the
format above, plus some extra:
* `name`: The name of the package.
* `title`: The title field of the package.
* `latest`: The latest version of the package.
* `archived`: Whether the package was archived.
* `timeline`: All versions and their release dates of the package.


```r
DB("/magrittr/all")
```

```
## {
## 	"_id" : "magrittr",
## 	"_rev" : "1-a8d52d0e409af456cc4c5eac957b5609",
## 	"name" : "magrittr",
## 	"versions" : {
## 		"1.0.0" : {
## 			"Package" : "magrittr",
## 			"Type" : "Package",
## 			"Title" : "magrittr - a forward-pipe operator for R",
## 			"Version" : "1.0.0",
## 			"Date" : "2014-01-19",
## 			"Author" : "Stefan Milton Bache <stefan@stefanbache.dk> and\u000aHadley Wickham <h.wickham@gmail.com>",
## 			"Maintainer" : "Stefan <stefan@stefanbache.dk>",
## 			"Description" : "Provides a mechanism for chaining commands with a\u000anew forward-pipe operator. Ceci n'est pas un pipe.",
## 			"Suggests" : {
## 				"testthat" : "*",
## 				"knitr" : "*"
## 			},
## 			"VignetteBuilder" : "knitr",
## 			"License" : "MIT + file LICENSE",
## 			"Packaged" : "2014-02-25 16:05:59 UTC; shb",
## 			"NeedsCompilation" : "no",
## 			"Repository" : "CRAN",
## 			"Date/Publication" : "2014-02-25 18:01:09",
## 			"crandb_file_date" : "2014-02-25 12:01:11",
## 			"date" : "2014-02-25T18:01:09+00:00",
## 			"releases" : [
## 				"3.0.3",
## 				"3.1.0"
## 			]
## 		},
## 		"1.0.1" : {
## 			"Package" : "magrittr",
## 			"Type" : "Package",
## 			"Title" : "magrittr - a forward-pipe operator for R",
## 			"Version" : "1.0.1",
## 			"Date" : "2014-05-14",
## 			"Author" : "Stefan Milton Bache <stefan@stefanbache.dk> and\u000aHadley Wickham <h.wickham@gmail.com>",
## 			"Maintainer" : "Stefan Milton Bache <stefan@stefanbache.dk>",
## 			"Description" : "Provides a mechanism for chaining commands with a\u000anew forward-pipe operator. Ceci n'est pas un pipe.",
## 			"Suggests" : {
## 				"testthat" : "*",
## 				"knitr" : "*"
## 			},
## 			"VignetteBuilder" : "knitr",
## 			"License" : "MIT + file LICENSE",
## 			"Packaged" : "2014-05-15 18:49:49 UTC; shb",
## 			"NeedsCompilation" : "no",
## 			"Repository" : "CRAN",
## 			"Date/Publication" : "2014-05-15 21:12:27",
## 			"crandb_file_date" : "2014-05-15 15:12:29",
## 			"date" : "2014-05-15T21:12:27+00:00",
## 			"releases" : [
## 				"3.1.1"
## 			]
## 		}
## 	},
## 	"timeline" : {
## 		"1.0.0" : "2014-02-25T18:01:09+00:00",
## 		"1.0.1" : "2014-05-15T21:12:27+00:00"
## 	},
## 	"latest" : "1.0.1",
## 	"title" : "magrittr - a forward-pipe operator for R",
## 	"archived" : false
## }
```

### `/-/all` All packages, in alphabetical order

Note that this API point _really_ returns a list of all active CRAN packages
(currently about 6,000), so it is a good idea to query the date in
chunks. `limit` specifies the number of records to return, and `startkey`
can be used to specify the first key to list. Note that the result will
include the full records of the package, all package versions.


```r
DB("/-/all?limit=3", head = 20)
```

```
## {
## 	"A3" : {
## 		"_id" : "A3",
## 		"_rev" : "1-bb4704a78f23aaa57cd8f4bc524f12e6",
## 		"name" : "A3",
## 		"versions" : {
## 			"0.9.1" : {
## 				"Package" : "A3",
## 				"Type" : "Package",
## 				"Title" : "A3: Accurate, Adaptable, and Accessible Error Metrics for\u000aPredictive Models",
## 				"Version" : "0.9.1",
## 				"Date" : "2013-02-06",
## 				"Author" : "Scott Fortmann-Roe",
## 				"Maintainer" : "Scott Fortmann-Roe <scottfr@berkeley.edu>",
## 				"Description" : "This package supplies tools for tabulating and analyzing\u000athe results of predictive models. The methods employed are\u000aapplicable to virtually any predictive model and make\u000acomparisons between different methodologies straightforward.",
## 				"License" : "GPL (>= 2)",
## 				"Depends" : {
## 					"xtable" : "*",
## 					"pbapply" : "*"
## 				},
## 
## ... not showing 459 lines ...
## 
## 					"3.0.0",
## 					"3.0.1",
## 					"3.0.2",
## 					"3.0.3",
## 					"3.1.0",
## 					"3.1.1"
## 				]
## 			}
## 		},
## 		"timeline" : {
## 			"0.1" : "2011-11-05T10:48:08+00:00",
## 			"0.2" : "2012-01-22T20:21:13+00:00",
## 			"0.3" : "2012-06-28T17:02:35+00:00",
## 			"0.4" : "2012-09-15T13:13:26+00:00"
## 		},
## 		"latest" : "0.4",
## 		"title" : "ABCDE_FBA: A-Biologist-Can-Do-Everything of Flux Balance\u000aAnalysis with this package.",
## 		"archived" : false
## 	}
## }
```

### `/-/latest` Latest versions of all packages

This is similar to `/-/all`, but only the latest versions of
the packages are returned, instead of the complete records with
all versions.


```r
DB("/-/latest?limit=3", head = 20)
```

```
## {
## 	"A3" : {
## 		"Package" : "A3",
## 		"Type" : "Package",
## 		"Title" : "A3: Accurate, Adaptable, and Accessible Error Metrics for\u000aPredictive Models",
## 		"Version" : "0.9.2",
## 		"Date" : "2013-03-24",
## 		"Author" : "Scott Fortmann-Roe",
## 		"Maintainer" : "Scott Fortmann-Roe <scottfr@berkeley.edu>",
## 		"Description" : "This package supplies tools for tabulating and analyzing\u000athe results of predictive models. The methods employed are\u000aapplicable to virtually any predictive model and make\u000acomparisons between different methodologies straightforward.",
## 		"License" : "GPL (>= 2)",
## 		"Depends" : {
## 			"R" : ">= 2.15.0",
## 			"xtable" : "*",
## 			"pbapply" : "*"
## 		},
## 		"Suggests" : {
## 			"randomForest" : "*",
## 			"e1071" : "*"
## 		},
## 
## ... not showing 58 lines ...
## 
## 		"Description" : "Functions for Constraint Based Simulation using Flux\u000aBalance Analysis and informative analysis of the data generated\u000aduring simulation.",
## 		"License" : "GPL-2",
## 		"Lazyload" : "yes",
## 		"Packaged" : "2012-09-15 11:23:36 UTC; Abhilash",
## 		"Repository" : "CRAN",
## 		"Date/Publication" : "2012-09-15 13:13:26",
## 		"crandb_file_date" : "2012-09-15 09:13:27",
## 		"date" : "2012-09-15T13:13:26+00:00",
## 		"releases" : [
## 			"2.15.2",
## 			"2.15.3",
## 			"3.0.0",
## 			"3.0.1",
## 			"3.0.2",
## 			"3.0.3",
## 			"3.1.0",
## 			"3.1.1"
## 		]
## 	}
## }
```

### `/-/desc` Short description of latest package versions

Latest versions of all packages, in alphabetical order. It also
contains the `title` fields of the packages. Only active (not archived)
packages are included.


```r
DB("/-/desc?limit=5")
```

```
## {
## 	"A3" : {
## 		"version" : "0.9.2",
## 		"title" : "A3: Accurate, Adaptable, and Accessible Error Metrics for\u000aPredictive Models"
## 	},
## 	"abc" : {
## 		"version" : "2.0",
## 		"title" : "Tools for Approximate Bayesian Computation (ABC)"
## 	},
## 	"abcdeFBA" : {
## 		"version" : "0.4",
## 		"title" : "ABCDE_FBA: A-Biologist-Can-Do-Everything of Flux Balance\u000aAnalysis with this package."
## 	},
## 	"ABCExtremes" : {
## 		"version" : "1.0",
## 		"title" : "ABC Extremes"
## 	},
## 	"ABCoptim" : {
## 		"version" : "0.13.11",
## 		"title" : "Implementation of Artificial Bee Colony (ABC) Optimization"
## 	}
## }
```

### `/-/allall` Complete records for all packages, including archived ones

This is similar to `/-/all`, but lists the archived packages as well.


```r
DB("/-/desc?limit=2", head = 20)
```

```
## {
## 	"A3" : {
## 		"version" : "0.9.2",
## 		"title" : "A3: Accurate, Adaptable, and Accessible Error Metrics for\u000aPredictive Models"
## 	},
## 	"abc" : {
## 		"version" : "2.0",
## 		"title" : "Tools for Approximate Bayesian Computation (ABC)"
## 	}
## }
```

### `/-/pkgreleases` Package releases

All versions of all packages, in the order of their release. Note that
this includes each version of each package separately, so it is a very
long list, and it is a good idea to use the `limit` parameter. `descending`
can be used to reverse the ordering, and start with the most recent
releases.


```r
DB("/-/pkgreleases?limit=3&descending=true", head = 20)
```

```
## [
## 	{
## 		"date" : "2014-09-13T18:12:26+00:00",
## 		"name" : "iBATCGH",
## 		"event" : "released",
## 		"package" : {
## 			"Package" : "iBATCGH",
## 			"Type" : "Package",
## 			"Title" : "Integrative Bayesian Analysis of Transcriptomic and CGH data",
## 			"Version" : "1.1",
## 			"Date" : "2014-09-02",
## 			"Author" : "Alberto Cassese",
## 			"Maintainer" : "Alberto Cassese <alberto.cassese@rice.edu>",
## 			"Description" : "Bayesian integrative models of gene expression and comparative genomic hybridization data. The package provides inference on copy number variations and their association with gene expression",
## 			"License" : "GPL-2",
## 			"Imports" : {
## 				"Rcpp" : ">= 0.11.2",
## 				"msm" : "*"
## 			},
## 			"LinkingTo" : {
## 
## ... not showing 85 lines ...
## 
## 			},
## 			"Suggests" : {
## 				"methods" : "*",
## 				"abind" : "*",
## 				"mvtnorm" : "*",
## 				"car" : "*",
## 				"RcmdrPlugin.HH" : "*"
## 			},
## 			"Description" : "Support software for Statistical Analysis and Data Display (First Edition, Springer, ISBN 0-387-40270-5, 2004) and (Second Edition, Springer, ISBN x-xxx-xxxxx-x, anticipated 2015) by Richard M. Heiberger and Burt Holland.  This contemporary presentation of statistical methods features extensive use of graphical displays for exploring data and for displaying the analysis.  The second edition includes redesigned graphics and additional chapters. The authors emphasize how to construct and interpret graphs, discuss principles of graphical design, and show how accompanying traditional tabular results are used to confirm the visual impressions derived directly from the graphs. Many of the graphical formats are novel and appear here for the first time in print.  All chapters have exercises.  All functions introduced in the book are in the package.  R code for all examples, both graphs and tables, in the book is included in the scripts directory of the package.",
## 			"License" : "GPL (>= 2)",
## 			"Packaged" : "2014-09-12 01:58:32 UTC; rmh",
## 			"NeedsCompilation" : "no",
## 			"Repository" : "CRAN",
## 			"Date/Publication" : "2014-09-13 08:34:04",
## 			"crandb_file_date" : "2014-09-13 02:36:50",
## 			"date" : "2014-09-13T08:34:04+00:00",
## 			"releases" : []
## 		}
## 	}
## ]
```

### `/-/archivals` Package archivals

Package archival events, sorted by date times. The latest version
of the package record is also included. Again, use the `limit` parameter
to query in chunks, and the `descending` parameter to reverse the order,
and see most recent archivals last.


```r
DB("/-/archivals?limit=3&descending=true", head = 20)
```

```
## [
## 	{
## 		"date" : "2014-09-13T07:25:27+00:00",
## 		"name" : "MASSI",
## 		"event" : "archived",
## 		"package" : {
## 			"Package" : "MASSI",
## 			"Type" : "Package",
## 			"Title" : "MicroArray Sample Sex Identifier",
## 			"Version" : "1.1",
## 			"Date" : "2013-06-11",
## 			"Author" : "Sam Buckberry",
## 			"Maintainer" : "Sam Buckberry <sam.buckberry@adelaide.edu.au>",
## 			"Description" : "Predicts sample sex information in gene expression microarray datasets",
## 			"License" : "GPL-3",
## 			"Collate" : "'massi.check.R' 'massi.cluster.R' 'massi.espresso.R'\u000a'massi.plot.R' 'massi.y.R'",
## 			"LazyData" : "true",
## 			"Depends" : {
## 				"fpc" : "*",
## 				"gplots" : "*"
## 
## ... not showing 56 lines ...
## 
## 			"Collate" : "main.R zzz.R",
## 			"Encoding" : "latin1",
## 			"Suggests" : {
## 				"RUnit" : "*",
## 				"rbenchmark" : "*"
## 			},
## 			"Packaged" : "2013-12-11 07:09:15 UTC; bernardo",
## 			"Repository" : "CRAN",
## 			"Date/Publication" : "2013-12-11 15:32:26",
## 			"crandb_file_date" : "2013-12-11 09:32:26",
## 			"NeedsCompilation" : "yes",
## 			"date" : "2013-12-11T15:32:26+00:00",
## 			"releases" : [
## 				"3.0.3",
## 				"3.1.0",
## 				"3.1.1"
## 			]
## 		}
## 	}
## ]
```

### `/-/events` Release and archival events

The union of `/-/pkgreleases` and `/-/archivals`, so it includes
all package releases and archivals.


```r
DB("/-/events?limit=3&descending=true", head = 20)
```

```
## [
## 	{
## 		"date" : "2014-09-13T18:12:26+00:00",
## 		"name" : "iBATCGH",
## 		"event" : "released",
## 		"package" : {
## 			"Package" : "iBATCGH",
## 			"Type" : "Package",
## 			"Title" : "Integrative Bayesian Analysis of Transcriptomic and CGH data",
## 			"Version" : "1.1",
## 			"Date" : "2014-09-02",
## 			"Author" : "Alberto Cassese",
## 			"Maintainer" : "Alberto Cassese <alberto.cassese@rice.edu>",
## 			"Description" : "Bayesian integrative models of gene expression and comparative genomic hybridization data. The package provides inference on copy number variations and their association with gene expression",
## 			"License" : "GPL-2",
## 			"Imports" : {
## 				"Rcpp" : ">= 0.11.2",
## 				"msm" : "*"
## 			},
## 			"LinkingTo" : {
## 
## ... not showing 85 lines ...
## 
## 			},
## 			"Suggests" : {
## 				"methods" : "*",
## 				"abind" : "*",
## 				"mvtnorm" : "*",
## 				"car" : "*",
## 				"RcmdrPlugin.HH" : "*"
## 			},
## 			"Description" : "Support software for Statistical Analysis and Data Display (First Edition, Springer, ISBN 0-387-40270-5, 2004) and (Second Edition, Springer, ISBN x-xxx-xxxxx-x, anticipated 2015) by Richard M. Heiberger and Burt Holland.  This contemporary presentation of statistical methods features extensive use of graphical displays for exploring data and for displaying the analysis.  The second edition includes redesigned graphics and additional chapters. The authors emphasize how to construct and interpret graphs, discuss principles of graphical design, and show how accompanying traditional tabular results are used to confirm the visual impressions derived directly from the graphs. Many of the graphical formats are novel and appear here for the first time in print.  All chapters have exercises.  All functions introduced in the book are in the package.  R code for all examples, both graphs and tables, in the book is included in the scripts directory of the package.",
## 			"License" : "GPL (>= 2)",
## 			"Packaged" : "2014-09-12 01:58:32 UTC; rmh",
## 			"NeedsCompilation" : "no",
## 			"Repository" : "CRAN",
## 			"Date/Publication" : "2014-09-13 08:34:04",
## 			"crandb_file_date" : "2014-09-13 02:36:50",
## 			"date" : "2014-09-13T08:34:04+00:00",
## 			"releases" : []
## 		}
## 	}
## ]
```

### `/-/releases` List of R versions

List of all R versions supported by the database. Currently this goes
back to version 2.0.0, older versions will be potentially added later.


```r
DB("/-/releases", head = 20)
```

```
## [
## 	{
## 		"version" : "2.0.0",
## 		"date" : "2004-10-04T00:00:00+00:00"
## 	},
## 	{
## 		"version" : "2.0.1",
## 		"date" : "2004-11-15T00:00:00+00:00"
## 	},
## 	{
## 		"version" : "2.1.0",
## 		"date" : "2005-04-18T00:00:00+00:00"
## 	},
## 	{
## 		"version" : "2.1.1",
## 		"date" : "2005-06-20T00:00:00+00:00"
## 	},
## 	{
## 		"version" : "2.2.0",
## 		"date" : "2005-10-06T00:00:00+00:00"
## 
## ... not showing 146 lines ...
## 
## 		"version" : "3.0.1",
## 		"date" : "2013-05-16T00:00:00+00:00"
## 	},
## 	{
## 		"version" : "3.0.2",
## 		"date" : "2013-09-25T00:00:00+00:00"
## 	},
## 	{
## 		"version" : "3.0.3",
## 		"date" : "2014-03-06T00:00:00+00:00"
## 	},
## 	{
## 		"version" : "3.1.0",
## 		"date" : "2014-04-10T00:00:00+00:00"
## 	},
## 	{
## 		"version" : "3.1.1",
## 		"date" : "2014-07-10T00:00:00+00:00"
## 	}
## ]
```

### `/-/releasepkgs/:version` Packages that were current at an R release

All package records that were current when a given version of R
was released. This is essentially a snapshot of CRAN, for a given R
release.


```r
DB("/-/releasepkgs/2.15.3", head = 20)
```

```
## {
## 	"A3" : {
## 		"Package" : "A3",
## 		"Type" : "Package",
## 		"Title" : "A3: Accurate, Adaptable, and Accessible Error Metrics for\u000aPredictive Models",
## 		"Version" : "0.9.1",
## 		"Date" : "2013-02-06",
## 		"Author" : "Scott Fortmann-Roe",
## 		"Maintainer" : "Scott Fortmann-Roe <scottfr@berkeley.edu>",
## 		"Description" : "This package supplies tools for tabulating and analyzing\u000athe results of predictive models. The methods employed are\u000aapplicable to virtually any predictive model and make\u000acomparisons between different methodologies straightforward.",
## 		"License" : "GPL (>= 2)",
## 		"Depends" : {
## 			"xtable" : "*",
## 			"pbapply" : "*"
## 		},
## 		"Suggests" : {
## 			"randomForest" : "*",
## 			"e1071" : "*"
## 		},
## 		"Packaged" : "2013-02-06 16:46:12 UTC; scott",
## 
## ... not showing 166559 lines ...
## 
## 		"Depends" : {
## 			"R" : ">= 2.4.0",
## 			"Kendall" : "*"
## 		},
## 		"Suggests" : {},
## 		"Description" : "The zyp package contains an efficient implementation of\u000aSen's slope method plus implementation of Xuebin Zhang's\u000a(Zhang, 1999) and Yue-Pilon's (Yue, 2002) prewhitening\u000aapproaches to determining trends in climate data.",
## 		"License" : "LGPL-2.1",
## 		"URL" : "http://www.r-project.org",
## 		"Packaged" : "2012-10-29 09:00:03 UTC; ripley",
## 		"Repository" : "CRAN",
## 		"Date/Publication" : "2012-10-29 09:00:03",
## 		"crandb_file_date" : "2012-10-29 04:00:03",
## 		"date" : "2012-10-29T09:00:03+00:00",
## 		"releases" : [
## 			"2.15.3",
## 			"3.0.0",
## 			"3.0.1"
## 		]
## 	}
## }
```

### `/-/release/:version` Package versions that were current at an R release

Similar to the previous list, but it only includes the version numbers,
and not the records of the packages.


```r
DB("/-/release/2.15.3", head = 20)
```

```
## {
## 	"A3" : "0.9.1",
## 	"aaMI" : "1.0-1",
## 	"abc" : "1.6",
## 	"abcdeFBA" : "0.4",
## 	"abctools" : "0.1-2",
## 	"abd" : "0.2-4",
## 	"abind" : "1.4-0",
## 	"aBioMarVsuit" : "1.0",
## 	"abn" : "0.82",
## 	"AcceptanceSampling" : "1.0-2",
## 	"ACCLMA" : "1.0",
## 	"accuracy" : "1.35",
## 	"ACD" : "1.0-0",
## 	"Ace" : "0.0.8",
## 	"acepack" : "1.3-3.2",
## 	"acer" : "0.1.2",
## 	"aCGH.Spline" : "2.2",
## 	"ACNE" : "0.5.0",
## 	"acs" : "0.8",
## 
## ... not showing 4903 lines ...
## 
## 	"YjdnJlp" : "0.9.8",
## 	"YourCast" : "1.5-1",
## 	"YuGene" : "1.0",
## 	"ZeBook" : "0.3",
## 	"Zelig" : "4.1-3",
## 	"ZeligChoice" : "0.7-0",
## 	"ZeligGAM" : "0.7-0",
## 	"ZeligMultilevel" : "0.7-0",
## 	"zendeskR" : "0.3",
## 	"zic" : "0.7.5",
## 	"zicounts" : "1.1.5",
## 	"ZIGP" : "3.8",
## 	"zipcode" : "1.0",
## 	"zipfR" : "0.6-6",
## 	"zmatrix" : "1.1",
## 	"zoeppritz" : "1.0-3",
## 	"zoo" : "1.7-9",
## 	"zooimage" : "3.0-3",
## 	"zyp" : "0.9-1"
## }
```

### `/-/releasedesc/:version` Short description of CRAN snapshots

Similar to `/-/release`, but it also include the the `title` fields of
the packages.


```r
DB("/-/releasedesc/2.15.3", head = 20)
```

```
## {
## 	"A3" : {
## 		"version" : "0.9.1",
## 		"title" : "A3: Accurate, Adaptable, and Accessible Error Metrics for\u000aPredictive Models"
## 	},
## 	"aaMI" : {
## 		"version" : "1.0-1",
## 		"title" : "Mutual information for protein sequence alignments"
## 	},
## 	"abc" : {
## 		"version" : "1.6",
## 		"title" : "Tools for Approximate Bayesian Computation (ABC)"
## 	},
## 	"abcdeFBA" : {
## 		"version" : "0.4",
## 		"title" : "ABCDE_FBA: A-Biologist-Can-Do-Everything of Flux Balance\u000aAnalysis with this package."
## 	},
## 	"abctools" : {
## 		"version" : "0.1-2",
## 		"title" : "Algorithms for ABC summary statistics selection"
## 
## ... not showing 19706 lines ...
## 
## 		"version" : "1.1",
## 		"title" : "Zero-offset matrices"
## 	},
## 	"zoeppritz" : {
## 		"version" : "1.0-3",
## 		"title" : "Zoeppritz Equations"
## 	},
## 	"zoo" : {
## 		"version" : "1.7-9",
## 		"title" : "S3 Infrastructure for Regular and Irregular Time Series (Z's\u000aordered observations)"
## 	},
## 	"zooimage" : {
## 		"version" : "3.0-3",
## 		"title" : "Analysis of numerical zooplankton images"
## 	},
## 	"zyp" : {
## 		"version" : "0.9-1",
## 		"title" : "Zhang + Yue-Pilon trends package"
## 	}
## }
```

### `/-/topdeps/:version` Packages most depended upon

Top twenty packages. It includes all forms of dependencies, and it can be
restricted to dependencies that were in place at a given R release. 


```r
DB("/-/topdeps/3.1.1")
```

```
## [
## 	{
## 		"MASS" : 788
## 	},
## 	{
## 		"lattice" : 405
## 	},
## 	{
## 		"ggplot2" : 303
## 	},
## 	{
## 		"Matrix" : 284
## 	},
## 	{
## 		"mvtnorm" : 272
## 	},
## 	{
## 		"testthat" : 265
## 	},
## 	{
## 		"survival" : 257
## 	},
## 	{
## 		"plyr" : 231
## 	},
## 	{
## 		"Rcpp" : 228
## 	},
## 	{
## 		"knitr" : 161
## 	},
## 	{
## 		"XML" : 159
## 	},
## 	{
## 		"rgl" : 152
## 	},
## 	{
## 		"nlme" : 148
## 	},
## 	{
## 		"sp" : 147
## 	},
## 	{
## 		"igraph" : 142
## 	},
## 	{
## 		"coda" : 135
## 	},
## 	{
## 		"boot" : 132
## 	},
## 	{
## 		"RCurl" : 124
## 	},
## 	{
## 		"RUnit" : 118
## 	},
## 	{
## 		"RColorBrewer" : 114
## 	}
## ]
```

For the latest versions of the packages and their dependencies, you can set
`:version` to `dev`:


```r
DB("/-/topdeps/devel")
```

```
## [
## 	{
## 		"MASS" : 836
## 	},
## 	{
## 		"lattice" : 422
## 	},
## 	{
## 		"ggplot2" : 336
## 	},
## 	{
## 		"testthat" : 317
## 	},
## 	{
## 		"Matrix" : 309
## 	},
## 	{
## 		"mvtnorm" : 291
## 	},
## 	{
## 		"Rcpp" : 274
## 	},
## 	{
## 		"survival" : 273
## 	},
## 	{
## 		"plyr" : 257
## 	},
## 	{
## 		"knitr" : 214
## 	},
## 	{
## 		"XML" : 173
## 	},
## 	{
## 		"sp" : 168
## 	},
## 	{
## 		"rgl" : 164
## 	},
## 	{
## 		"nlme" : 157
## 	},
## 	{
## 		"igraph" : 151
## 	},
## 	{
## 		"RCurl" : 144
## 	},
## 	{
## 		"coda" : 143
## 	},
## 	{
## 		"boot" : 142
## 	},
## 	{
## 		"reshape2" : 133
## 	},
## 	{
## 		"stringr" : 126
## 	}
## ]
```

### `/-/deps/:version` Number of reverse dependencies

For all packages, not just the top twenty.


```r
DB("/-/deps/2.15.1", head = 20)
```

```
## {
## 	"abind" : 36,
## 	"accuracy" : 4,
## 	"acepack" : 2,
## 	"aCGH" : 2,
## 	"actuar" : 9,
## 	"ada" : 3,
## 	"adabag" : 1,
## 	"adapt" : 2,
## 	"ade4" : 25,
## 	"ade4TkGUI" : 1,
## 	"adegenet" : 4,
## 	"adehabitat" : 4,
## 	"adehabitatHR" : 1,
## 	"adehabitatLT" : 2,
## 	"adehabitatMA" : 3,
## 	"adephylo" : 1,
## 	"ADGofTest" : 3,
## 	"adimpro" : 3,
## 	"adlift" : 1,
## 
## ... not showing 1457 lines ...
## 
## 	"xlsxjars" : 1,
## 	"XML" : 96,
## 	"XMLRPC" : 1,
## 	"XMLSchema" : 3,
## 	"xpose4" : 1,
## 	"xpose4classic" : 1,
## 	"xpose4data" : 4,
## 	"xpose4generic" : 3,
## 	"xpose4specific" : 2,
## 	"xtable" : 72,
## 	"xtermStyle" : 1,
## 	"xts" : 25,
## 	"yacca" : 1,
## 	"yaImpute" : 1,
## 	"YaleToolkit" : 2,
## 	"yaml" : 1,
## 	"Zelig" : 5,
## 	"zipfR" : 2,
## 	"zoo" : 75
## }
```
