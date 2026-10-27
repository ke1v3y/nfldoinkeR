fake_manifest <- function(min_season = 1974L, max_season = 2026L) {
  list(
    built_at = "2026-10-27T03:56:50Z",
    data_version = "20261026T223233Z-10",
    format_revision = 5L,
    terms_version = 2L,
    seasons = list(min = min_season, max = max_season),
    nflverse_join = list(
      joinable_from = 1999L,
      doinks_keyed = 0L,
      doinks_unkeyed_1999_on = 806L
    ),
    rows = list(doinks = 892L, kickers = 188L, teams = 50L)
  )
}

latest_prefix <- "https://github.com/ke1v3y/nfldoinkeR-data/releases/download/latest/"
