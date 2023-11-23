resource "aws_lambda_layer_version" "feedparser_layer" {
    filename            = "feedparser_layer.zip"
    layer_name          = "feedparser-layer"
    compatible_runtimes = ["python3.11"]
    source_code_hash    = filebase64sha256("feedparser_layer.zip")
}

data "archive_file" "lambda_function" {
    type        = "zip"
    source_file = "${path.module}/script/lambda_function.py"
    output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "rss_lambda_function" {
    filename         = data.archive_file.lambda_function.output_path # Your Lambda function package
    function_name    = local.lambda_function_name
    role             = aws_iam_role.lambda_execution_role.arn
    runtime          = "python3.11"
    handler          = "lambda_function.lambda_handler"
    source_code_hash = data.archive_file.lambda_function.output_base64sha256
    layers = [
        aws_lambda_layer_version.feedparser_layer.arn
    ]
    timeout = (length(var.rssfeeds) * 10)

    environment {
        variables = {
            SNS_TOPIC_ARN        = aws_sns_topic.rss_sns_topic.arn
            LAMBDA_FUNCTION_NAME = local.lambda_function_name
            RSS_FEED_URLS        = local.rss_feed_urls
            TIMEZONE_NAME        = var.timezone
            LAST_CHECKED_DATE    = "1900-01-01" # Set it to the start of the century, it'll get updated when the lambda function runs
        }
    }
}
