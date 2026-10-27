#' nfldoinkeR: Load NFL Doink Data from Off the Upright
#'
#' Loads the Off the Upright doink database from the data releases at
#' <https://github.com/ke1v3y/nfldoinkeR-data>. The package ships no data and
#' never contacts offtheupright.com; every function reads release assets from
#' GitHub through [nflreadr::load_from_url()].
#'
#' @section Options:
#' * `nfldoinkeR.prefer`: default `file_type` for the loaders, one of
#'   `"rds"` (the default), `"parquet"` or `"csv"`.
#' * `nfldoinkeR.base_url`: base URL the release assets are read from, for
#'   mirrors and tests. Defaults to the `latest` release of
#'   `ke1v3y/nfldoinkeR-data`.
#'
#' @section Data licence and attribution:
#' The data are released under CC-BY-4.0. Attribute them as "Data from Off the
#' Upright, offtheupright.com". To cite a specific cut, cite the dated release
#' tag (`vYYYY.MM.DD`) of the release you used rather than `latest`, which
#' moves.
#'
#' @keywords internal
"_PACKAGE"
