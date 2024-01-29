data "archive_file" "lambda_zip" {
    type        = "zip"
    source_file = "${path.module}/scripts/start_service.py"
    output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "ecs_lambda" {
    function_name = "${var.workload_name}-lambda_function"
    filename      = data.archive_file.lambda_zip.output_path
    
    runtime = "python3.12"
    role    = aws_iam_role.lambda_role.arn

    source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

    environment {
        variables = {
            SERVICE_MAPPING = jsonencode(var.service_mapping)
        }
    }

}
