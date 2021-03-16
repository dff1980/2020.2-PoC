# Create VMware vSphere RKE cluster using Terraform

## Install Terraform at admin node
```
SUSEConnect --product sle-module-public-cloud/15.2/x86_64
zypper in terraform
```

make directory terraform-admin

```
mkdir -p terraform-admin
```

create file main.tf in terraform-admin

```
cd terraform-admin
cat << EOF > main.tf
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "1.24.3"
    }
  }
}

provider "vsphere" {
  # Configuration options
}
EOF
```
terraform init


