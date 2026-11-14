#' @rdname database
#' @param con database connection established with [con_psql_db()]
#' @importFrom DBI dbExecute
#' @seealso [con_psql_db()]
#' @export
create_tables <- function(con) {
  DBI::dbExecute(
    con,
    "
    CREATE TABLE IF NOT EXISTS items (
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      source TEXT,
      external_id TEXT,
      url TEXT,
      author TEXT,
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
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
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
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      item_id BIGINT NOT NULL REFERENCES items(id) ON DELETE CASCADE,
      scoring_run_id BIGINT NOT NULL REFERENCES scoring_runs(id) ON DELETE CASCADE,
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
