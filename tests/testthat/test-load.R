test_that("load_doinks passes the URL, seasons and file type to the reader", {
  reset_manifest_cache()
  withr::defer(reset_manifest_cache())
  withr::local_options(nfldoinkeR.base_url = NULL, nfldoinkeR.prefer = NULL)
  calls <- list()
  local_mocked_bindings(
    read_manifest = function(url) fake_manifest(),
    read_table = function(url, seasons = TRUE, file_type = "rds") {
      calls[[length(calls) + 1L]] <<- list(url = url, seasons = seasons, file_type = file_type)
      data.frame(x = 1)
    }
  )

  load_doinks()
  load_doinks(2020:2021)

  expect_length(calls, 2L)
  expect_equal(calls[[1]]$url, paste0(latest_prefix, "doinks.rds"))
  expect_identical(calls[[1]]$seasons, TRUE)
  expect_identical(calls[[1]]$file_type, "rds")
  expect_identical(calls[[2]]$seasons, 2020:2021)
})

test_that("seasons outside the manifest range error and name the range", {
  reset_manifest_cache()
  withr::defer(reset_manifest_cache())
  calls <- 0L
  local_mocked_bindings(
    read_manifest = function(url) fake_manifest(),
    read_table = function(...) {
      calls <<- calls + 1L
      data.frame(x = 1)
    }
  )

  expect_error(load_doinks(2030), "1974-2026")
  expect_error(load_doinks(1973), "1974-2026")
  expect_error(load_doinks(c(2020, 2030)), "2030")
  expect_equal(calls, 0L)
  expect_no_error(load_doinks(c(1974, 2026)))
  expect_equal(calls, 1L)
})

test_that("malformed seasons are rejected before any network call", {
  local_mocked_bindings(
    read_manifest = function(url) stop("manifest must not be read"),
    read_table = function(...) stop("reader must not be called")
  )
  expect_error(load_doinks("2020"), "whole-number")
  expect_error(load_doinks(2020.5), "whole-number")
  expect_error(load_doinks(NA_integer_), "whole-number")
  expect_error(load_doinks(integer(0)), "whole-number")
  expect_error(load_doinks(FALSE), "whole-number")
})

test_that("an unreadable season range is an error, not a skipped check", {
  reset_manifest_cache()
  withr::defer(reset_manifest_cache())
  local_mocked_bindings(
    read_manifest = function(url) list(),
    read_table = function(...) data.frame(x = 1)
  )
  expect_error(load_doinks(2020), "season range")
})

test_that("file_type is validated and arrow is only needed for parquet", {
  withr::local_options(nfldoinkeR.prefer = NULL)
  reader_calls <- 0L
  arrow_checks <- 0L
  local_mocked_bindings(
    require_arrow = function() {
      arrow_checks <<- arrow_checks + 1L
      rlang::abort("arrow is missing")
    },
    read_table = function(...) {
      reader_calls <<- reader_calls + 1L
      data.frame(x = 1)
    }
  )

  expect_error(load_doink_kickers(file_type = "xlsx"), "file_type")
  expect_error(load_doink_kickers(file_type = "parquet"), "arrow is missing")
  expect_equal(reader_calls, 0L)

  load_doink_kickers(file_type = "rds")
  load_doink_kickers(file_type = "csv")
  expect_equal(arrow_checks, 1L)
  expect_equal(reader_calls, 2L)
})

test_that("the file type option sets the default and maps csv to csv.gz", {
  withr::local_options(nfldoinkeR.base_url = NULL)
  urls <- character()
  local_mocked_bindings(
    read_table = function(url, seasons = TRUE, file_type = "rds") {
      urls <<- c(urls, url)
      data.frame(x = 1)
    }
  )

  withr::local_options(nfldoinkeR.prefer = NULL)
  load_doink_kickers()
  withr::local_options(nfldoinkeR.prefer = "csv")
  load_doink_kickers()
  load_doink_teams()

  expect_equal(urls, paste0(latest_prefix, c("kickers.rds", "kickers.csv.gz", "teams.csv.gz")))
})

test_that("parquet URLs are built when arrow is installed", {
  skip_if_not_installed("arrow")
  withr::local_options(nfldoinkeR.base_url = NULL)
  url <- NULL
  local_mocked_bindings(
    read_table = function(url_in, ...) {
      url <<- url_in
      data.frame(x = 1)
    }
  )
  load_doink_teams(file_type = "parquet")
  expect_equal(url, paste0(latest_prefix, "teams.parquet"))
})

test_that("the profile loaders never read the manifest", {
  local_mocked_bindings(
    read_manifest = function(url) stop("manifest must not be read"),
    read_table = function(...) data.frame(x = 1)
  )
  expect_no_error(load_doink_kickers())
  expect_no_error(load_doink_teams())
})
