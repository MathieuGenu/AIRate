#' Database management
#'
#' Functions to connect to, create and initialize a PostgreSQL
#' database used by AIRate.
#'
#' AIRate uses PostgreSQL to store items, scoring runs and scoring
#' results. The database setup workflow consists of:
#'
#' \enumerate{
#'   \item Creating the database if it does not already exist.
#'   \item Connecting to the database.
#'   \item Initializing the database schema by creating the required
#'   tables if they do not already exist.
#' }
#'
#' @section Functions:
#'
#' \describe{
#'   \item{\code{con_psql_db()}}{
#'     Establishes a connection to an existing PostgreSQL database.
#'   }
#'   \item{\code{create_database()}}{
#'     Creates a PostgreSQL database if it does not already exist.
#'   }
#'   \item{\code{create_tables()}}{
#'     Creates the tables required by AIRate if they do not already exist.
#'   }
#'   \item{\code{initialize_database()}}{
#'     Checks the connection and initializes the database schema.
#'   }
#'   \item{\code{setup_database()}}{
#'     Performs the complete database setup: creation, connection
#'     and initialization.
#'   }
#' }
#'
#' @section Database schema:
#'
#' The database contains three main tables:
#'
#' \describe{
#'   \item{\code{items}}{
#'     Stores the collected items, their metadata and raw data
#'     (JSONB).
#'   }
#'   \item{\code{scoring_runs}}{
#'     Stores information about scoring configurations, models
#'     and prompt versions.
#'   }
#'   \item{\code{scores}}{
#'     Stores scoring results associated with items and scoring runs.
#'   }
#' }
#'
#' @section Credentials:
#'
#' All connection functions accept the following parameters:
#'
#' \describe{
#'   \item{\code{dbname}}{Name of the PostgreSQL database.}
#'   \item{\code{host}}{PostgreSQL server host. Defaults to
#'   \code{"localhost"}.}
#'   \item{\code{port}}{PostgreSQL server port. Defaults to
#'   \code{5432}.}
#'   \item{\code{user}}{PostgreSQL username.}
#'   \item{\code{password}}{PostgreSQL password. Defaults to the
#'   \code{POSTGRES_PASSWORD} environment variable.}
#' }
#'
#' It is recommended to store the password in an environment variable
#' rather than writing it directly in scripts.
#'
#' @return
#' \describe{
#'   \item{\code{con_psql_db()}}{A DBI connection.}
#'   \item{\code{create_database()}}{Invisible \code{TRUE}.}
#'   \item{\code{create_tables()}}{The supplied DBI connection,
#'   invisibly.}
#'   \item{\code{initialize_database()}}{The supplied DBI connection,
#'   invisibly.}
#'   \item{\code{setup_database()}}{An initialized DBI connection,
#'   invisibly.}
#' }
#'
#' @examples
#' \dontrun{
#' library(AIRate)
#' library(DBI)
#'
#' # Create and initialize the database
#' con <- setup_database(
#'   dbname = "airate",
#'   host = "localhost",
#'   port = 5432,
#'   user = "postgres",
#'   password = Sys.getenv("POSTGRES_PASSWORD")
#' )
#'
#' # List available tables
#' dbListTables(con)
#'
#' # Close the connection when finished
#' dbDisconnect(con)
#' }
#'
#' @name database
#' @aliases con_psql_db create_database create_tables
#'   initialize_database setup_database
#' @seealso DBI::dbConnect(), DBI::dbDisconnect()
NULL
