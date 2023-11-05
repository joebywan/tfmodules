locals {
    scheduler_target = var.start_or_stop == "start" ? "arn:aws:scheduler:::aws-sdk:ec2:startInstances" : "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
}