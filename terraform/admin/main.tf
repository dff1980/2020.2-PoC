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
