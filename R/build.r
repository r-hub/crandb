
## We build the database from a complete CRAN mirror.

build_db <- function() {
  pkgs <- list_cran_packages()
  for (pkg in pkgs$current) { add_package(pkg) }
  for (pkg in pkgs$archive) { add_package(pkg, archived = TRUE) }
}

#' List all packages in a CRAN mirror.
#'
#' This includes archived packages, but currently does
#' not include packages whose name was resued by another package.
#'
#' @export
list_cran_packages <- function() {
  current <- current_rds() %>%
    rownames() %>%
    sub(pattern = "_.*$", replacement = "")

  archive <- archive_rds() %>%
    names()

  list(
    current = current %>% unique() %>% sort(),
    archive = archive %>% setdiff(current) %>% unique() %>% sort()
  )
}

archive_rds <- function() {
  cran_mirror() %>%
    file.path(archive_rds_path) %>%
    readRDS()
}

current_rds <- function() {
  cran_mirror() %>%
    file.path(current_rds_path) %>%
    readRDS()
}

add_package <- function(pkg, archived = FALSE) {
  get_descriptions(pkg) %>%
    pkg_to_json(archived = archived) %>%
    couch_add(id = pkg)
}

get_descriptions <- function(pkg) {
  list_tarballs(pkg) %>%
    sapply(from_tarball, files = file.path(pkg, "DESCRIPTION")) %>%
    paste(collapse = "\n\n") %>%
    dcf_from_string()
}

from_tarball <- function(tar_file, files) {
  tmp <- tempfile()
  on.exit(try(unlink(tmp, recursive = TRUE)))
  dir.create(tmp)
  untar(tar_file, files = files, exdir = tmp)
  file.path(tmp, files) %>%
    sapply(read_file) %>%
    set_names(files)
}

read_file <- function(path) {
  readChar(path, file.info(path)$size)
}

dcf_from_string <- function(dcf, ...) {
  con <- file()
  on.exit(try(close(con)))
  cat(dcf, file = con)
  read.dcf(con, ...)
}

list_tarballs <- function(pkg) {
  current <- current_rds() %>%
    rownames() %>%
    grep(pattern = paste0("^", pkg, "_"), value = TRUE) %>%
    file.path(pkg_path, .)

  order_by_date <- function(df) {
    if (is.null(df)) {
      df
    } else {
      df[order(df$mtime), ]
    }
  }

  archive <- archive_rds() %>%
    extract2(pkg) %>%
    order_by_date() %>%
    rownames() %>%
    file.path(archive_path, .)

  c(archive, current) %>%
    file.path(cran_mirror(), .)
}
