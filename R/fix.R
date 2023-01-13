
fix_mistake <- function(start = NULL) {
  av <- available.packages(repos = "https://cran.r-project.org", type = "source")
  pkgs <- rownames(av)
  if (!is.null(start) && start %in% pkgs) {
    pkgs <- pkgs[match(start, pkgs):length(pkgs)]
  }
  
  for (idx in seq_along(pkgs)) {
    pkg <- pkgs[[idx]]
    message(idx, ". ", pkg)
    url <- paste0("https://crandb.r-pkg.org:2053/cran/", pkg)
    res <- httr::GET(url)
    if (httr::status_code(res) == 404) {
      message("missing, skipped")
      next
    }
    httr::stop_for_status(res)
    json <- httr::content(res, as = "text", encoding = "UTF-8")
    json <- sub(",\"archived\":true", "", json)
    json <- sub(",\"archived\":\"2023.01.13T..:..:.....:..\"", "", json)

    data <- charToRaw(json)
    httr::stop_for_status(httr::PUT(
      url,
      body = data,
      encode = "raw",
      authenticate(Sys.getenv("COUCHDB_USER"), Sys.getenv("COUCHDB_PASSWORD"))
    ))
  }
}
