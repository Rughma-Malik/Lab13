
terraform {

  backend "s3" {

    bucket       = "myapp-s3-bucket-demo-rughma"

    key          = "myapp/terraform.tfstate"

    region       = "me-central-1"

    encrypt      = true

    use_lockfile = true

  }

}



provider "aws" {

  shared_config_files      = ["~/.aws/config"]

  shared_credentials_files = ["~/.aws/credentials"]

  region                   = "me-central-1"

}



# --- Dynamic Resources for Task 7 ---



resource "aws_iam_group" "developers" {

  name = "developers"

  path = "/groups/" 

}



# 1. Create multiple IAM users from CSV

resource "aws_iam_user" "users" {

  for_each = { for user in local.users : user.user_name => user }

  

  name          = each.value.user_name

  path          = "/users/"

  force_destroy = true

  

  tags = {

    DisplayName = each.value.user_name

    CreatedBy   = "Terraform"

  }

}



# 2. Add all users to developers group

resource "aws_iam_user_group_membership" "users_membership" {

  for_each = aws_iam_user.users

  

  user = each.value.name

  groups = [

    aws_iam_group.developers.name

  ]

}



# 3. Create login profiles for all users

resource "null_resource" "create_login_profiles" {

  for_each = aws_iam_user.users

  

  triggers = {

    password_hash = sha256(var.iam_password)

    user          = each.value.name

  }



  depends_on = [aws_iam_user.users]



  provisioner "local-exec" {

    command = "${path.module}/create-login-profile.sh ${each.value.name} '${var.iam_password}'"

  }

}



# 4. Create access keys for all users

resource "aws_iam_access_key" "users_access_keys" {

  for_each = aws_iam_user.users

  

  user = each.value.name

}



# --- Dynamic Outputs ---



output "all_users_details" {

  value = {

    for user_name, user in aws_iam_user.users : user_name => {

      user_arn       = user.arn

      user_unique_id = user.unique_id

      access_key_id  = aws_iam_access_key.users_access_keys[user_name].id

    }

  }

}



output "all_access_key_secrets" {

  value = {

    for user_name, key in aws_iam_access_key.users_access_keys : user_name => key.secret

  }

  sensitive = true

}

