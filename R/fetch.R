# Everything that touches the network lives in read_table() and
# read_manifest(), so tests can replace both.

# One nflreadr cache per session would hide a new season from a long-running
# session, so the manifest is cached here only for the season-range check and
# doink_release_info() always refetches (and refreshes this cache).
manifest_cache <- new.env(parent = emptyenv())

read_table <- function(url, seasons = TRUE, file_type = "rds") {
  args <- list(url = url, seasons = seasons, nflverse = TRUE)
  # The rds files carry their own nflverse attributes. csv and parquet cannot,
  # so the table type is attached here; the build timestamp is not recoverable
  # from them (see doink_release_info()).
  if (!identical(file_type, "rds")) {
    table <- sub("\\..*$", "", basename(url))
    args$nflverse_type <- paste0(table, " via nfldoinkeR-data")
  }
  do.call(nflreadr::load_from_url, args)
}

read_manifest <- function(url) {
  jsonlite::fromJSON(url)
}

get_manifest <- function(refresh = FALSE) {
  url <- manifest_url()
  if (!refresh && exists(url, envir = manifest_cache, inherits = FALSE)) {
    return(get(url, envir = manifest_cache, inherits = FALSE))
  }
  manifest <- tryCatch(
    read_manifest(url),
    error = function(e) {
      rlang::abort(
        c(
          "Could not read the release manifest.",
          i = paste0("URL: ", url),
          x = conditionMessage(e)
        ),
        parent = e
      )
    }
  )
  assign(url, manifest, envir = manifest_cache)
  manifest
}

reset_manifest_cache <- function() {
  rm(list = ls(manifest_cache, all.names = TRUE), envir = manifest_cache)
  invisible(NULL)
}

released_season_range <- function() {
  seasons <- get_manifest()$seasons
  rng <- suppressWarnings(as.numeric(c(seasons$min, seasons$max)))
  if (length(rng) != 2L || anyNA(rng)) {
    rlang::abort("The release manifest does not give a season range, so `seasons` cannot be checked.")
  }
  rng
}

require_arrow <- function() {
  rlang::check_installed("arrow", reason = "to read the parquet files (`file_type = \"parquet\"`)")
}
