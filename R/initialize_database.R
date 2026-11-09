#' @rdname database
#' @param con An active DBI connection
#' @importFrom DBI dbIsValid
#' @export
initialize_database <- function(con) {
  if (!dbIsValid(con)) {
    stop("Invalid database connection.", call. = FALSE)
  }
  create_tables(con)
  invisible(con)
}
