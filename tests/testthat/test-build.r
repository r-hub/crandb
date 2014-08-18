
context("Extracting data from CRAN")

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

## ----------------------------------------------------------------------

test_that("Listing CRAN packages", {
  need_pkgs(c("assertthat", "testthat"))
  expect_equal(list_cran_packages(),
               list(current = c("assertthat", "testthat"),
                    archive = character()))

  need_pkgs(c("assertthat", "igraph0"))
  expect_equal(list_cran_packages(),
               list(current = "assertthat", archive = "igraph0"))
})

test_that("DCF from string", {
  DESC = 'Package: crandb
Title: CRAN metadata in a CouchDB database
Version: 0.1
Authors@R: "Gabor Csardi <csardi.gabor@gmail.com> [aut, cre]"
Description: Build, update and query a CouchDB database
    that contains CRAN metadata, about all versions of all packages.
Imports:
    magrittr,
    R4CouchDB,
    rappdirs,
'

  dcf <- dcf_from_string(DESC)
  expect_equal(dcf[, "Package"], c(Package = "crandb"))
  expect_equal(dcf[, "Version"], c(Version = "0.1"))
})

test_that("Extract a file from a tarball", {
  tmp <- tempfile()
  on.exit(try(unlink(tmp, recursive = TRUE)), add = TRUE)
  dir.create(tmp)

  cat("Hello world!\n", file = file.path(tmp, "hello.txt"))
  tarfile <- basename(tmp) %>%
    paste0(".tar.gz")
  on.exit(try(unlink(tarfile)), add = TRUE)
  with_wd(tempdir(), tar(tarfile, basename(tmp), compression = "gzip"))

  hello <- basename(tmp) %>%
    file.path("hello.txt")
  cnt <- file.path(tempdir(), tarfile) %>%
    from_tarball(hello)
  expect_equal(unname(cnt), "Hello world!\n")

})

test_that("List tarballs for a package", {
  need_pkgs(c("assertthat", "testthat", "igraph0"))
  expect_equal(list_tarballs("assertthat"),
               file.path(cran_mirror(), "src/contrib/assertthat_0.1.tar.gz"))

  igraph0_res <- c("src/contrib/Archive/igraph0/igraph0_0.5.5.tar.gz",
                   "src/contrib/Archive/igraph0/igraph0_0.5.5-1.tar.gz",
                   "src/contrib/Archive/igraph0/igraph0_0.5.5-2.tar.gz",
                   "src/contrib/Archive/igraph0/igraph0_0.5.5-3.tar.gz",
                   "src/contrib/Archive/igraph0/igraph0_0.5.6.tar.gz",
                   "src/contrib/Archive/igraph0/igraph0_0.5.6-1.tar.gz",
                   "src/contrib/Archive/igraph0/igraph0_0.5.6-2.tar.gz",
                   "src/contrib/Archive/igraph0/igraph0_0.5.7.tar.gz")

  expect_equal(list_tarballs("igraph0"),
               file.path(cran_mirror(), igraph0_res))
})

test_that("", {
  need_pkgs(c("assertthat", "testthat", "igraph0"))
  desc <- get_descriptions("assertthat")
  expect_equal(nrow(desc), 1)
  expect_true(all(c("Package", "Version", "Title") %in% colnames(desc)))

  desc2 <- get_descriptions("igraph0")
  expect_equal(nrow(desc2), 8)
  expect_true(all(c("Package", "Version", "Title") %in% colnames(desc2)))
})

test_that("Convert DESCRIPTIONs to JSON", {
  desc <- structure(c("assertthat", "Easy pre and post assertions.", "0.1",
    "'Hadley Wickham <h.wickham@gmail.com> [aut,cre]'",
    "assertthat is an extension to stopifnot() that makes it\neasy to declare the pre and post conditions that you code should\nsatisfy, while also producing friendly error messages so that your\nusers know what they've done wrong.",
    "GPL-3", "testthat", "'assert-that.r' 'on-failure.r' 'assertions-file.r'\n'assertions-scalar.R' 'assertions.r' 'base.r'\n'base-comparison.r' 'base-is.r' 'base-logical.r' 'base-misc.r'\n'utils.r' 'validate-that.R'",
    "list(wrap = FALSE)", "2013-12-05 18:46:37 UTC; hadley",
    "'Hadley Wickham' [aut, cre]", "'Hadley Wickham' <h.wickham@gmail.com>",
    "no", "CRAN", "2013-12-06 00:51:10"), .Dim = c(1L, 15L),
    .Dimnames = list(NULL, c("Package", "Title", "Version", "Authors@R",
    "Description", "License", "Suggests", "Collate", "Roxygen", "Packaged",
    "Author", "Maintainer", "NeedsCompilation", "Repository",
    "Date/Publication")))
  json <- pkg_to_json(desc, archived = FALSE, pretty = TRUE)
  ## TODO
})

test_that("Convert real DESCRIPTIONs to JSON", {
  need_pkgs(c("assertthat", "testthat", "igraph0"))
  json <- get_descriptions("assertthat") %>%
    pkg_to_json(archived = FALSE, pretty = TRUE)
  ## TODO
})

## ----------------------------------------------------------------------

## Cleanup, this is also called in case of an error, at least within
## the test_that calls. We do not delete the files, as they will
## be deleted when R exists, anyway, and it is good to keep that
## while running the tests many times.

appname(appname_save)
