Create a file `terraform/envronment.sh` and put in it:

```sh
export TF_VAR_org_id="your org id"
export TF_VAR_billing_account="your billing account"

export TF_ADMIN="tfstate project name"
export TF_CREDS=~/.config/gcloud/${TF_ADMIN}.json

export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}

export TF_VAR_root_dns_hostname="your root dns name"
```