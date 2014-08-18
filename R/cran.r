
## CRAN configuration, just to keep it at a single place

pkg_path_comps <- list("src", "contrib")
pkg_path <- do.call(file.path, pkg_path_comps)
archive_path_comps <- list("src", "contrib", "Archive")
archive_path <- do.call(file.path, archive_path_comps)
archive_rds_path_comps <- list("src", "contrib", "Meta", "archive.rds")
archive_rds_path <- do.call(file.path, archive_rds_path_comps)
current_rds_path_comps <- list("src", "contrib", "Meta", "current.rds")
current_rds_path <- do.call(file.path, current_rds_path_comps)

cran_dep_fields  <- c("Depends", "Imports", "Suggests", "Enhances",
                      "LinkingTo")

## CRAN@github configuration

cran_mirror_default <- NA_character_
couchdb_uri_default <- "http://db.r-pkg.org/"
