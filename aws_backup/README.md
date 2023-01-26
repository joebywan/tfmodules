# Created by Joe Howe

Creates an AWS backup vault, and then a dynamic list of plans with accompanying rules to execute backups on selected days.  Notifies a specified email address of backup failures.

Checkout ./example/deploy.tf for an idea of how to use it.


## Notes

* I could probably make the email optional, but I don't think failed backup notifications are something that should be optional.
