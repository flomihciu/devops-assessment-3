resource "aws_sns_topic" "terraform_notifications" {
  name = "terraform-apply-notifications"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.terraform_notifications.arn
  protocol  = "email"
  endpoint  = "flomihciu@gmail.com"
}