
# Get the required info
variable "api_gateway_id" {
    type = string
}

variable "api_gateway_resource_ids" {
    type = set(string)
}

# Make the options method
resource "aws_api_gateway_method" "options" {
    for_each = var.api_gateway_resource_ids
    rest_api_id = var.api_gateway_id
    resource_id = each.key
    http_method = "OPTIONS"
    authorization = "NONE"
}

# Make the options method integration
resource "aws_api_gateway_integration" "options" {
    depends_on = [ 
        aws_api_gateway_method.options 
    ]
    for_each = var.api_gateway_resource_ids
    rest_api_id = var.api_gateway_id
    resource_id = each.key
    http_method = "ANY"
    type = "MOCK"

    request_templates = {
      "application/json" = "{ \"statusCode\": 200 }"
    }
}

# Make a mock integration for the aws_api_gateway_method.options resource
resource "aws_api_gateway_integration_response" "options" {
    dependepends_on = [ 
        aws_api_gateway_integration.options 
    ]
    for_each = var.api_gateway_resource_ids
    rest_api_id = var.api_gateway_id
    resource_id = each.key
    http_method = "ANY"
    status_code = 200
    integration_id = aws_api_gateway_integration.options.id
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "Authorization,Content-Type,X-Amz-Date,X-Api-Key,X-Amz-Security-Token"
        "method.reponse.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,POST'"
        "method.response.header.Access-Control-Allow-Origin" = "*"
    }
}

resource "aws_api_gateway_method_response" "options" {
    depends_on = [ 
        aws_api_gateway_method.options 
    ]
    for_each = var.api_gateway_resource_ids
    rest_api_id = var.api_gateway_id
    resource_id = each.key
    http_method = "ANY"
    status_code = 200
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "Authorization,Content-Type,X-Amz-Date,X-Api-Key,X-Amz-Security-Token"
        "method.reponse.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,POST'"
        "method.response.header.Access-Control-Allow-Origin" = "*"
    }

    response_models = {
        "application/json" = "Empty"
    }
}