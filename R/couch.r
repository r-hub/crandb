
set <- .Primitive("[[<-")

#' @importFrom R4CouchDB cdbIni
#' @importFrom jsonlite toJSON unbox

pkg_to_json <- function(dcf, archived, pretty = FALSE) {
  pkg <- unique(dcf[, "Package"])
  if (length(pkg) != 1) { stop("Multiple packages in DCF", call. = FALSE) }

  list() %>%
    set("_id", unbox(pkg)) %>%
    set("name", unbox(pkg)) %>%
    set("versions", apply(dcf, 1, pkg_version_to_json)) %>%
    add_latest_version() %>%
    add_timeline() %>%
    add_title() %>% ## TODO frec$versions[[frec[["latest"]]]]$Title
    add_archived () %>%
    toJSON(pretty = pretty)
}

add_releases <- function(pkg) {
  ## TODO
  pkg
}

add_title <- function(pkg) {
  ## TODO
  pkg
}

add_latest_version <- function(pkg) {
  pkg$latest <- "TODO"
  pkg
}

add_timeline <- function(frec) {
  ## TODO
  frec
}

add_archived <- function(frec) {
  ## TODO
  frec
}

## -----------------------------------------------------------------

#' @importFrom jsonlite unbox

pkg_version_to_json <- function(rec) {
  rec %>%
    set_encoding() %>%
    na.omit() %>%
    as.list() %>%
    lapply(unbox) %>%
    fix_deps() %>%
    add_releases() %>%
    add_date()
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

add_date <- function(rec) {
  ## TODO
  rec
}

couch_add <- function(json) {

}
