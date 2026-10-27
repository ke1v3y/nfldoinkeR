#' Describe the current data release
#'
#' Reads `manifest.json` from the `latest` data release and returns it as a
#' list, so "how fresh is this?" can be answered without downloading any data.
#' The manifest is fetched on every call (it is small), and the fetched copy is
#' also what [load_doinks()] uses to check `seasons`.
#'
#' @return A list parsed from the manifest. At the time of writing it contains
#'   `built_at`, `data_version`, `format_revision`, `terms_version`, `source`,
#'   `seasons` (`min` and `max`), `nflverse_join` (`joinable_from`,
#'   `doinks_keyed`, `doinks_unkeyed_1999_on`), `rows` (`doinks`, `kickers`,
#'   `teams`), `files` (bytes and sha256 per file), `pipeline`, `license` and
#'   `attribution`. New fields may be added by the pipeline.
#'
#' @examples
#' \donttest{
#' info <- doink_release_info()
#' info$built_at
#' info$seasons
#' }
#' @export
doink_release_info <- function() {
  get_manifest(refresh = TRUE)
}

#' Clear the doink cache
#'
#' Clears the nflreadr cache by calling [nflreadr::clear_cache()]. That cache is
#' shared with every other nflreadr function in the session, so this clears
#' nflreadr's cached downloads too, not only doink tables. It also discards the
#' manifest this package holds for the `seasons` check.
#'
#' @return What [nflreadr::clear_cache()] returns.
#'
#' @examples
#' clear_doink_cache()
#' @export
clear_doink_cache <- function() {
  reset_manifest_cache()
  nflreadr::clear_cache()
}
