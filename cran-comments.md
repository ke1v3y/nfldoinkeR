## Submission

This is a new submission.

nfldoinkeR loads NFL "doink" data (kicks that hit a goalpost or crossbar) from
the data releases of <https://github.com/ke1v3y/nfldoinkeR-data> through
nflreadr. The package ships no data. Every function reads release assets over
HTTPS from GitHub, and nothing is written outside `tempdir()`.

## Test environments

* Local Windows 11, R 4.4.1: `devtools::check(remote = TRUE, manual = TRUE)`
* win-builder, R Under development (unstable) (2026-11-16 r90914 ucrt)
* GitHub Actions (`R-CMD-check`, r-lib/actions `check-standard`): macos-latest
  (R release), windows-latest (R release), ubuntu-latest (R devel, R release,
  R oldrel-1)

## R CMD check results

0 errors | 0 warnings | 1 note on win-builder (R-devel); 2 notes locally.

* checking CRAN incoming feasibility: "New submission". Expected for a first
  submission.

* Possibly misspelled words in DESCRIPTION: "Doink" and "doinks". Both are
  correct. A "doink" is the football term for a kick that hits a goalpost or
  crossbar, and the DESCRIPTION defines it in its first sentence.

* checking for future file timestamps: "unable to verify current time". This
  appeared only on the local Windows machine, which could not reach a time
  server. It did not appear on win-builder.

## Internet access

The package reads from GitHub by design.

* Examples that need the network are wrapped in `\donttest{}`.
* Tests are offline by default (internal readers are mocked). One test that
  loads the live release is guarded by `skip_on_cran()` and `skip_if_offline()`.
* Vignette code runs only when `NOT_CRAN` is `"true"`.
* If the release or its manifest cannot be reached, the loaders stop with an
  informative error naming the URL.

## Reverse dependencies

None. This is a new package.
