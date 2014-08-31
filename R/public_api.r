
## ----------------------------------------------------------------------
## :pkg, :pkg/:version, :pkg/all

#' Metadata about a CRAN package
#'
#' @param name Name of the package.
#' @param version The package version to query. If missing, the latest
#'   version if returned. If it is \sQuote{\code{all}}, then all versions
#'   are returned. Otherwise it should be a version number.
#' @return The package metadata.
#'
#' @export
#' @importFrom assertthat assert_that

package <- function(name, version) {

  assert_that(is_package_name(name))
  missing(version) %||% assert_that(is_package_version(version))

  url <- paste0(couchdb_server(), "/", name)
  if (! missing(version)) {
    url <- paste0(url, "/", version)
  }
  query(url) %>%
    remove_special() %>%
    add_class("cran_package")
}

## ----------------------------------------------------------------------
## /-/all, /-/latest, /-/desc, /-/allall

#' List active packages
#'
#' @param from The name of the first package to list. By default it
#'    is the first one in alphabetical order.
#' @param limit The number of packages to list.
#' @param format What to return. \sQuote{\code{short}} means the
#'    title and version number only. \sQuote{\code{latest}} means
#'    the complete description of the latest version. \sQuote{\code{full}}
#'    means all versions.
#' @param archived Whether to include archived packages in the result.
#'    If this is \code{TRUE}, then \code{format} must be
#'    \sQuote{\code{full}}.
#' @return List of packages.
#'
#' @export
#' @importFrom assertthat assert_that is.count is.flag

list_packages <- function(from = "", limit = 10,
                          format = c("short", "latest", "full"),
                          archived = FALSE) {

  assert_that(is_package_name(from))
  assert_that(is.count(limit))
  format <- match.arg(format)
  assert_that(is.flag(archived))

  if (archived && format != "full") {
    warning("Using 'full' format because 'archive' is TRUE")
  }

  url <- switch(format,
                "short" = "/-/desc",
                "latest" = "/-/latest",
                "full" = "/-/all")
  if (archived) url <- "/-/allall"

  couchdb_server() %>%
    paste0(url) %>%
    paste0('?start_key="', from, '"') %>%
    paste0("&limit=", limit) %>%
    query() %>%
    remove_special(level = 2) %>%
    add_class("cran_package_list")
}

## ----------------------------------------------------------------------
## /-/pkgreleases, /-/archivals, /-/events

#' List of all CRAN events (new, updated, archived packages)
#'
#' @param limit Number of events to list.
#' @param releases Whether to include package releases.
#' @param archivals Whether to include package archivals.
#' @return List of events.
#'
#' @export
#' @importFrom assertthat assert_that is.count is.flag

events <- function(limit = 10, releases = TRUE, archivals = TRUE) {

  assert_that(is.count(limit))
  assert_that(is.flag(releases))
  assert_that(is.flag(archivals))
  assert_that(releases || archivals)

  url <- if (releases && archivals) {
    "/-/events"
  } else if (releases) {
    "/-/pkgreleases"
  } else {
    "/-/archivals"
  }

  couchdb_server() %>%
    paste0(url) %>%
    paste0("?limit=", limit) %>%
    paste0("&descdending=true") %>%
    query(simplifyDataFrame = FALSE) %>%
    add_class("cran_event_list")
}

## ----------------------------------------------------------------------
## /-/releases

#' List R releases in the CRANDB database
#'
#' @return List of R releases.
#'
#' @export

releases <- function() {

  couchdb_server() %>%
    paste0("/-/releases") %>%
    query() %>%
    add_class("r_releases")
}

## ----------------------------------------------------------------------
## /-/release, /-/releasepkgs, /-/releasedesc

#' Package versions snapshotted for R releases
#'
#' @param version R version number.
#' @param format What to return. \sQuote{\code{version}} means only the
#'   version numbers that were current at the given R
#'   release. \sQuote{\code{short}} also includes the title of the packages
#'
#' @return List of packages.
#'
#' @export
#' @importFrom assertthat assert_that

cran_releases <- function(version, format = c("version", "short",
                                     "full")) {

  assert_that(is_package_version(version))
  format <- match.arg(format)

  url <- switch(format,
         "version" = "/-/release",
         "short" = "/-/releasedesc",
         "full" = "/-/releasepkgs")

  couchdb_server() %>%
    paste0(url) %>%
    paste0("/", version) %>%
    query() %>%
    add_class("cran_releases")
}
