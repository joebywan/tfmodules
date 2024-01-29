module "subscription_filter_router" {
  source = "git::https://github.com/joebywan/tfmodules.git//subscription-filter-router"

  workload_name           = "my_custom_workload"
  source_log_group_name   = "/aws/route53/mycustomdomain.com"
  filter_pattern          = "[,,, url=\"example1.mycustomdomain.com\" || url=\"example2.mycustomdomain.com\", ...]"

  service_mapping = {
    "example1" = { "cluster" = "example_cluster_1", "service" = "example_service_1", "region" = "us-west-2" },
    "example2" = { "cluster" = "example_cluster_2", "service" = "example_service_2", "region" = "us-east-1" }
    # Add more mappings as needed
  }
}
