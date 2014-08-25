
## We build the database from a complete CRAN mirror.

build_db <- function(from = NA) {
  pkgs <- list_cran_packages()

  if (!is.na(from)) {
    if (from %in% pkgs$current) {
      idx <- match(from, pkgs$current)
      pkgs$current <- pkgs$current[idx:length(pkgs$current)]
    } else {
      pkgs$current <- character()
      idx <- match(from, pkgs$archive)
      pkgs$archive <- pkgs$archive[idx:length(pkgs$archive)]
    }
  }

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

  descs <- get_descriptions(pkg) %>%
    remove_bundles()

  if (nrow(descs) > 0) {
    descs %>%
      pkg_to_json(archived = archived) %>%
      couch_add(id = pkg)
  }
}

## TODO: do something with bundles

remove_bundles <- function(dcf) {
  if ("Bundle" %in% colnames(dcf)) {
    dcf <- dcf[is.na(dcf[, "Bundle"]), , drop = FALSE]
  }
  dcf
}

get_descriptions <- function(pkg) {
  list_tarballs(pkg) %>%
    sapply(get_desc_from_file, pkg = pkg) %>%
    paste(collapse = "\n\n") %>%
    dcf_from_string()
}

get_desc_from_file <- function(file, pkg) {
  file_date <- file %>%
    file.info() %>%
    extract2("mtime")

  file %>%
    from_tarball(files = file.path(pkg, "DESCRIPTION")) %>%
    trim_trailing() %>%
    fix_empty_lines() %>%
    paste0("\ncrandb_file_date: ", file_date, "\n")
}

fix_empty_lines <- function(text) {
  text %>%
    gsub(pattern = "\\n[ \\t\\r]*\\n", replacement = "\n  .\n",
         perl = TRUE, useBytes = TRUE) %>%
    gsub(pattern = "\\n[ \\t\\r]*\\n", replacement = "\n",
         perl = TRUE, useBytes = TRUE)
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
  readChar(path, file.info(path)$size, useBytes = TRUE)
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
