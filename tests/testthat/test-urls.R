test_that("asset URLs are built from the latest release", {
  withr::local_options(nfldoinkeR.base_url = NULL)
  expect_equal(doink_url("doinks", "rds"), paste0(latest_prefix, "doinks.rds"))
  expect_equal(doink_url("kickers", "csv"), paste0(latest_prefix, "kickers.csv.gz"))
  expect_equal(doink_url("teams", "parquet"), paste0(latest_prefix, "teams.parquet"))
  expect_equal(manifest_url(), paste0(latest_prefix, "manifest.json"))
})

test_that("the base URL option overrides the constant and gains a trailing slash", {
  withr::local_options(nfldoinkeR.base_url = "https://example.test/mirror")
  expect_equal(doink_url("doinks"), "https://example.test/mirror/doinks.rds")
  expect_equal(manifest_url(), "https://example.test/mirror/manifest.json")
})

test_that("a malformed base URL option is rejected", {
  withr::local_options(nfldoinkeR.base_url = 1)
  expect_error(doink_base_url(), "single non-empty string")
  withr::local_options(nfldoinkeR.base_url = "")
  expect_error(doink_base_url(), "single non-empty string")
})
