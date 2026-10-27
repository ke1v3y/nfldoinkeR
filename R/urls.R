# The `latest` release is a moving release whose assets are replaced on each
# data change; dated tags (vYYYY.MM.DD) are the immutable copies. The package
# reads `latest`.
base_url <- "https://github.com/ke1v3y/nfldoinkeR-data/releases/download/latest/"

doink_base_url <- function() {
  url <- getOption("nfldoinkeR.base_url", base_url)
  if (!is.character(url) || length(url) != 1L || is.na(url) || !nzchar(url)) {
    rlang::abort("`options(nfldoinkeR.base_url)` must be a single non-empty string.")
  }
  if (!endsWith(url, "/")) {
    url <- paste0(url, "/")
  }
  url
}

# The csv asset is gzipped, so the user-facing "csv" maps to ".csv.gz".
file_extension <- function(file_type) {
  switch(file_type, rds = "rds", parquet = "parquet", csv = "csv.gz")
}

doink_url <- function(table, file_type = "rds") {
  paste0(doink_base_url(), table, ".", file_extension(file_type))
}

manifest_url <- function() {
  paste0(doink_base_url(), "manifest.json")
}
