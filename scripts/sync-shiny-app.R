sync_dir <- function(from, to) {
  if (!dir.exists(from)) {
    stop("Source directory not found: ", from)
  }
  if (!dir.exists(to)) {
    dir.create(to, recursive = TRUE)
  }
  files <- list.files(from, full.names = TRUE)
  file.copy(files, to, overwrite = TRUE)
}

sync_dir("R", file.path("inst", "shiny-app", "R"))
sync_dir(file.path("inst", "extdata"), file.path("inst", "shiny-app", "extdata"))

message("Synced app sources to inst/shiny-app.")
