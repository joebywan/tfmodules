#------------------------------------------------------------------------------
# Create the SCP to restrict permissions
#------------------------------------------------------------------------------
resource "aws_organizations_policy" "no_permissions" {
  name        = "NoPermissions"
  description = "Policy that allows no actions (not deny). This was created because an SCP must always be attached to an OU or account."

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "none:NoSuchActionExistsFoobar"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Allow"
    }
  ]
}
CONTENT
}