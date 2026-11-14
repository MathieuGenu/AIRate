clear_bsky <- function() {
  data("bsky_posts")
  bsky <- bsky_posts
  bsky$source <- "bsky"
  bsky$published_at <- as.POSIXct(
    bsky$date,
    format = "%Y-%m-%dT%H:%M:%OSZ",
    tz = "UTC"
  )
  names(bsky)[names(bsky) == 'post_uri'] <- 'external_id'
  names(bsky)[names(bsky) == 'auteur'] <- 'author'
  names(bsky)[names(bsky) == 'text'] <- 'content'

  return(bsky)
}
