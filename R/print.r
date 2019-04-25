
## ----------------------------------------------------------------------

#' @method summary cran_package
#' @export
#'

summary.cran_package <- function(object, ...) {
  if ("versions" %in% names(object)) {
    summary_cran_package_all(object, ...)
  } else {
    summary_cran_package_single(object, ...)
  }
  invisible(object)
}

#' @importFrom parsedate parse_date
#' @importFrom prettyunits time_ago

summary_cran_package_single <- function(object, ...) {
  cat('CRAN package ' %+% object$Package %+% " " %+% object$Version %+%
        ', ' %+% time_ago(parse_date(object$date)) %+% "\n")
}

#' @importFrom parsedate parse_date

summary_cran_package_all <- function(object, ...) {
  latest_date <- object$versions[[object$latest]]$date
  cat('CRAN package ' %+% object$name %+% ", latest: " %+% object$latest %+%
        ", " %+% time_ago(parse_date(latest_date)))
  if (object$archived) {
    cat(", archived " %+% time_ago(parse_date(object$timeline[["archived"]])))
  }
  cat("\n")
}

## ----------------------------------------------------------------------

#' @method print cran_package
#' @export

print.cran_package <- function(x, ...) {
  if ("versions" %in% names(x)) {
    print_cran_package_all(x, ...)
  } else {
    print_cran_package_single(x, ...)
  }
  invisible(x)
}

print_cran_package_single <- function(x, ...) {
  summary_cran_package_single(x)
  print_cran_package_body(x)
}

print_cran_package_body <- function(x, indent = 0) {
  x <- collapse_dep_fields(x)
  x[["releases"]] <- paste(x[["releases"]], collapse = ", ")

  print_field("Title", x$Title, indent = indent)
  print_field("Maintainer", x$Maintainer, indent = indent)

  names(x) %>%
    setdiff(c("Title", "Maintainer", "Package", "Authors@R", "Version",
              "date", "crandb_file_date")) %>%
    sort() %>%
    sapply(function(xx) print_field(xx, x[[xx]], indent = indent))
}

print_cran_package_all <- function(x, ...) {
  summary_cran_package_all(x)
  print_cran_package_all_1(x$latest, x$versions[[x$latest]])

  names(x$timeline) %>%
    setdiff(c("archived", x$latest)) %>%
    rev() %>%
##    sapply(function(xx) print_cran_package_all_1(xx, x$versions[[xx]]))
    paste(collapse = ", ") %>%
    paste("Other versions:", .) %>%
    strwrap(exdent = 2) %>%
    cat(sep = "\n")
}

print_cran_package_all_1 <- function(name, version) {
  cat("['" %+% name %+% "']:\n")
  print_cran_package_body(version, indent = 2)
}

collapse_dep_fields <- function(pkg) {
  for (f in intersect(names(pkg), cran_dep_fields)) {
    pkg[[f]] <- names(pkg[[f]]) %>%
      paste0(" (", pkg[[f]], ")") %>%
      paste(collapse = ", ")
  }
  pkg
}

print_field <- function(key, value, indent = 0) {
  (key %+% ": " %+% value) %>%
    gsub(pattern = "\n", replacement = " ") %>%
    strwrap(indent = indent, exdent = indent + 4) %>%
    cat(sep = "\n")
}

## ----------------------------------------------------------------------

#' @method summary cran_package_list
#' @export

summary.cran_package_list <- function(object, ...) {
  cat("CRAN PACKAGES:\n")
  print(names(object))
  invisible(object)
}

## ----------------------------------------------------------------------

#' @method print cran_package_list
#' @export
#'

print.cran_package_list <- function(x, ...) {
  if ("version" %in% names(x[[1]])) {
    print_cran_list_short(x, ...)
  } else if ("timeline" %in% names(x[[1]])) {
    print_cran_list_full(x, ...)
  } else {
    print_cran_list_latest(x, ...)
  }
  invisible(x)
}

print_cran_list_short <- function(x, ...) {
  print_cran_list_i(x, "CRAN packages (short)", "version", "title", ...)
}

print_cran_list_latest <- function(x, ...) {
  print_cran_list_i(x, "CRAN packages (latest versions)", "Version",
                    "Title", ...)
}

print_cran_list_full <- function(x, ...) {
  print_cran_list_i(x, "CRAN packages (full)", "latest", "title", ...)
}

print_cran_list_i <- function(x, header, version, title, ...) {
  cat_fill(header)
  pkgs <- data.frame(
    stringsAsFactors = FALSE,
    Package = names(x),
    Version = sapply(x, function(xx) xx[[version]] %>% NULL_NA),
    RTitle = sapply(x, function(xx) xx[[title]] %>% NULL_NA) %>%
      gsub(pattern = "\\s+", replacement = " ")
  )

  tw <- getOption("width") - 7 -
    max(nchar("Package"), max(nchar(pkgs$Package))) -
    max(nchar("Version"), max(nchar(pkgs$Version)))
  pkgs$Title <- substring(pkgs$RTitle, 1, tw)
  pkgs$Title <- ifelse(pkgs$Title == pkgs$RTitle, pkgs$Title,
                       paste0(pkgs$Title, "..."))
  pkgs$RTitle <- NULL

  print.data.frame(pkgs, row.names = FALSE, right = FALSE)
}

## ----------------------------------------------------------------------
#' @method summary cran_event_list
#' @export

summary.cran_event_list <- function(object, ...) {
  cat("CRAN events (" %+% attr(object, "mode") %+% ")\n")
  paste0(
    sapply(object, "[[", "name"),
    "@",
    sapply(object, function(xx) xx$package$Version),
    ifelse(sapply(object, "[[", "event") == "released", "", "-")
  ) %>% print()
  invisible(object)
}

## ----------------------------------------------------------------------
#' @method print cran_event_list
#' @export
#' @importFrom prettyunits time_ago

print.cran_event_list <- function(x, ...) {
  cat_fill("CRAN events (" %+% attr(x, "mode") %+% ")")
  pkgs <- data.frame(
    stringsAsFactors = FALSE, check.names = FALSE,
    "." = ifelse(sapply(x, "[[", "event") == "released", "+", "-"),
    When = sapply(x, "[[", "date") %>% parse_date() %>% time_ago(format = "short"),
    Package = sapply(x, "[[", "name"),
    Version = sapply(x, function(xx) xx$package$Version),
    RTitle = sapply(x, function(xx) xx$package$Title) %>%
      gsub(pattern = "\\s+", replacement = " ")
  )

  tw <- getOption("width") - 7 - 3 -
    max(nchar("When"), max(nchar(pkgs$When))) -
    max(nchar("Package"), max(nchar(pkgs$Package))) -
    max(nchar("Version"), max(nchar(pkgs$Version)))
  pkgs$Title <- substring(pkgs$RTitle, 1, tw)
  pkgs$Title <- ifelse(pkgs$Title == pkgs$RTitle, pkgs$Title,
                       paste0(pkgs$Title, "..."))
  pkgs$RTitle <- NULL

  print.data.frame(pkgs, row.names = FALSE, right = FALSE)

  invisible(x)
}

## ----------------------------------------------------------------------

#' @method summary r_releases
#' @export

summary.r_releases <- function(object, ...) {
  cat("R releases " %+% object[1,]$version %+% " ... " %+%
        object[nrow(object),]$version %+% "\n")
  invisible(object)
}

## ----------------------------------------------------------------------

#' @method print r_releases
#' @export

print.r_releases <- function(x, ...) {
  cat_fill("R releases")
  rels <- data.frame(
    stringsAsFactors = FALSE,
    Version = x$version,
    Date = x$date %>% parse_date() %>% simple_date()
  )
  print.data.frame(rels, right = FALSE, row.names = FALSE)
  invisible(x)
}

## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## Utilities

#' @importFrom assertthat assert_that is.string

cat_fill <- function(text) {
  assert_that(is.string(text))
  width <- getOption("width") - nchar(text) - 1
  cat(text, paste(rep("-", width, collapse = "")), sep = "", "\n")
}

simple_date <- function(date) {
  date %>%
    gsub(pattern = "T", replacement = " ", fixed = TRUE) %>%
    gsub(pattern = "+00:00", replacement = "", fixed = TRUE)
}
