get_test_connection <- function(dbname = "testdb") {
  user <- Sys.getenv("PGUSER")
  password <- Sys.getenv("PGPASSWORD")
  host <- Sys.getenv("PGHOST", "localhost")
  port <- as.integer(Sys.getenv("PGPORT", "5434"))

  if (user == "" || password == "") {
    testthat::skip("PostgreSQL test credentials unavailable")
  }

  con_psql_db(
    dbname = dbname,
    host = host,
    port = port,
    user = user,
    password = password
  )
}
