
create_file_if_missing <- function(path, parent = TRUE) {

  if (parent) {
    dir <- dirname(path)
    if (!file.exists(dir)) { dir.create(dir, recursive = TRUE) }
  }

  if (!file.exists(path)) { cat("", file = path) }

  invisible(path)
}

extract_only <- function(list, names) {
  names <- intersect(names(list), names)
  list[names]
}

with_wd <- function(dir, expr) {
  wd <- getwd()
  on.exit(setwd(wd))
  setwd(dir)
  eval(expr, envir = parent.frame())
}

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

check_external <- function(cmdline) {
  system(cmdline, ignore.stdout = TRUE, ignore.stderr = TRUE) %>%
    equals(0)
}

check_couchapp <- function() {
  if (!check_external("couchapp")) {
    stop("Need an installed couchapp")
  }
}
