
context("CouchDB")

## Create a temporary DB, and use that
## We need to do everything within test_that(), otherwise an error would
## cause a premature stop  and the teardown at the end is not run.

oldserver <- NA

test_that("Oh, nothing, just setting up", {

  oldserver <<- couchdb_server()
  couchdb_server("http://127.0.0.1:5984/cran")
  httr::DELETE(couchdb_server())

})

test_that("Create DB, test if exists", {
  
  expect_false(couch_exists())
  create_empty_db()
  expect_true(couch_exists())
  
})

test_that("Add a couple of packages to DB", {
  
  need_pkgs(c("assertthat", "testthat", "igraph0"))
  build_db()
  
})

test_that("API: /:pkg", {

  couchdb_server("http://localhost:5984/")

  `%>%` <- magrittr::`%>%`
    
  expect_true(httr::url_ok(couchdb_server()))
  expect_true(httr::url_ok(paste0(couchdb_server(), "igraph0")))
  expect_true(httr::url_ok(paste0(couchdb_server(), "assertthat")))
  expect_true(httr::url_ok(paste0(couchdb_server(), "testthat")))

})

## /:pkg/:version

test_that("API: /-/all", {

  `%>%` <- magrittr::`%>%`

  js <- couchdb_server() %>%
    paste0("-/all") %>%
    httr::GET() %>%
    httr::content(as = "text") %>%
    jsonlite::fromJSON(simplifyVector = FALSE)
  
  expect_equal(length(js), 2)
  expect_equal(names(js), c("assertthat", "testthat"))

})

test_that("API: /-/desc", {

  `%>%` <- magrittr::`%>%`

  ## /-/desc
  js <- couchdb_server() %>%
    paste0("-/desc") %>%
    httr::GET() %>%
    httr::content(as = "text") %>%        
    jsonlite::fromJSON(simplifyVector = FALSE)

  expect_equal(length(js), 2)
  expect_equal(names(js), c("assertthat", "testthat"))
  expect_equal(names(js$assertthat), c("version", "title"))

})

## /-/latest

## /-/allall

## /-/pkgreleases

## /-/archivals

## /-/events

## /-/releases

## /-/releasepkgs/:version

## /-/release/:version

## /-/releasedesc/-/version

## /-/topdeps/:version

## /-/deps/:version

test_that("Teardown", {
  httr::DELETE(couchdb_server())
  couchdb_server(oldserver)
})
