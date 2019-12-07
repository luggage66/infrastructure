Create a file `terraform/envronment.sh` and put in it:

```sh
export TF_VAR_org_id={your order id}
export TF_VAR_billing_account={your billing account}
export TF_ADMIN={admin project name}
export TF_CREDS=~/.config/gcloud/${TF_ADMIN}.json

export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}
```