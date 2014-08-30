
#' @include cran.r

appname <- (function() {
  `_appname` <- "r-crandb"
  function(name) {
    if (!missing(name)) {
      `_appname` <<- name
    }
    `_appname`
  }
})()

#' @importFrom rappdirs user_config_dir

get_config_file <- function() {
  appname() %>%
    rappdirs::user_config_dir() %>%
    file.path("config.yaml")
}

#' @importFrom yaml yaml.load_file

get_config <- function(key) {
  config <- get_config_file() %>%
    yaml.load_file()

  if (missing(key)) {
    config
  } else {
    config[[key]]
  }
}

#' @importFrom yaml yaml.load_file as.yaml

set_config <- function(key, value) {
  config_file <- get_config_file()

  create_file_if_missing(config_file)

  yaml.load_file(config_file) %>%
    as.list() %>%
    replace(key, value) %>%
    as.yaml() %>%
    cat(file = config_file)
}

#' @importFrom falsy try_quietly "%||%"

getset_config <- function(key, value, default) {
  if (missing(value)) {
    try_quietly(get_config(key)) %||% default
  } else {
    set_config(key, value)
  }
}

cran_mirror <- function(path) {
  getset_config("cran_mirror_path", path, default = cran_mirror_default)
}

couchdb_server <- function(uri, root = FALSE) {
  key <- if (root) "couchdb_server_uri_root" else "couchdb_server_uri"
  getset_config(key, uri, default = couchdb_uri_default)
}
