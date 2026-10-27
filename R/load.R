#' Load NFL doinks
#'
#' Loads the doinks table from the `latest` data release of
#' [nfldoinkeR-data](https://github.com/ke1v3y/nfldoinkeR-data): one row per
#' kick that hit a goalpost or crossbar. Column types are those written by the
#' data pipeline and are described in `vignette("data-dictionary")`.
#'
#' Files are read with [nflreadr::load_from_url()], so nflreadr's caching and
#' progress behaviour apply. Use [clear_doink_cache()] to clear the cache.
#'
#' @param seasons `TRUE` (the default) loads every season. Otherwise a vector
#'   of whole-number seasons, such as `2020:2024`. A season outside the range
#'   given in the release manifest is an error whose message states the actual
#'   range (see [doink_release_info()]).
#' @param file_type One of `"rds"`, `"parquet"` or `"csv"`. Defaults to
#'   `getOption("nfldoinkeR.prefer", "rds")`. `"parquet"` requires the arrow
#'   package.
#'
#' @return A tibble with class `nflverse_data`.
#'
#' @section Joining to nflverse:
#' `nflverse_game_id` is `NA` for every game before the 1999 season, because
#' nflverse's schedule data has no rows there and no id is constructed. See
#' `vignette("joining-nflverse")`.
#'
#' @section Attribution:
#' CC-BY-4.0. Attribute as "Data from Off the Upright, offtheupright.com".
#'
#' @examples
#' \donttest{
#' load_doinks(2024)
#' }
#' @export
load_doinks <- function(seasons = TRUE,
                        file_type = getOption("nfldoinkeR.prefer", "rds")) {
  file_type <- check_file_type(file_type)
  seasons <- check_seasons(seasons)
  read_table(doink_url("doinks", file_type), seasons = seasons, file_type = file_type)
}

#' Load doink kicker and team profiles
#'
#' `load_doink_kickers()` loads the kicker profile table and
#' `load_doink_teams()` the team table from the `latest` data release. Neither
#' takes a `seasons` argument. The names carry a `doink` marker because
#' [nflreadr::load_teams()] already exists and both packages are usually
#' attached together.
#'
#' @inheritParams load_doinks
#'
#' @return A tibble with class `nflverse_data`.
#'
#' @examples
#' \donttest{
#' load_doink_kickers()
#' load_doink_teams()
#' }
#' @name doink_profiles
#' @export
load_doink_kickers <- function(file_type = getOption("nfldoinkeR.prefer", "rds")) {
  file_type <- check_file_type(file_type)
  read_table(doink_url("kickers", file_type), file_type = file_type)
}

#' @rdname doink_profiles
#' @export
load_doink_teams <- function(file_type = getOption("nfldoinkeR.prefer", "rds")) {
  file_type <- check_file_type(file_type)
  read_table(doink_url("teams", file_type), file_type = file_type)
}

check_file_type <- function(file_type) {
  file_type <- rlang::arg_match0(
    file_type,
    c("rds", "parquet", "csv"),
    arg_nm = "file_type"
  )
  if (identical(file_type, "parquet")) {
    require_arrow()
  }
  file_type
}

check_seasons <- function(seasons) {
  if (isTRUE(seasons)) {
    return(TRUE)
  }
  if (!is.numeric(seasons) || length(seasons) == 0L || anyNA(seasons) ||
      any(seasons != trunc(seasons))) {
    rlang::abort("`seasons` must be `TRUE` or a vector of whole-number seasons, such as `2020:2024`.")
  }
  rng <- released_season_range()
  bad <- seasons[seasons < rng[1] | seasons > rng[2]]
  if (length(bad)) {
    rlang::abort(c(
      sprintf("`seasons` must lie within the released range %s-%s.", rng[1], rng[2]),
      x = paste0("Out of range: ", paste(unique(bad), collapse = ", "), "."),
      i = "See `doink_release_info()` for the current release."
    ))
  }
  as.integer(unique(seasons))
}
