#' @rdname database
#' @param dbname name of the database to connect to
#' @param host PostgreSQL host (default: "localhost")
#' @param port PostgreSQL port (default: 5432)
#' @param user PostgreSQL username
#' @param password PostgreSQL password
#' @importFrom DBI dbConnect
#' @importFrom RPostgres Postgres
#' @export
con_psql_db <- function(
  dbname,
  host = "localhost",
  port = 5432,
  user,
  password = Sys.getenv("POSTGRES_PASSWORD")
) {
  dbConnect(
    drv = Postgres(),
    dbname = dbname,
    host = host,
    port = port,
    user = user,
    password = password
  )
}
