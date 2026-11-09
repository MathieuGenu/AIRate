#' @rdname database
#' @param dbname Database name
#' @param host PostgreSQL host
#' @param port PostgreSQL port
#' @param user PostgreSQL username
#' @param password PostgreSQL password
#' @export
setup_database <- function(
  dbname,
  host = "localhost",
  port = 5432,
  user,
  password = Sys.getenv("POSTGRES_PASSWORD")
) {
  # Create database if necessary
  create_database(
    dbname = dbname,
    host = host,
    port = port,
    user = user,
    password = password
  )

  # Connect to target database
  con <- con_psql_db(
    dbname = dbname,
    host = host,
    port = port,
    user = user,
    password = password
  )

  # Initialize tables
  initialize_database(con)

  message("Database successfully initialized.")

  invisible(con)
}
