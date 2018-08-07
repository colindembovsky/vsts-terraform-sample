# Demo Repo for Terraform and VSTS
This demo repo is the source code for my blogpost [Terraform all the Things with VSTS](https://colinsalmcorner.com/---).

## Working with the Repo
In order to work with this repo, clone it and then do the following:

1. Create the backend storage account.
    1. Open `state\state.tf` and comment out the `backend` block.
    1. Update the variables in `variables.tf` (or you can override them on the command line).
    1. Run `terraform apply`. This creates a storage account and outputs the `access_key`.
    1. Uncomment the `backend` block in the `state.tf` file, using values you supplied for the `terraform apply` command.
    1. Run `terraform init`, and enter `yes` to copy your local state.
1. Add `backend.tfvars` and `secrets.tfvars` to the root folder (these are ignored in the `.gitignore` file). Format of these files is listed below. Copy the `access_key` output from the state `terraform apply` command into the `backend.tfvars` file.
1. Enter secrets for the database passwords into `secrets.tfvars`.
1. For each stack (folder):
    1. Create a workspace (environment). `terraform workspace new dev` to create a `dev` workspace. If it already exists, then just select it using `terraform workspace select dev`.
    1. Run `terraform init` - this should sync to the backend state.
    1. Run `terraform apply`
1. `release.tfvars` is a template file for variables during release. If you add additional variables, remember to add the tokenized values in this file. For more info, see the blog post.

## Secrets Files
### backend.tfvars
```
access_key = "long_key_from_azure_storage_acc"
```

### secrets.tfvars
```
secrets = {
  dev = {
    sql_admin_password = "ThisIsASuperL0ngP@sswordThatShouldBeSecure1"
  }

  uat = {
    sql_admin_password = "ThisIsASuperL0ngUATP@sswordThatShouldBeSecure1"
  }
}
```