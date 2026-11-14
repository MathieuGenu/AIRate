#' Insert data into items table in the database preconnected
#' @param con database connection established
#' @param data a data.frame containing the following elements:
#' \describe{
#'   \item{source}{Data source}
#'   \item{external_id}{Original Bluesky URI}
#'   \item{url}{Public post URL}
#' }
#' @seealso [con_psql_db()], [initialize_database()]
#' @importFrom DBI dbWithTransaction dbWriteTable dbExecute dbRemoveTable
#' @export
store_item <- function(con, data_raw) {
  data <- lapply(seq_len(nrow(data_raw)), function(i) {
    verify_item(data_raw[i, ])
  })
  data <- do.call(rbind, data)

  dbWithTransaction(con, {
    # Temporary staging table
    dbWriteTable(
      con,
      name = "items_staging",
      value = as.data.frame(data),
      temporary = TRUE,
      overwrite = TRUE,
      row.names = FALSE
    )

    # Insert or update
    dbExecute(
      con,
      "
      INSERT INTO items (
        source,
        external_id,
        url,
        author,
        title,
        content,
        published_at,
        raw_data
      )
      SELECT
        source,
        external_id,
        url,
        author,
        title,
        content,
        published_at,
        raw_data::jsonb
      FROM items_staging
      ON CONFLICT (id) DO UPDATE
      SET last_seen_at = NOW()
      "
    )

    # Drop staging table
    dbRemoveTable(con, "items_staging")
  })

  invisible(data)
}

#' Verifiy item data before inserting into the database
#' @param data data to be verified
#' @importFrom jsonlite toJSON
#' @export
verify_item <- function(data) {
  # source
  if (any(names(data) == "source")) {
    if (!is.character(data$source) || length(data$source) != 1) {
      stop("source must be a character string of length 1")
    }
  } else {
    data$source <- NA_character_
  }

  # external_id
  if (any(names(data) == "external_id")) {
    if (!is.character(data$external_id) || length(data$external_id) != 1) {
      stop("external_id must be a character string of length 1")
    }
  } else {
    data$external_id <- NA_character_
  }

  # url
  if (any(names(data) == "url")) {
    if (!is.character(data$url) || length(data$url) != 1) {
      stop("external_id must be a character string of length 1")
    }
    if (!grepl("^https?://", data$url)) {
      stop("url must be a valid URL starting with http:// or https://")
    }
  } else {
    data$url <- NA_character_
  }

  # author
  if (any(names(data) == "author")) {
    if (!is.character(data$author) || length(data$author) != 1) {
      stop("author must be a character string of length 1")
    }
  } else {
    data$author <- NA_character_
  }

  # title
  if (any(names(data) == "title")) {
    if (!is.character(data$title) || length(data$title) != 1) {
      stop("title must be a character string of length 1")
    }
  } else {
    data$title <- NA_character_
  }
  # content
  if (any(names(data) == "content")) {
    if (!is.character(data$content) || length(data$content) != 1) {
      stop("content must be a character string of length 1")
    }
  } else {
    data$content <- NA_character_
  }
  # published_at
  if (any(names(data) == "published_at")) {
    if (!inherits(data$published_at, "POSIXct")) {
      stop("published_at must be a POSIXct object")
    }
  } else {
    data$published_at <- NA
  }

  # raw_data
  if (any(names(data) == "raw_data")) {
    if (!is.character(data$raw_data) || length(data$raw_data) != 1) {
      stop("raw_data must be a character string of length 1")
    }
  } else {
    if (is.list(raw_data)) {
      raw_data <- toJSON(
        data,
        auto_unbox = TRUE,
        null = "null",
        na = "null"
      )
    }
  }

  return(data[, c(
    "source",
    "external_id",
    "url",
    "author",
    "title",
    "content",
    "published_at",
    "raw_data"
  )])
}
