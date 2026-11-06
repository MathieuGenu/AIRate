test_that("Can connect to PostgreSQL", {
  con <- get_test_connection("postgres")
  on.exit(DBI::dbDisconnect(con))

  expect_true(DBI::dbIsValid(con))
})
