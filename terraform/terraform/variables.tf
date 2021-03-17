variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
}

variable "datacenter" {
  description = "vSphere data center"
  type        = string
}
/*
variable "cluster" {
  description = "vSphere cluster"
  type        = string
}
*/

variable "pool" {
  description = "vSphere pool"
  type        = string
}

variable "datastore" {
  description = "vSphere datastore"
  type        = string
}

variable "network_name" {
  description = "vSphere network name"
  type        = string
}

variable "template_name" {
  description = "Node template name (ie: image_path)"
  type        = string
}