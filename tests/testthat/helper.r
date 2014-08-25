
if (getOption("repos")["CRAN"] == "@CRAN@") {
  options(repos = structure(c(CRAN = "http://cran.rstudio.com")))
}

#' Download a file from CRAN
#'
#' @param file The file to download, it is a character vector
#'   of path components.
#' @param dest_dir Destination directory.

download_from_cran <- function(file, dest_dir, suffix = "",
                               overwrite = FALSE) {

  url <-   getOption("repos")["CRAN"] %>%
    paste(sep = "/", paste(file, collapse = "/"))

  dest_file <- file %>%
    paste(collapse = "/") %>%
    strsplit("/") %>%
    extract2(1) %>%
    as.list() %>%
    do.call(file.path, args = .) %>%
    file.path(dest_dir, .) %>%
    paste0(suffix)

  if (! file.exists(dest_file) || overwrite) {
    dir <- dirname(dest_file)
    if (!file.exists(dir)) { dir.create(dir, recursive = TRUE) }
    download.file(url = url, destfile = dest_file, quiet = TRUE)
  }
}

create_test_mirror <- function(path = test_mirror_dir) {

  c(pkg_path, archive_path, dirname(archive_rds_path),
      dirname(current_rds_path)) %>%
    file.path(path, .) %>%
    sapply(dir.create, recursive = TRUE, showWarnings = FALSE)

  list(archive_rds_path_comps, current_rds_path_comps) %>%
    sapply(download_from_cran, dest = test_mirror_dir, suffix = "-full")
}

#' Download the specified packages from CRAN, all versions,
#' and also update the RDS files

need_pkgs <- function(pkgs) {

  ## archive.rds
  archive_rds_new <- file.path(test_mirror_dir, archive_rds_path)
  archive_rds_full <- paste0(archive_rds_new, "-full")
  readRDS(archive_rds_full) %>%
    extract_only(pkgs) %>%
    saveRDS(archive_rds_new)

  ## current.rds
  current_rds_new <- file.path(test_mirror_dir, current_rds_path)
  current_rds_full <- paste0(current_rds_new, "-full")
  current <- readRDS(current_rds_full)
  rows <- sub("_.*$", "", rownames(current)) %in% pkgs
  current[rows, ] %>%
    saveRDS(current_rds_new)

  ## Package tarballs, all that are refered from current & archive
  get_pkgs_from_cran()
}

get_pkgs_from_cran <- function() {

  current <- file.path(test_mirror_dir, current_rds_path) %>%
    readRDS() %>%
    rownames() %>%
    file.path(pkg_path, .)

  archive <- file.path(test_mirror_dir, archive_rds_path) %>%
    readRDS() %>%
    lapply(rownames) %>%
    unlist() %>%
    file.path(archive_path, .)

  c(current, archive) %>%
    sapply(download_from_cran, dest = test_mirror_dir)
}

## Overwrite the app name, so that we don't mess up the proper config

appname_save <- appname()
paste0("r-crandb-test-", Sys.getpid()) %>%
  appname()

test_mirror_dir <- Sys.getpid() %>%
    paste0("crandb-test-", .) %>%
    file.path(tempdir(), .)

cran_mirror(test_mirror_dir)

create_test_mirror(test_mirror_dir)
