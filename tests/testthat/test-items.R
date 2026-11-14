test_that("Bluesky posts can be inserted into items", {
  con <- get_test_connection()
  on.exit(DBI::dbDisconnect(con))

  DBI::dbExecute(
    con,
    "DROP TABLE IF EXISTS
      scores,
      scoring_runs,
      items
    CASCADE
    "
  )
  initialize_database(con)

  bluesky_posts <- clear_bsky()
  print(bluesky_posts)
  DBI::dbListFields(con, "items")

  # Insert data
  store_item(
    con = con,
    data_raw = bluesky_posts
  )

  # Retrieve data
  result <- DBI::dbGetQuery(
    con,
    "SELECT *
  FROM items
  WHERE source = 'bsky';"
  )

  expect_equal(nrow(result), 5)

  expect_setequal(
    result$external_id,
    bluesky_posts$external_id
  )
})
