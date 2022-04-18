output "custom_sms_sender_arn" {
  value = data.aws_lambda_alias.custom_sms_sender.arn
}

output "custom_sms_sender_function_arn" {
  value = data.aws_lambda_function.custom_sms_sender_function.arn
}