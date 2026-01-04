# 🧪 Lab 13 – Terraform IAM Management with AWS

Estimated Duration: 3 hours  
Instructions: Complete all tasks using a GitHub Codespace (Linux environment) created and authenticated with the GitHub CLI.  Create a repository named `Lab13`. When finished, push your work to a repository named `CC_<student_Name>_<student_roll_number>/Lab13`.

IMPORTANT: All steps that require GH CLI / Codespace MUST be performed inside the Codespace environment.  Do not authenticate GH CLI outside the Codespace shell.

---

## 🎯 Objective

In this lab you will:  

- Use GH CLI to work inside a Codespace. 
- Create and manage IAM groups and users using Terraform.
- Attach AWS managed policies to IAM groups.
- Create login profiles for IAM users programmatically.
- Generate and manage IAM access keys.
- Implement Terraform remote state using S3 backend.
- Use CSV files to create multiple IAM users dynamically. 
- Practice Terraform provisioners with bash scripts. 

---

## Task List

In this lab you will: 

- [Task 0 - Lab Setup (Codespace & GH CLI)](#task-0-lab-setup-codespace--gh-cli)
- [Task 1 — Create IAM Group and Output Details](#task-1--create-iam-group-and-output-details)
- [Task 2 — Create IAM User with Group Membership](#task-2--create-iam-user-with-group-membership)
- [Task 3 — Attach Policies to IAM Group](#task-3--attach-policies-to-iam-group)
- [Task 4 — Create Login Profile for IAM User](#task-4--create-login-profile-for-iam-user)
- [Task 5 — Generate Access Keys for IAM User](#task-5--generate-access-keys-for-iam-user)
- [Task 6 — Implement Terraform Remote State with S3](#task-6--implement-terraform-remote-state-with-s3)
- [Task 7 — Create Multiple Users from CSV File](#task-7--create-multiple-users-from-csv-file)
- [Cleanup — Destroy Resources & Verify State](#cleanup)
- [Submission](#submission)

---

## Task 0 Lab Setup (Codespace & GH CLI)

All actions below should be executed inside the Codespace shell.

Create Codespace & connect:
```bash
# create or open codespace via GH CLI (example)
gh repo create CC_<YourName>_<YourRollNumber>/Lab13 --public
gh codespace create --repo <user_name>/Lab13
gh codespace list
gh codespace ssh -c <your_codespace_name>
```

- **Save screenshot as:** `task0_codespace_create_and_list.png` — output showing repo creation/codespace list. 
- **Save screenshot as:** `task0_codespace_ssh_connected.png` — terminal inside the Codespace shell after ssh. 

**Screenshots Required:**
- `task0_codespace_create_and_list.png`
- `task0_codespace_ssh_connected.png`

---

## Task 1 — Create IAM Group and Output Details

In this task, you will create an IAM group named "developers" and output its details.

1. Create the initial project structure:
```bash
mkdir -p ~/Lab13
cd ~/Lab13
```
- **Save screenshot as:** `task1_project_directory.png` — terminal showing directory creation.

2. Create the main Terraform file:
```bash
touch main.tf
```
- **Save screenshot as:** `task1_file_created.png` — terminal showing file creation.

3. Create `main.tf` with AWS provider configuration: 

```hcl name=main.tf
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/groups/" 
}

output "group_details" {
  value = {
    group_name = aws_iam_group.developers.name
    group_arn  = aws_iam_group.developers.arn
    unique_id  = aws_iam_group.developers.unique_id
  }
}
```
- **Save screenshot as:** `task1_main_tf. png` — content of main.tf file.

4. Initialize Terraform:
```bash
terraform init
```
- **Save screenshot as:** `task1_terraform_init.png` — terraform init output.

5. Apply the configuration:
```bash
terraform apply -auto-approve
```
- **Save screenshot as:** `task1_terraform_apply.png` — terraform apply output showing group created.

6. Display the output:
```bash
terraform output
```
- **Save screenshot as:** `task1_terraform_output.png` — terraform output showing group details.

7. Verify the group in AWS Console:
- Navigate to IAM → Groups in AWS Console
- **Save screenshot as:** `task1_aws_console_group.png` — AWS Console showing the developers group.

**Screenshots Required:**
- `task1_project_directory.png`
- `task1_file_created.png`
- `task1_main_tf.png`
- `task1_terraform_init.png`
- `task1_terraform_apply.png`
- `task1_terraform_output.png`
- `task1_aws_console_group.png`

---

## Task 2 — Create IAM User with Group Membership

In this task, you will create an IAM user named "loadbalancer" and add it to the developers group.

1. Update `main.tf` to add the IAM user resource:

```hcl name=main.tf
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/groups/" 
}

output "group_details" {
  value = {
    group_name = aws_iam_group.developers. name
    group_arn  = aws_iam_group. developers.arn
    unique_id  = aws_iam_group.developers.unique_id
  }
}

resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/users/"
  force_destroy = true
  tags = {
    DisplayName = "Load Balancer"
  }
}

resource "aws_iam_user_group_membership" "lb_membership" {
  user = aws_iam_user.lb.name
  groups = [
    aws_iam_group. developers.name
  ]
}

output "user_details" {
  value = {
    user_name = aws_iam_user.lb.name
    user_arn  = aws_iam_user.lb.arn
    unique_id = aws_iam_user.lb.unique_id
  }
}
```
- **Save screenshot as:** `task2_main_tf_user.png` — updated main.tf with user resources.

2. Apply the configuration:
```bash
terraform apply -auto-approve
```
- **Save screenshot as:** `task2_terraform_apply.png` — terraform apply output showing user created. 

3. Display the outputs:
```bash
terraform output
```
- **Save screenshot as:** `task2_terraform_output.png` — terraform output showing user and group details.

4. Verify the user in AWS Console:
- Navigate to IAM → Users in AWS Console
- Click on "loadbalancer" user
- Check the "Groups" tab
- **Save screenshot as:** `task2_aws_console_user.png` — AWS Console showing the loadbalancer user. 
- **Save screenshot as:** `task2_aws_console_user_groups.png` — AWS Console showing user's group membership.

**Screenshots Required:**
- `task2_main_tf_user.png`
- `task2_terraform_apply.png`
- `task2_terraform_output.png`
- `task2_aws_console_user.png`
- `task2_aws_console_user_groups.png`

---

## Task 3 — Attach Policies to IAM Group

In this task, you will attach AWS managed policies (AmazonEC2FullAccess and IAMUserChangePassword) to the developers group.

1. Update `main.tf` to add policy attachments:

```hcl name=main.tf
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/groups/" 
}

output "group_details" {
  value = {
    group_name = aws_iam_group.developers.name
    group_arn  = aws_iam_group.developers.arn
    unique_id  = aws_iam_group.developers.unique_id
  }
}

resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/users/"
  force_destroy = true
  tags = {
    DisplayName = "Load Balancer"
  }
}

resource "aws_iam_user_group_membership" "lb_membership" {
  user = aws_iam_user.lb.name
  groups = [
    aws_iam_group.developers.name
  ]
}

output "user_details" {
  value = {
    user_name = aws_iam_user.lb.name
    user_arn  = aws_iam_user.lb.arn
    unique_id = aws_iam_user.lb.unique_id
  }
}

resource "aws_iam_group_policy_attachment" "developer_ec2_fullaccess" {
    group = aws_iam_group.developers.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "change_password" {
     group = aws_iam_group.developers.name
     policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}
```
- **Save screenshot as:** `task3_main_tf_policies.png` — updated main.tf with policy attachments.

2. Apply the configuration:
```bash
terraform apply -auto-approve
```
- **Save screenshot as:** `task3_terraform_apply.png` — terraform apply output showing policies attached.

3. Verify policies in AWS Console:
- Navigate to IAM → Groups → developers
- Click on "Permissions" tab
- **Save screenshot as:** `task3_aws_console_policies.png` — AWS Console showing attached policies.

**Screenshots Required:**
- `task3_main_tf_policies.png`
- `task3_terraform_apply.png`
- `task3_aws_console_policies.png`

---

## Task 4 — Create Login Profile for IAM User

In this task, you will create a login profile for the loadbalancer user using a bash script and null_resource provisioner.

1. Create `variables.tf` file:

```hcl name=variables.tf
variable "iam_password" {
  description = "Temporary password for the IAM user"
  type        = string
  sensitive   = true
  default = "1dontKnow"
}
```
- **Save screenshot as:** `task4_variables_tf.png` — content of variables.tf file.

2. Create the bash script `create-login-profile.sh`:

```bash name=create-login-profile.sh
#!/usr/bin/env bash
set -euo pipefail

USERNAME="$1"
PASSWORD="$2"

# Check if login profile already exists
if aws iam get-login-profile --user-name "$USERNAME" >/dev/null 2>&1; then
  echo "Login profile already exists for $USERNAME.  Skipping."
else
  echo "Creating login profile for $USERNAME"
  aws iam create-login-profile \
    --user-name "$USERNAME" \
    --password "$PASSWORD" \
    --password-reset-required
fi
```
- **Save screenshot as:** `task4_create_login_script.png` — content of create-login-profile.sh.

3. Make the script executable:
```bash
chmod +x create-login-profile.sh
```
- **Save screenshot as:** `task4_chmod_script.png` — terminal showing chmod command.

4. Update `main.tf` to add the null_resource provisioner:

Add this resource after the user creation:

```hcl
resource "null_resource" "create_login_profile" {
  triggers = {
    password_hash = sha256(var.iam_password)
    user          = aws_iam_user.lb.name
  }

  depends_on = [aws_iam_user. lb]

  provisioner "local-exec" {
    command = "${path.module}/create-login-profile.sh ${aws_iam_user.lb.name} '${var.iam_password}'"
  }
}
```
- **Save screenshot as:** `task4_main_tf_login_profile.png` — main.tf showing null_resource. 

5. Apply the configuration with a custom password:
```bash
terraform apply -auto-approve -var="iam_password=MySecurePass123!"
```
- **Save screenshot as:** `task4_terraform_apply.png` — terraform apply output showing login profile creation.

6. Verify login profile creation:
```bash
aws iam get-login-profile --user-name loadbalancer
```
- **Save screenshot as:** `task4_aws_cli_verify.png` — AWS CLI output showing login profile.

7. Test login in AWS Console:
- Open AWS Console login page
- Sign in as IAM user with username "loadbalancer" and the password you set
- You should be prompted to change password
- **Save screenshot as:** `task4_aws_console_login.png` — AWS Console login page with IAM user. 
- **Save screenshot as:** `task4_aws_console_password_reset.png` — Password reset prompt.

**Screenshots Required:**
- `task4_variables_tf.png`
- `task4_create_login_script.png`
- `task4_chmod_script.png`
- `task4_main_tf_login_profile.png`
- `task4_terraform_apply.png`
- `task4_aws_cli_verify.png`
- `task4_aws_console_login.png`
- `task4_aws_console_password_reset.png`

---

## Task 5 — Generate Access Keys for IAM User

In this task, you will create access keys for the loadbalancer user and view them in terraform state.

1. Update `main.tf` to add access key resource and outputs:

Add these resources: 

```hcl
resource "aws_iam_access_key" "lb_access_key" {
  user = aws_iam_user.lb.name
}

output "access_key_id" {
  value = aws_iam_access_key.lb_access_key.id
}

output "access_key_secret" {
  value     = aws_iam_access_key.lb_access_key. secret
  sensitive = true
}
```
- **Save screenshot as:** `task5_main_tf_access_keys.png` — main.tf showing access key resources.

2. Apply the configuration:
```bash
terraform apply -auto-approve -var="iam_password=MySecurePass123!"
```
- **Save screenshot as:** `task5_terraform_apply.png` — terraform apply output showing access key created.

3. Display outputs:
```bash
terraform output
```
- **Save screenshot as:** `task5_terraform_output.png` — terraform output showing access_key_id but hidden secret.

4. View the secret in terraform state:
```bash
cat terraform.tfstate | grep -A 10 "access_key_secret"
```
- **Save screenshot as:** `task5_tfstate_secret.png` — terraform.tfstate showing access key secret.

5. Verify access key in AWS Console:
- Navigate to IAM → Users → loadbalancer → Security credentials
- **Save screenshot as:** `task5_aws_console_access_keys.png` — AWS Console showing access keys.

**Screenshots Required:**
- `task5_main_tf_access_keys.png`
- `task5_terraform_apply.png`
- `task5_terraform_output.png`
- `task5_tfstate_secret. png`
- `task5_aws_console_access_keys. png`

---

## Task 6 — Implement Terraform Remote State with S3

In this task, you will configure Terraform to use S3 backend for remote state storage.

1. Create S3 bucket in AWS Console:
- Navigate to S3 in AWS Console
- Click "Create bucket"
- Bucket name: `myapp-s3-bucket-demo` (use a unique name if this is taken)
- Enable versioning
- Keep other settings as default
- Click "Create bucket"
- **Save screenshot as:** `task6_s3_bucket_create.png` — S3 bucket creation page. 
- **Save screenshot as:** `task6_s3_bucket_versioning.png` — S3 bucket with versioning enabled.

2. Update `main.tf` to add S3 backend configuration:

Add this at the beginning of main.tf (before the provider block):

```hcl
terraform {
  backend "s3" {
    bucket = "myapp-s3-bucket-demo"
    key    = "myapp/terraform.tfstate"
    region = "me-central-1"
    encrypt = true
    use_lockfile = true
  }
}
```
- **Save screenshot as:** `task6_main_tf_backend. png` — main.tf showing backend configuration.

3. Reinitialize Terraform with the backend:
```bash
terraform init -migrate-state
```
- Type `yes` when prompted to migrate state
- **Save screenshot as:** `task6_terraform_init_migrate.png` — terraform init output showing state migration.

4. Apply the configuration:
```bash
terraform apply -auto-approve -var="iam_password=MySecurePass123!"
```
- **Save screenshot as:** `task6_terraform_apply.png` — terraform apply with remote state.

5. Verify state file in S3:
- Navigate to S3 → myapp-s3-bucket-demo → myapp/
- You should see terraform.tfstate file
- **Save screenshot as:** `task6_s3_tfstate_file.png` — S3 bucket showing terraform.tfstate file.

6. Check local state file:
```bash
ls -la terraform.tfstate*
```
- **Save screenshot as:** `task6_local_state_backup.png` — showing local state backup file.

7.  Destroy resources and verify state change:
```bash
terraform destroy -auto-approve
```
- **Save screenshot as:** `task6_terraform_destroy.png` — terraform destroy output.

8. Verify updated state in S3:
- Refresh S3 bucket view
- Check the terraform.tfstate file (it should show empty resources)
- **Save screenshot as:** `task6_s3_tfstate_destroyed.png` — S3 state file after destroy.

**Screenshots Required:**
- `task6_s3_bucket_create.png`
- `task6_s3_bucket_versioning.png`
- `task6_main_tf_backend.png`
- `task6_terraform_init_migrate.png`
- `task6_terraform_apply.png`
- `task6_s3_tfstate_file.png`
- `task6_local_state_backup.png`
- `task6_terraform_destroy.png`
- `task6_s3_tfstate_destroyed. png`

---

## Task 7 — Create Multiple Users from CSV File

In this task, you will create multiple IAM users dynamically from a CSV file.

1. Create `locals.tf` file:

```hcl name=locals.tf
locals {
  users = csvdecode(file("users.csv"))
}
```
- **Save screenshot as:** `task7_locals_tf.png` — content of locals.tf file.

2. Create `users.csv` file:

```csv name=users.csv
user_name
Michael
Dwight
Jim
Pam
Ryan
Andy
Robert
Stanley
Kevin
Angela
Oscar
Phyllis
Toby
Kelly
Darryl
Creed
Meredith
Erin
Gabe
Jan
David
Holly
Charles
Jo
Clark
Peter
```
- **Save screenshot as:** `task7_users_csv.png` — content of users.csv file.

3. Update `main.tf` to create multiple users:

Replace the single user resources with: 

```hcl
# Create multiple IAM users from CSV
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

# Add all users to developers group
resource "aws_iam_user_group_membership" "users_membership" {
  for_each = aws_iam_user.users
  
  user = each.value.name
  groups = [
    aws_iam_group.developers.name
  ]
}

# Create login profiles for all users
resource "null_resource" "create_login_profiles" {
  for_each = aws_iam_user.users
  
  triggers = {
    password_hash = sha256(var. iam_password)
    user          = each.value.name
  }

  depends_on = [aws_iam_user. users]

  provisioner "local-exec" {
    command = "${path. module}/create-login-profile. sh ${each.value.name} '${var.iam_password}'"
  }
}

# Create access keys for all users
resource "aws_iam_access_key" "users_access_keys" {
  for_each = aws_iam_user. users
  
  user = each.value.name
}

# Output all user details
output "all_users_details" {
  value = {
    for user_name, user in aws_iam_user.users : user_name => {
      user_arn         = user.arn
      user_unique_id   = user.unique_id
      access_key_id    = aws_iam_access_key.users_access_keys[user_name].id
    }
  }
}

# Output all access key secrets (sensitive)
output "all_access_key_secrets" {
  value = {
    for user_name, key in aws_iam_access_key.users_access_keys :  user_name => key.secret
  }
  sensitive = true
}
```
- **Save screenshot as:** `task7_main_tf_multiple_users.png` — main.tf showing multiple user resources.

4. Reinitialize Terraform (since we changed the configuration significantly):
```bash
terraform init
```
- **Save screenshot as:** `task7_terraform_init.png` — terraform init output.

5. Apply the configuration to create all users:
```bash
terraform apply -auto-approve -var="iam_password=MySecurePass123!"
```
- **Save screenshot as:** `task7_terraform_apply.png` — terraform apply output showing all users being created.

6. Display the outputs:
```bash
terraform output
```
- **Save screenshot as:** `task7_terraform_output.png` — terraform output showing all user details.

7. View secrets in terraform. tfstate:
```bash
cat terraform.tfstate | grep -A 5 "all_access_key_secrets"
```
- **Save screenshot as:** `task7_tfstate_secrets.png` — terraform.tfstate showing access key secrets.

8. Verify all users in AWS Console:
- Navigate to IAM → Users
- **Save screenshot as:** `task7_aws_console_all_users.png` — AWS Console showing all created users.

9. Verify group membership:
- Navigate to IAM → Groups → developers → Users tab
- **Save screenshot as:** `task7_aws_console_group_members.png` — AWS Console showing all users in developers group.

10. Verify one user's access keys:
- Click on any user (e.g., "Michael")
- Go to Security credentials tab
- **Save screenshot as:** `task7_aws_console_user_access_key.png` — AWS Console showing user's access key.

11. Check terraform state in S3:
- Navigate to S3 bucket and view the state file
- **Save screenshot as:** `task7_s3_tfstate_multiple_users.png` — S3 showing updated state file.

**Screenshots Required:**
- `task7_locals_tf.png`
- `task7_users_csv.png`
- `task7_main_tf_multiple_users.png`
- `task7_terraform_init.png`
- `task7_terraform_apply.png`
- `task7_terraform_output.png`
- `task7_tfstate_secrets. png`
- `task7_aws_console_all_users. png`
- `task7_aws_console_group_members. png`
- `task7_aws_console_user_access_key.png`
- `task7_s3_tfstate_multiple_users.png`

---

## Cleanup

1.  Destroy all resources:
```bash
terraform destroy -auto-approve
```
- **Save screenshot as:** `cleanup_destroy_complete.png` — terraform destroy completion output.

2. Verify users deleted in AWS Console:
- Navigate to IAM → Users
- **Save screenshot as:** `cleanup_aws_console_users_deleted.png` — AWS Console showing no users. 

3. Verify group deleted in AWS Console:
- Navigate to IAM → Groups
- **Save screenshot as:** `cleanup_aws_console_group_deleted.png` — AWS Console showing developers group deleted.

4. Check S3 state file:
- Navigate to S3 bucket
- **Save screenshot as:** `cleanup_s3_empty_state.png` — S3 showing empty state. 

5. List all project files:
```bash
ls -la
```
- **Save screenshot as:** `cleanup_final_files.png` — showing final project structure.

6. (Optional) Delete S3 bucket:
- If you want to clean up completely, delete the S3 bucket from AWS Console
- **Save screenshot as:** `cleanup_s3_bucket_deleted. png` — S3 bucket deletion confirmation.

**Screenshots Required:**
- `cleanup_destroy_complete.png`
- `cleanup_aws_console_users_deleted.png`
- `cleanup_aws_console_group_deleted.png`
- `cleanup_s3_empty_state.png`
- `cleanup_final_files.png`
- `cleanup_s3_bucket_deleted.png` (optional)

---

## Submission

Create and push a repository named:  

`CC_<YourName>_<YourRollNumber>/Lab13`

Repository structure:  

```
Lab13/
  main.tf
  variables.tf
  locals.tf
  users.csv
  create-login-profile.sh
  .gitignore
  screenshots/                  # include ALL screenshots listed in this lab (Optional)
  Lab13.md                      # this lab manual
  Lab13_solution.docx           # lab solution in MS Word
  Lab13_solution.pdf            # lab solution in PDF
```

Important:  Do NOT commit AWS credentials, terraform.tfstate, or terraform.tfstate.backup.  Make sure . gitignore includes these files.

Create `.gitignore`:
```gitignore name=.gitignore
.terraform/*
*.tfstate
*.tfstate.*
*.tfvars
.terraform.lock.hcl
. aws/
~/.aws/
```

Push to GitHub:
```bash
git init
git add . 
git commit -m "Lab 13: Terraform IAM Management completed"
git branch -M main
git remote add origin https://github.com/<YourUsername>/CC_<YourName>_<YourRollNumber>. git
git push -u origin main/Lab13
```

---

## Notes & Tips

- Always work inside the Codespace (GH CLI) for this lab. 
- Do not commit AWS credentials, secrets, or state files.
- Use `terraform plan` to preview changes before applying.
- Make sure to capture all screenshots at the appropriate steps.
- The `force_destroy = true` flag ensures users can be deleted even if they have access keys or login profiles.
- AWS IAM changes may take a few seconds to propagate. 
- When using S3 backend, make sure your bucket name is globally unique.
- The CSV file approach demonstrates Infrastructure as Code at scale. 
- Sensitive outputs are hidden in console but visible in state file - handle with care. 
- Use strong passwords in production environments.

Good luck — follow steps carefully, capture all required screenshots, and push your Lab13 repository to GitHub as `CC_<YourName>_<YourRollNumber>/Lab13`.

---

## Summary of Tasks

| Task | Description | Key Concepts |
|------|-------------|--------------|
| 0 | Lab Setup | GitHub Codespaces, GH CLI |
| 1 | Create IAM Group | IAM groups, Terraform outputs |
| 2 | Create IAM User | IAM users, group membership |
| 3 | Attach Policies | AWS managed policies, group permissions |
| 4 | Create Login Profile | Bash scripting, null_resource, local-exec |
| 5 | Generate Access Keys | IAM access keys, sensitive data handling |
| 6 | Remote State with S3 | S3 backend, state migration, versioning |
| 7 | Multiple Users from CSV | Dynamic resources, for_each, CSV parsing |

---

## Learning Outcomes

By completing this lab, you will have learned:

1. **IAM Management**:  How to create and manage AWS IAM users and groups using Terraform
2. **Policy Management**: How to attach AWS managed policies to groups
3. **Authentication**: How to create login profiles and access keys programmatically
4. **Remote State**: How to implement Terraform remote state using S3 for team collaboration
5. **Dynamic Resources**: How to use CSV files and for_each to create multiple resources
6. **Provisioners**: How to use null_resource and local-exec for custom scripts
7. **Security Best Practices**: Understanding sensitive data handling in Terraform
8. **Infrastructure as Code**: Managing identity and access at scale with code

---

## Additional Challenges (Optional)

If you finish early, try these additional challenges:

1. **Password Rotation**: Modify the script to rotate passwords for all users
2. **Custom Policies**: Create and attach custom IAM policies instead of managed ones
3. **MFA Enforcement**: Add a policy that requires MFA for console access
4. **User Tags**: Add more metadata tags to users from the CSV file
5. **Email Notifications**: Send email notifications when users are created (using SNS)
6. **Audit Logging**: Enable CloudTrail to log all IAM activities

---
