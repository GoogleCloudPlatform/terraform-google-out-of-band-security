# Terraform Google Out-of-Band Security

## Description
### Tagline
Create a deployment with an Out of Band Security Appliance.

### Detailed
This solution aids in the creation and management of scalable Terraform Deployments of VM-based Third Party Security Appliances which inspect mirrored traffic.

### PreDeploy
To deploy this blueprint you must have an active billing account and billing permissions.

## Architecture
- [Architecture Diagram](assets/3P_data_plane.png)
This module will create VM instances inside a Managed Instance Group which will have autoscaling, health checks, backend service and forwarding rule attached. The VM instances will be placed in a new VPC that can be peered with a customer VPC for packet mirroring.

## Usage

Basic usage of this module is as follows:

```hcl
module "out_of_band_security" {
  source  = "terraform-google-modules/out-of-band-security/google"
  version = "~> 0.1"

  project_id  = "<PROJECT ID>"
  naming_prefix = "example-prefix"
  source_image = "https://www.exampleapis.com/path_to_img"
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| block\_project\_ssh\_keys | Ability for customers to block or allow the use of project-wide ssh keys in their VM. | `bool` | `false` | no |
| compute\_instance\_metadata | Key/value pairs that are made available within each VM instance. | `map(string)` | `{}` | no |
| cpu\_target | CPU target for autoscaling | `number` | `0.75` | no |
| create\_public\_management\_ip | Allow the creation of a public IP address for the management interface of each VM. IP will be ephemeral instead of static. | `bool` | `false` | no |
| machine\_type | type for default compute instances | `string` | `"n1-standard-4"` | no |
| max\_instances | Max compute instances in the cluster | `number` | `3` | no |
| mgmt\_network | management vpc name | `string` | `"default"` | no |
| mgmt\_subnet | Management subnet name | `string` | `"default"` | no |
| min\_instances | Max compute instances in the cluster | `number` | `2` | no |
| naming\_prefix | prefix string to be appended in front of all deployed resources so they can be easily traced back to deployment assistant | `string` | n/a | yes |
| project\_id | project resources will be deployed into | `string` | n/a | yes |
| region | Region for deployment | `string` | `"us-central1"` | no |
| source\_image | source image for firewall instance template | `string` | `"projects/centos-cloud/global/images/centos-stream-8-v20230509"` | no |
| traffic\_subnet\_cidr | Traffic subnet cidr | `string` | `"10.127.10.0/24"` | no |
| zones | Zones for deployment as a comma separated string so it can make it through SLM | `list(string)` | <pre>[<br>  "us-central1-a",<br>  "us-central1-b",<br>  "us-central1-c"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| forwarding\_rule | name of the forwarding rule created for traffic |
| instance\_template | name of the instance template |
| mig | name of managed instance group created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Storage Admin: `roles/storage.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Compute JSON API: `compute.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).
