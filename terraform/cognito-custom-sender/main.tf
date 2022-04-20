provider "aws" {
  profile = "default"
  region = "ap-northeast-1"
}

#provider "archive" {}

#data "aws_caller_identity" "current" {}

#resource "aws_cognito_user_pool" "cognito_user_pool" {
#  name = "${var.project}-cognito-user-pool"
#
#  account_recovery_setting {
#    recovery_mechanism {
#      name     = "verified_email"
#      priority = 1
#    }
#  }
#
#  auto_verified_attributes = ["email"]
#
#  password_policy {
#    minimum_length = 10
#    temporary_password_validity_days = 7
#    require_lowercase = false
#    require_numbers                  = false
#    require_symbols                  = false
#    require_uppercase                = false
#  }
#
#  schema {
#    attribute_data_type = "String"
#    developer_only_attribute = false
#    mutable             = true
#    name                = "email"
#    required            = true
#
#    string_attribute_constraints {
#      max_length = "2048"
#      min_length = "0"
#    }
#  }
#
#  schema {
#    attribute_data_type = "String"
#    developer_only_attribute = false
#    mutable             = true
#    name                = "name"
#    required            = true
#
#    string_attribute_constraints {
#      max_length = "2048"
#      min_length = "0"
#    }
#  }
#
#  username_attributes = ["email"]
#  username_configuration {
#    case_sensitive = false
#  }
#}
#
#resource "aws_cognito_user_pool_client" "cognito_user_pool_client" {
#  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
#  name = "${var.project}-cognito-user-pool-client"
#
#  generate_secret = false
#  prevent_user_existence_errors = "ENABLED"
#  supported_identity_providers = ["COGNITO"]
#}

#resource "aws_kms_key" "kms_key" {
#  description             = "KMS key for Cognito Lambda trigger"
#  policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#            },
#            "Action": "kms:*",
#            "Resource": "*"
#        },
#        {
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "${data.aws_caller_identity.current.arn}"
#            },
#            "Action": [
#                "kms:Create*",
#                "kms:Describe*",
#                "kms:Enable*",
#                "kms:List*",
#                "kms:Put*",
#                "kms:Update*",
#                "kms:Revoke*",
#                "kms:Disable*",
#                "kms:Get*",
#                "kms:Delete*",
#                "kms:TagResource",
#                "kms:UntagResource",
#                "kms:ScheduleKeyDeletion",
#                "kms:CancelKeyDeletion"
#            ],
#            "Resource": "*"
#        }
#    ]
#}
#EOF
#}

#data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
#  version = "2012-10-17"
#  statement {
#    actions    = ["sts:AssumeRole"]
#    effect     = "Allow"
#    principals {
#      type        = "Service"
#      identifiers = ["lambda.amazonaws.com"]
#    }
#  }
#}

#resource "aws_iam_role" "iam_role" {
#  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
#  name = "${var.project}-iam-role-lambda-trigger"
#}


#resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_basic_execution" {
#  role       = aws_iam_role.iam_role.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#}

#data "aws_iam_policy_document" "iam_policy_document_lambda_kms" {
#  version = "2012-10-17"
#  statement {
#    actions    = ["kms:Decrypt"]
#    effect     = "Allow"
#    resources = [
#      aws_kms_key.kms_key.arn
#    ]
#  }
#}

#resource "aws_iam_role_policy" "iam_role_policy_lambda_kms" {
#  name = "${var.project}-iam-role-policy-lambda-kms"
#  role       = aws_iam_role.iam_role.name
#  policy = data.aws_iam_policy_document.iam_policy_document_lambda_kms.json
#}

#data "archive_file" "lambda" {
#  type        = "zip"
#  source_dir  = "../lambda"
#  output_path = "lambda.zip"
#}

#resource "aws_lambda_function" "lambda_function_trigger" {
#  environment {
#    variables = {
#      KEY_ID = aws_kms_key.kms_key.arn
#      SENDGRID_API_KEY = var.sendgrid_api_key
#    }
#  }
#  code_signing_config_arn = ""
#  description = ""
#  filename         = data.archive_file.lambda.output_path
#  function_name    = "${var.project}-lambda-function-trigger"
#  role             = aws_iam_role.iam_role.arn
#  handler          = "index.handler"
#  runtime          = "nodejs12.x"
#  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
#}

#resource "aws_lambda_permission" "lambda_permission_cognito" {
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.lambda_function_trigger.function_name
#  principal     = "cognito-idp.amazonaws.com"
#  source_arn = aws_cognito_user_pool.cognito_user_pool.arn
#}

locals {
  custom_sms_sender_lambda = "MyntJpSMSSenderFunction"
  custom_sms_sender_alias  = "MyntJpSMSSenderFunction"
}

data "aws_lambda_alias" "custom_sms_sender" {
  name          = local.custom_sms_sender_alias
  function_name = local.custom_sms_sender_lambda
}

data "aws_lambda_function" "custom_sms_sender_function" {
#  function_name = local.custom_sms_sender_lambda
  function_name = "MyntJpSMSSenderFunctionTest"
}

locals {
#  custom_sms_sender_lambda_full_arn = "arn:aws:lambda:ap-northeast-1:420903242724:function:mynt-jp-sms-sender-lambda-s-myntCustomSMSSenderSam-RIWc0YeBYhdQ"
#  custom_sms_sender_lambda_full_arn = "arn:aws:lambda:ap-northeast-1:420903242724:function:MyntJpSMSSenderFunction"
  # My private aws account
#  kms_key  = "arn:aws:kms:ap-northeast-1:420903242724:key/f0b22564-1667-43d3-a9d9-c87fb713591c"
#  cognito_id = "ap-northeast-1_pYUwr1ixO"

  # NGH dev env (same as /jp/insights-staging/cognito/custom_lambda_kms_arn ssm parameter store value)
  kms_key  = "arn:aws:kms:ap-northeast-1:086139024273:key/9ee3b116-0dcf-4ee2-8aa8-0db5f53fce63"
  # rmi-auto-deploy-test
  cognito_id = "ap-northeast-1_KVtzDa946"
}

locals {
#  update_user_pool_command = "aws cognito-idp update-user-pool --user-pool-id ${local.cognito_id} --lambda-config \"CustomSMSSender={LambdaVersion=V1_0,LambdaArn=${local.custom_sms_sender_lambda_full_arn}},KMSKeyID=${local.kms_key}\""
#  update_user_pool_command = "aws cognito-idp update-user-pool --user-pool-id ${local.cognito_id} --lambda-config \"CustomSMSSender={LambdaVersion=V1_0,LambdaArn=${data.aws_lambda_alias.custom_sms_sender.arn}},KMSKeyID=${local.kms_key}\""

# Update
  update_user_pool_command = "aws cognito-idp update-user-pool --user-pool-id ${local.cognito_id} --lambda-config \"CustomSMSSender={LambdaVersion=V1_0,LambdaArn=${data.aws_lambda_function.custom_sms_sender_function.arn}},KMSKeyID=${local.kms_key}\""

}

resource "null_resource" "cognito_user_pool_lambda_config" {
  provisioner "local-exec" {
    command = local.update_user_pool_command
  }
  depends_on = [local.update_user_pool_command]
  triggers = {
    update_user_pool_command = local.update_user_pool_command
  }
}
