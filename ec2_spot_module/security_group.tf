# <---- Security Group -----> #
resource "aws_security_group" "security_group" {
  name   = "${var.naming_prefix}-security-group"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value.cidr]
    }
  }
  egress {
    description = "Allow All traffic out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
