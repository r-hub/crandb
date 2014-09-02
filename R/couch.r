
set <- .Primitive("[[<-")

## TODO: add archival reason

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
    add_releases_to_versions() %>%
    toJSON(pretty = pretty)
}

get_versions <- function(dcf) {
  res <- apply(dcf, 1, pkg_version_to_json)
  res %>%
    set_names(sapply(res, "[[", "Version"))
}

add_releases_to_versions <- function(frec) {
  ## For each R release, find the versions on CRAN at the time
  act_ver <- r_releases$date %>%
    as.character() %>%
    sapply(pkg_ver_at_time, frec = frec) %>%
    set_names(r_releases$version)

  ## Remove the releases after the archival of the package
  if (frec$archived) {
    act_ver <- act_ver[r_releases$date <= frec$timeline[["archived"]]]
  }

  frec$versions <- frec$versions %>%
    lapply(set, "releases", character())

  for (i in seq_along(act_ver)) {
    if (!is.na(act_ver[i])) {
      frec$versions[[ act_ver[i] ]]$releases <-
        c(names(act_ver)[i], frec$versions[[ act_ver[i] ]]$releases)
    }
  }

  frec
}

pkg_ver_at_time <- function(frec, date) {

  ver <- frec$versions %>%
    sapply(extract2, "date") %>%
    is_weakly_less_than(date) %>%
    which() %>%
    names() %>%
    tail(1)

  ver %||% NA_character_
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
    add_date() %>%
    lapply(unbox) %>%
    fix_deps()
}

set_encoding <- function(str) {
  Encoding(str) <- "UTF-8"
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

create_empty_db <- function() {
  check_couchapp()

  couch_exists() %||% couch_create_db() %||%
    stop("Cannot create DB", call. = TRUE)

  paste("couchapp push",
        system.file("app.js", package = packageName()),
        couchdb_server(root = TRUE)) %>%
    system(ignore.stdout = TRUE, ignore.stderr = TRUE)
}

couch_add <- function(id, json) {
  couchdb_server(root = TRUE) %>%
    paste(sep = "/", id) %>%
    httr::PUT(body = json, httr::content_type_json()) %>%
    httr::stop_for_status()
}

couch_exists <- function() {
  couchdb_server() %>%
    httr::url_ok()
}

couch_create_db <- function() {
  couchdb_server(root = TRUE) %>%
    httr::PUT() %>%
    httr::stop_for_status()

  TRUE
}

add_r_releases <- function() {
  apply(r_releases, 1, add_release)
}

#' @importFrom parsedate parse_date format_iso_8601

add_release <- function(rec) {
  list("_id" = rec[[1]] %>% unbox(),
       "date" = rec[[2]] %>% parse_date() %>% format_iso_8601() %>% unbox(),
       "type" = "release" %>% unbox()) %>%
    toJSON() %>%
    couch_add(id = rec[[1]])
}

update_design <- function() {

  ## Check if we have command line curl
  check_curl()

  ## Copy design document
  ("curl -X COPY " %+% couchdb_server(root = TRUE) %+%
     '/_design/app -H "Destination: _design/app-old"') %>%
    system(ignore.stdout = TRUE, ignore.stderr = TRUE)

  ## Update design document, under a new name
  tmp <- tempfile()
  on.exit(try(unlink(tmp, recursive = TRUE)))
  dir.create(tmp)
  tmpfile <- file.path(tmp, "app-new.js")
  system.file("app.js", package = packageName()) %>%
    readLines() %>%
    sub(pattern = "'_design/app'", replacement = "'_design/app-new'",
        fixed = TRUE) %>%
    writeLines(tmpfile)

  ("couchapp push " %+% tmpfile %+% " " %+% couchdb_server(root = TRUE)) %>%
    system() %>%
    stop("Cannot create new design document")

  ## Query DB to trigger indexing
  couchdb_server(root = TRUE) %>%
    paste0("/_design/app/_view/active?limit=5") %>%
    httr::GET()

  ## Update design document to its proper place
  ("couchapp push " %+% system.file("app.js", package = packageName()) %+%
     " " %+% couchdb_server(root = TRUE)) %>%
    system() %>%
    stop("Cannot create new design document")
}
