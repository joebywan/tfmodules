module "rss_to_email" {
  source   = "../"
  name     = "rss-to-email"        # Name for the deployment to avoid name clashes with multiple deployments
  schedule = "cron(59 23 * * ? *)" # Default value is 11:59pm each night
  timezone = "Australia/Queensland"
  rssfeeds = [
    "https://airvpn.org/rss/1-airvpn-announcements.xml",
    "https://www.ozbargain.com.au/deals/feed",
    "https://www.topbargains.com.au/rss",
    "http://www.buckscoop.com.au/rss/deals"
  ]
  emails_to_subscribe = [ # Optional.
    "test@test.com"
  ]
}