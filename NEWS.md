# nfldoinkeR 0.1.0

* First release.
* `load_doinks()`, `load_doink_kickers()` and `load_doink_teams()` read the
  doink, kicker and team tables from the `latest` release of
  nfldoinkeR-data, as `rds` (default), `parquet` or `csv`.
* `doink_release_info()` returns the release manifest without downloading data.
* `clear_doink_cache()` clears the nflreadr cache.
* Vignettes: joining to nflverse schedules and players, and a data dictionary.
