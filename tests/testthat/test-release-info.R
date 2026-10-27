test_that("doink_release_info returns the manifest as a list", {
  reset_manifest_cache()
  withr::defer(reset_manifest_cache())
  local_mocked_bindings(read_manifest = function(url) fake_manifest())

  info <- doink_release_info()
  expect_type(info, "list")
  expect_equal(info$data_version, "20261026T223233Z-10")
  expect_equal(info$rows$doinks, 892L)
  expect_equal(info$seasons$min, 1974L)
})

test_that("doink_release_info refetches every call but loaders reuse the cache", {
  reset_manifest_cache()
  withr::defer(reset_manifest_cache())
  fetches <- 0L
  local_mocked_bindings(
    read_manifest = function(url) {
      fetches <<- fetches + 1L
      fake_manifest()
    },
    read_table = function(...) data.frame(x = 1)
  )

  doink_release_info()
  doink_release_info()
  expect_equal(fetches, 2L)

  reset_manifest_cache()
  fetches <- 0L
  load_doinks(2020)
  load_doinks(2021)
  expect_equal(fetches, 1L)
})

test_that("doink_release_info refreshes the range the loaders check against", {
  reset_manifest_cache()
  withr::defer(reset_manifest_cache())
  max_season <- 2026L
  local_mocked_bindings(
    read_manifest = function(url) fake_manifest(max_season = max_season),
    read_table = function(...) data.frame(x = 1)
  )

  expect_error(load_doinks(2027), "1974-2026")
  max_season <- 2027L
  expect_error(load_doinks(2027), "1974-2026")
  doink_release_info()
  expect_no_error(load_doinks(2027))
})

test_that("a manifest read failure is reported with the URL", {
  reset_manifest_cache()
  withr::defer(reset_manifest_cache())
  local_mocked_bindings(read_manifest = function(url) stop("boom"))
  expect_error(doink_release_info(), "Could not read the release manifest")
})

test_that("clear_doink_cache clears nflreadr's cache and the manifest", {
  reset_manifest_cache()
  withr::defer(reset_manifest_cache())
  cleared <- 0L
  fetches <- 0L
  local_mocked_bindings(
    clear_cache = function() {
      cleared <<- cleared + 1L
      "cleared"
    },
    .package = "nflreadr"
  )
  local_mocked_bindings(
    read_manifest = function(url) {
      fetches <<- fetches + 1L
      fake_manifest()
    },
    read_table = function(...) data.frame(x = 1)
  )

  load_doinks(2020)
  expect_equal(fetches, 1L)
  expect_equal(clear_doink_cache(), "cleared")
  expect_equal(cleared, 1L)
  load_doinks(2020)
  expect_equal(fetches, 2L)
})
