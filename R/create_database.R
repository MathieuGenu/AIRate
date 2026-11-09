#' @rdname database
#' @param dbname Database name
#' @param host PostgreSQL host
#' @param port PostgreSQL port
#' @param user PostgreSQL username
#' @param password PostgreSQL password
#' @importFrom DBI dbGetQuery dbExecute dbDisconnect dbQuoteIdentifier
#' @export
create_database <- function(
  dbname,
  host = "localhost",
  port = 5432,
  user,
  password = Sys.getenv("POSTGRES_PASSWORD")
) {
  con <- con_psql_db(
    dbname = "postgres",
    host = host,
    port = port,
    user = user,
    password = password
  )

  on.exit(dbDisconnect(con), add = TRUE)

  exists <- dbGetQuery(
    con,
    "SELECT EXISTS (
      SELECT 1 FROM pg_database WHERE datname = $1
    ) AS exists",
    params = list(dbname)
  )$exists[[1]]

  if (!exists) {
    message("Creating database: ", dbname)

    dbExecute(
      con,
      paste(
        "CREATE DATABASE",
        dbQuoteIdentifier(con, dbname)
      ),
      immediate = TRUE
    )
  } else {
    message("Database already exists: ", dbname)
  }

  invisible(TRUE)
}
