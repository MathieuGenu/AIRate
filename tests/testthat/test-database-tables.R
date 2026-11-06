test_that("Database tables are correctly created", {
  con <- get_test_connection()
  on.exit(DBI::dbDisconnect(con))

  initialize_database(con)

  tables <- DBI::dbListTables(con)

  expect_true("items" %in% tables)
  expect_true("scoring_runs" %in% tables)
  expect_true("scores" %in% tables)
})

test_that("Database initialization is idempotent", {
  con <- get_test_connection()
  on.exit(DBI::dbDisconnect(con))

  expect_no_error(initialize_database(con))
  expect_no_error(initialize_database(con))
})
