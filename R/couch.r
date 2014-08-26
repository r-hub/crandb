
set <- .Primitive("[[<-")

## TODO: add archival date, reason

#' @importFrom jsonlite toJSON unbox

pkg_to_json <- function(dcf, archived, archived_at = NA,
                        pretty = FALSE) {

  pkg <- dcf[, "Package"] %>%
    unique() %>%
    tail(1)

  if (length(pkg) < 1) { stop("No packages in DCF", call. = FALSE) }

  list() %>%
    set("_id", unbox(pkg)) %>%
    set("name", unbox(pkg)) %>%
    set("versions", get_versions(dcf)) %>%
    add_timeline(archived, archived_at) %>%
    add_latest_version() %>%
    add_title() %>%
    set("archived", unbox(archived)) %>%
    toJSON(pretty = pretty)
}

get_versions <- function(dcf) {
  res <- apply(dcf, 1, pkg_version_to_json)
  res %>%
    set_names(sapply(res, "[[", "Version"))
}

add_releases <- function(pkg) {
  ## TODO
  pkg
}

add_title <- function(pkg) {
  pkg$title <- pkg$versions[[pkg$latest]]$Title
  pkg
}

add_latest_version <- function(pkg) {
  pkg[["latest"]] <- pkg$timeline %>%
    names() %>%
    grep(pattern = "archived", invert = TRUE, fixed = TRUE, value = TRUE) %>%
    tail(1) %>%
    unbox()
  pkg
}

add_timeline <- function(frec, archived, archived_at) {
  frec[["timeline"]] <- lapply(frec$versions, "[[", "date")

  if (archived) {
    frec[["timeline"]][["archived"]] <- archived_at %>%
      format_iso_8601() %>%
      unbox
  }
  
  frec
}

## -----------------------------------------------------------------

#' @importFrom jsonlite unbox

pkg_version_to_json <- function(rec) {
  rec %>%
    set_encoding() %>%
    na.omit() %>%
    as.list() %>%
    add_releases() %>%
    add_date() %>%
    lapply(unbox) %>%
    fix_deps()
}

set_encoding <- function(str) {
  if (! is.na(str["Encoding"])) {
    Encoding(str) <- str['Encoding']
  } else {
    Encoding(str) <- "latin1"
  }
  str
}

parse_dep_field <- function(str) {
  sstr <- strsplit(str, ",")[[1]]
  pkgs <- sub("[ ]?[(].*[)].*$", "", sstr)
  vers <- gsub("^[^(]*[(]?|[)].*$", "", sstr)
  vers[vers==""] <- "*"
  vers <- lapply(as.list(vers), unbox)
  names(vers) <- trim(pkgs)
  vers
}

fix_deps <- function(rec) {
  for (f in intersect(names(rec), cran_dep_fields)) {
    rec[[f]] <- parse_dep_field(rec[[f]])
  }
  rec
}

try_date <- function(date) {

  date %||% return(NULL)

  norm_date <- date %>%
    sub(pattern = ";.*$", replacement = "") %>%
    normalize_date()

  if (is.na(norm_date)) NULL else norm_date
}

## TODO: what if all these fail? There are some
## very old packages like that

add_date <- function(rec) {
  rec$date <-
    try_date(rec[["Date/Publication"]]) %||%
    try_date(rec[["Packaged"]]) %||%
    try_date(rec[["Date"]]) %||%
    try_date(rec[["crandb_file_date"]])

  rec
}

#' @importFrom parsedate parse_date format_iso_8601

normalize_date <- function(date) {
  date %>%
    parse_date() %>%
    format_iso_8601()
}

#' Create an empty Couchdb database with CRAN-DB structure
#'
#' @export

create_empty_db <- function() {
  check_couchapp()

  couch_exists() %||% couch_create_db() %||%
    stop("Cannot create DB", call. = TRUE)

  paste("couchapp push",
        system.file("app.js", package = packageName()),
        couchdb_server()) %>%
    system(ignore.stdout = TRUE, ignore.stderr = TRUE)
}

couch_add <- function(id, json) {
  couchdb_server() %>%
    paste(sep = "/", id) %>%
    httr::PUT(body = json, httr::content_type_json()) %>%
    httr::stop_for_status()
}

couch_exists <- function() {
  couchdb_server() %>%
    httr::url_ok()
}

couch_create_db <- function() {
  couchdb_server() %>%
    httr::PUT() %>%
    httr::stop_for_status()

  TRUE
}
