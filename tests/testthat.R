library(testthat)
library(crandb)

if (Sys.getenv("NOT_CRAN") != "") {
  test_check("crandb")
}
