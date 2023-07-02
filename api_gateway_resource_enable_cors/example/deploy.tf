module "example" {
  source = "git::https://github.com/joebywan/tfmodules.git//api_gateway_resource_enable_cors"
  api_gateway_id = "your api gateway id" # Use a reference, this is an example
  api_gateway_resource_ids = [    # Takes a set of strings, so provide all of the resource id's you want cors added to
    "your first api gateway resource id",
    "your second api gateway resource id"
  ]
}