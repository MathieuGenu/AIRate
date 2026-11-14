#' Example Bluesky posts
#'
#' A dataset containing five posts collected from Bluesky
#' on 2026-11-09 using the query
#' '"statistical modelling" ecology'.
#'
#' @format A tibble with 5 rows and 7 columns:
#' \describe{
#'   \item{source}{Data source}
#'   \item{external_id}{Original Bluesky URI}
#'   \item{url}{Public post URL}
#'   \item{title}{Optional title}
#'   \item{content}{Post content}
#'   \item{published_at}{Publication date}
#'   \item{raw_data}{Original post data in JSON format without author information}
#' }
#' @source Bluesky search API
"bsky_posts"
