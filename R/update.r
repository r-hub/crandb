
#' @importFrom falsy "%||%"

cran_site <- function() {

  cran <- getOption("repos") %>%
    extract("CRAN") %>%
    NA_NULL()

  cran %||% "http://cran.r-project.org"
}

read_remote_rds <- function(URL) {
  con <- gzcon(url(URL))
  on.exit(close(con))
  readRDS(con)
}

crandb_update <- function() {
  cran <- cran_site()

  current <- current_rds_path_comps %>%
    paste(collapse = "/") %>%
    paste(cran_site(), ., sep="/") %>%
    read_remote_rds()

  archive <- archive_rds_path_comps %>%
    paste(collapse = "/") %>%
    paste(cran_site(), ., sep="/") %>%
    read_remote_rds()

  current_db <- couchdb_server() %>%
    paste0("/-/desc") %>%
    httr::GET() %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = FALSE) %>%
    sapply("[[", "version")

  cran_versions <- current %>%
    rownames() %>%
    ver_from_tarname()

  ## Add new packages, might be re-added, though, so
  ## we might have it in the DB already
  new_pkgs <- names(cran_versions) %>%
    setdiff(names(current_db))

  new_packages(new_pkgs, archive = archive, current = current)

  ## Updated packages
  common_pkgs <- intersect(names(cran_versions),
                           names(current_db))
  updated_pkgs <- common_pkgs[ current_db[common_pkgs] !=
                                 cran_versions[common_pkgs] ]

  updated_packages(updated_pkgs, archive = archive, current = current)

  ## Check for archived packages
  archived_pkgs <- names(current_db) %>%
    setdiff(names(cran_versions))

  archive_packages(archived_pkgs, archive = archive, current = current)
}

ver_from_tarname <- function(tarnames) {
  structure(.Data = sub("^.*_([^_]*).tar.gz", "\\1", tarnames),
            .Names = sub("_.*$", "", tarnames)
            )
}

new_packages <- function(pkgs, archive, current) {
  sapply(pkgs, new_package, archive, current)
}

#' @importFrom falsy "%&&%"

new_package <- function(pkg, archive, current) {
  exists(pkg) %&&% return(update_package(pkg, archive, current))
  list("_id" = pkg, "name" = pkg, "archived" = FALSE) %>%
    add_versions(cran_versions(pkg, archive, current), archive, current) %>%
    back_to_json() %>%
    couch_add(id = pkg)
}

updated_packages <- function(pkgs, archive, current) {
  sapply(pkgs, update_package, archive, current)
}

update_package <- function(pkg, archive, current) {
  db_pkg <- package(pkg)
  to_add <- setdiff(cran_versions(pkg, archive, current),
                    names(db_pkg$versions))
  db_pkg %>%
    unarchive() %>%
    add_versions(to_add, archive, current) %>%
    back_to_json() %>%
    couch_add(id = pkg)
}

unarchive <- function(object) {
  object$archived <- FALSE
  object$timeline <- object$timeline %>%
    names() %>%
    setdiff("archived") %>%
    extract(object$timeline, .)

  object
}

add_versions <- function(object, to_add, archive, current) {
  vers <- download_dcf(object$name, to_add, archive, current) %>%
    get_versions()
  object$versions <- c(object$versions, vers)

  object %>%
    add_timeline(archived = FALSE, archived_at = NA) %>%
    add_latest_version() %>%
    add_title() %>%
    add_releases()
}

#' @importFrom falsy "%&&%"

download_dcf <- function(pkg, versions, archive, current) {
  tarnames <- archive[[pkg]] %>%
    rownames()
  tarnames <- tarnames[which(ver_from_tarname(tarnames) %in% versions)]
  url1 <- tarnames %&&% {
    paste(sep = "/",
          cran_site(),
          paste(archive_path_comps, collapse = "/"),
          tarnames)
  }

  tarname2 <- rownames(current)[ rownames(current) %in%
                                 paste0(pkg, "_", versions, ".tar.gz")]
  url2 <- tarname2 %&&% {
    paste(sep = "/",
          cran_site(),
          paste(pkg_path_comps, collapse = "/"),
          tarname2)
  }

  c(url1, url2) %>%
    sapply(get_desc_from_url, pkg = pkg) %>%
    paste(collapse = "\n\n") %>%
    trim_leading() %>%
    dcf_from_string()
}

get_desc_from_url <- function(url, pkg) {
  tmp <- paste0(tempfile(), ".tar.gz")
  on.exit(try(silent = TRUE, unlink(tmp)))
  download.file(url, destfile = tmp)
  get_desc_from_file(tmp, pkg)
}

back_to_json <- function(object, pretty = FALSE) {
  object[["_id"]] <- unboxx(object[["_id"]])
  object[["_rev"]] <- unboxx(object[["_rev"]])
  object[["name"]] <- unboxx(object[["name"]])
  object[["latest"]] <- unboxx(object[["latest"]])
  object[["title"]] <- unboxx(object[["title"]])
  object[["archived"]] <- unboxx(object[["archived"]])
  object[["timeline"]] <- lapply(object[["timeline"]], unboxx)
  object[["versions"]] <- lapply(object[["versions"]], back_to_json_version)
  toJSON(object, pretty = pretty)
}

back_to_json_version <- function(version) {
  deps <- intersect(cran_dep_fields, names(version))
  other <- setdiff(names(version), deps)
  version[other] <- lapply(version[other], unboxx)
  version[deps] <- lapply(version[deps], lapply, function(x) unbox(x[[1]]))
  version$releases <- unlist(version$releases) %||% character()
  version
}

archive_packages <- function(pkgs, archive, current) {
  sapply(pkgs, archive_package, archive, current)
}

archive_package <- function(pkg, archive, current) {
  ## TODO: maybe a new version before it was archived?
  ## TODO: maybe a new package was archived right away?
  archived_at <- archival_date_url(pkg)
  db_pkg <- package(pkg)
  db_pkg$archived <- TRUE
  db_pkg$timeline[["archived"]] <- archived_at %>%
    format_iso_8601()

  db_pkg %>%
    back_to_json() %>%
    couch_add(id = pkg)
}

archival_date_url <- function(pkg) {
  tmp <- tempfile()
  on.exit(try(silent = TRUE, unlink(tmp, recursive = TRUE)))
  dir.create(tmp)
  rsync(paste("cran.r-project.org::CRAN", "web", "packages", pkg, sep="/"), tmp)
  file.path(tmp, pkg) %>%
    file.info() %>%
    extract2("mtime")
}

## Check the version(s) of a package that is/are missing
## from the DB

missing_versions <- function(pkg, archive, current) {
  cran_versions(pkg, archive, current) %>%
    setdiff(versions(pkg))
}

cran_versions <- function(pkg, archive, current) {
  rownames(current) %>%
    grep(pattern = paste0("^", pkg, "_"), value = TRUE) %>%
    c(rownames(archive[[pkg]]), .) %>%
    ver_from_tarname() %>%
    unname()

}
