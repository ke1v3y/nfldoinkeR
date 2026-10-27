test_that("latest release loads and row counts match the manifest", {
  skip_on_cran()
  skip_if_offline("github.com")

  info <- doink_release_info()
  doinks <- load_doinks()
  kickers <- load_doink_kickers()
  teams <- load_doink_teams()

  expect_equal(nrow(doinks), info$rows$doinks)
  expect_equal(nrow(kickers), info$rows$kickers)
  expect_equal(nrow(teams), info$rows$teams)
  expect_s3_class(doinks, "nflverse_data")
  expect_true(all(doinks$season >= info$seasons$min & doinks$season <= info$seasons$max))
})
