# Simple Example

This example illustrates how to use the `out-of-band-security` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | project resources will be deployed into | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forwarding\_rule | name of the forwarding rule created for traffic |
| instance\_template | name of the instance template |
| mig | name of managed instance group created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
