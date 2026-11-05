#' Connect to a PostgreSQL database
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

#' Create a PostgreSQL database if it does not exist
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


#' Create tables in the database
#' @param con database connection established with [con_psql_db()]
#' @importFrom DBI dbExecute
#' @seealso [con_psql_db()]
#' @export
create_tables <- function(con) {
  DBI::dbExecute(
    con,
    "
    CREATE TABLE IF NOT EXISTS items (
      id TEXT PRIMARY KEY,
      source TEXT,
      external_id TEXT,
      url TEXT,
      title TEXT,
      content TEXT,
      published_at TIMESTAMPTZ,
      first_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      raw_data JSONB
    );
  "
  )

  DBI::dbExecute(
    con,
    "
    CREATE TABLE IF NOT EXISTS scoring_runs (
      id TEXT PRIMARY KEY,
      name TEXT,
      model TEXT,
      prompt_version TEXT,
      schema_version TEXT,
      config JSONB,
      created_at TIMESTAMPTZ
    );
  "
  )

  DBI::dbExecute(
    con,
    "
    CREATE TABLE IF NOT EXISTS scores (
      id TEXT PRIMARY KEY,
      item_id TEXT NOT NULL REFERENCES items(id) ON DELETE CASCADE,
      scoring_run_id TEXT NOT NULL REFERENCES scoring_runs(id) ON DELETE CASCADE,
      score_global NUMERIC,
      category TEXT,
      result JSONB,
      status TEXT,
      error_message TEXT,
      scored_at TIMESTAMPTZ
    );
  "
  )

  invisible(con)
}

#' Initialize database schema
#' @param con An active DBI connection
#' @export
initialize_database <- function(con) {
  if (!DBI::dbIsValid(con)) {
    stop("Invalid database connection.", call. = FALSE)
  }

  create_tables(con)

  invisible(con)
}


#' Setup a PostgreSQL database
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
